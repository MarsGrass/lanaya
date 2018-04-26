﻿
#pragma once

#include <QObject>

#include <boost/enable_shared_from_this.hpp>
#include <boost/asio.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/thread.hpp>
#include <boost/bind.hpp>
#include <boost/thread/mutex.hpp>

#include "qtMessageParse.h"
#include "qtMessageQueue.h"
#include "qtMessagePool.h"

using boost::asio::ip::tcp;

class IOServer;

class IOSession : public QObject, public boost::enable_shared_from_this<IOSession>
{
    Q_OBJECT

public:
    IOSession(boost::asio::io_service& work_service, boost::asio::io_service& io_service, QObject* qObj = 0);
    ~IOSession();

    void SetServer(IOServer* pServer);

    tcp::socket& socket();

    void asynWrite(qtMessage* pMsg);

    void start();

    //读取消息头
    void handle_read_head(qtMessage* pMsg, size_t nTransSize, const boost::system::error_code& error);

    //读取消息体
    void handle_read_body(qtMessage* pMsg, size_t nTransSize, const boost::system::error_code& error);


    void handle_write(qtMessage* pMsg, size_t nTransSize, const boost::system::error_code& error);




private:
    // The io_service used to finish the work.
    boost::asio::io_service& io_work_service;

    // The socket used to communicate with the client.
    tcp::socket socket_;

    // Buffer used to store data received from the client.
    //boost::array<char, 1024> data_;

    // The allocator to use for handler-based custom memory allocation.
    //handler_allocator allocator_;

    IOServer* pServer_;

    boost::mutex        m_mutex;

public:
    int m_nIndex;
    static int m_sCount;
};
