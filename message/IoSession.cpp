
#include "IoSession.h"
#include "IoServer.h"
#include <QDebug>

int IOSession::m_sCount = 0;

IOSession::IOSession(boost::asio::io_service& work_service, boost::asio::io_service& io_service, QObject* qObj)
    :  QObject(qObj), socket_(io_service), io_work_service(work_service)
{
    pServer_ = NULL;

    m_nIndex = m_sCount++;
}

IOSession::~IOSession()
{

}

tcp::socket& IOSession::socket()
{
    return socket_;
}

void IOSession::SetServer(IOServer* pServer)
{
    pServer_ = pServer;
}


void IOSession::start()
{
    boost::system::error_code error;
    //handle_write(error);

//    socket_.async_read_some(boost::asio::buffer(data_),
//        make_custom_alloc_handler(allocator_,
//        boost::bind(&session::handle_read,
//        shared_from_this(),
//        boost::asio::placeholders::error,
//        boost::asio::placeholders::bytes_transferred)));

    qtMessage* pMessage = pServer_->pMessagePool_->GetQtMessage();
    if (pMessage == NULL)
    {
        pServer_->ReleaseSession(this);
        return;
    }
    pMessage->setSession(this);
    //请求数据包
//    socket_.async_receive(boost::asio::buffer(pMessage->WritePosRef(), pMessageParse_->GetConstHeaderLength()),
//        boost::bind(&IOSession::handle_read_head, this,
//        pMessage, boost::asio::placeholders::bytes_transferred, boost::asio::placeholders::error));

     boost::asio::async_read(socket_, boost::asio::buffer(pMessage->WritePosRef(), pServer_->pMessageParse_->GetConstHeaderLength()),
                             boost::bind(&IOSession::handle_read_head, this,
                             pMessage, boost::asio::placeholders::bytes_transferred, boost::asio::placeholders::error));

}

//读取消息头
void IOSession::handle_read_head(qtMessage* pMsg, size_t nTransSize, const boost::system::error_code& error)
{
    if (!error)
    {
        pMsg->WritePos((int)nTransSize);
        qDebug() << "head size:" << nTransSize;
//        socket_.async_receive(boost::asio::buffer(pMsg->WritePosRef(), pMessageParse_->GetBodyLength(pMsg)),
//            boost::bind(&IOSession::handle_read_body, this,
//            pMsg, boost::asio::placeholders::bytes_transferred, boost::asio::placeholders::error));

        boost::asio::async_read(socket_, boost::asio::buffer(pMsg->WritePosRef(), pServer_->pMessageParse_->GetBodyLength(pMsg)),
                                boost::bind(&IOSession::handle_read_body, this,
                                pMsg, boost::asio::placeholders::bytes_transferred, boost::asio::placeholders::error));
    }
    else
    {
//        m_nAsyncReadCount--;
//        pMsg->Release();
//        this->OnClose(error.value());
        pMsg->Release();
        pServer_->ReleaseSession(this);
        qDebug() << "socket close:" << error.value() << error.message().c_str();
    }
}

//读取消息体
void IOSession::handle_read_body(qtMessage* pMsg, size_t nTransSize, const boost::system::error_code& error)
{
    if (!error)
    {
        qDebug() << "body size:" << nTransSize;
        pMsg->WritePos((int)nTransSize);
        pServer_->pMessageQueue_->SubmitMessage(pMsg);

        qtMessage* pMessage = pServer_->pMessagePool_->GetQtMessage();
        if (pMessage == NULL)
        {
            return;
        }
        pMessage->setSession(this);

        //请求数据包
//        socket_.async_receive(boost::asio::buffer(pMessage->WritePosRef(), pServer_->pMessageParse_->GetConstHeaderLength()),
//            boost::bind(&IOSession::handle_read_head, this,
//            pMessage, boost::asio::placeholders::bytes_transferred, boost::asio::placeholders::error));

        boost::asio::async_read(socket_, boost::asio::buffer(pMessage->WritePosRef(), pServer_->pMessageParse_->GetConstHeaderLength()),
                                boost::bind(&IOSession::handle_read_head, this,
                                pMessage, boost::asio::placeholders::bytes_transferred, boost::asio::placeholders::error));
    }
    else
    {
//        HD_ERROR(HD_NET, "async read exception, close socket!\n");
//        this->OnClose(HD_ENO_NET_ERROR);
//        return HD_ENO_FALSE;
        pMsg->Release();
        pServer_->ReleaseSession(this);
        qDebug() << "socket close:" << error.value() << error.message().c_str();
    }
}

void IOSession::stop()
{
    socket_.close();
}

void IOSession::asynWrite(qtMessage* pMsg)
{
    boost::mutex::scoped_lock lock(m_mutex);

    boost::asio::async_write(socket_, boost::asio::buffer(pMsg->m_data.data(), pMsg->m_nWritePos),
                              boost::asio::transfer_at_least(pMsg->m_nWritePos),
                              boost::bind(&IOSession::handle_write,
                                          this,  pMsg,
                                          boost::asio::placeholders::bytes_transferred,
                                          boost::asio::placeholders::error ));
}

void IOSession::handle_write(qtMessage* pMsg, size_t nTransSize, const boost::system::error_code& error)
{
    if (!error)
    {
        if(nTransSize > 0)
        {
            pMsg->Release();
        }
    }
    else
    {
        pMsg->Release();
        pServer_->ReleaseSession(this);
        qDebug() << "socket close:" << error.value() << error.message().c_str();
    }
}


