﻿#include "TermServiceKeda.h"
/*------------------------------------------------------------------
TermServiceMsgProcessKeda
------------------------------------------------------------------*/

TermServiceWorkKeda::TermServiceWorkKeda(void)
{

}

TermServiceWorkKeda::~TermServiceWorkKeda(void)
{
}

bool TermServiceWorkKeda::Work(qtMessage* pMsg)
{
    unsigned char* pByte = (unsigned char*)pMsg->m_data.data();
    QByteArray reply;

    //网络阻塞暂时不处理
    int res = CheckMsg(pMsg);
    if(res == -1)
    {
        qDebug() << "data error, flag";
        return false;
    }

    char sn[9] = "";
    sprintf(sn, "%02X%02X%02X%02X", pByte[4], pByte[5], pByte[6], pByte[7]);

    CTermKeda* pTermKeda = listTerm_->GetTermBySn(sn, false);
    if(pTermKeda == NULL){
        pTermKeda = listTerm_->AddTerm(sn);

        pTermKeda->m_byteSn.replace(0,4,(char*)pByte + 4, 4);
    }

    int length = pTermKeda->DoCommand(pMsg, reply);
    if(length > 0){
        qtMessage* pMessage = pool_->GetQtMessage();
        pMessage->m_data.replace(0, length, reply);
        pMessage->WritePos(length);
        pTermKeda->SendMsg(pMessage);
    }

    return true;
}

void TermServiceWorkKeda::SetPara(CTermListKeda* listTerm, qtMessagePool* pool)
{
    listTerm_ = listTerm;
    pool_ = pool;
}

int TermServiceWorkKeda::CheckMsg(qtMessage* pMsg)
{
    unsigned char* pByte = (unsigned char*)pMsg->m_data.data();

    unsigned char HeadFlag = pByte[0];
    if(HeadFlag != 0xFF)
    {
        qDebug()<< "data head error";
        return -1;
    }
    unsigned short Length = pByte[1]*256 + pByte[2];

    if(Length > 1040)
    {
        qDebug()<< "data length error";
        return -1;
    }

    char binData[4096] = "";
    for(int i = 0; i < Length; i++)
    {
        sprintf(binData + i*3, " %02X", pByte[i]);
    }
    qDebug() << "receive data:" << binData;

    unsigned char LastFlag = pByte[Length - 1];
    if(LastFlag != 0xFF)
    {
        qDebug()<< "check tail error";
        return -1;
    }

    return 0;
}

CTermServiceKeda::CTermServiceKeda(int port)
    :server_(port)
{

}


CTermServiceKeda::~CTermServiceKeda(void)
{
}

int CTermServiceKeda::Start(CTermListKeda* listTerm)
{
    m_process.SetPara(listTerm, &pool_);
    m_process.Start(&queue_);

    server_.init(&m_decode, &queue_, &pool_);
    server_.run();

    return 0;
}

int CTermServiceKeda::Stop()
{
    return 0;
}
