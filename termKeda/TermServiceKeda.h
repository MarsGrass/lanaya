#pragma once


#include <iostream>  

#include "message/IoServer.h"
#include "message/qtMessageWorkManage.h"
#include "TermListKeda.h"
  
using namespace boost::asio;

class TermServiceMsgDecodeKeda : public QtMessageParse
{
public:
    TermServiceMsgDecodeKeda(){}
    virtual ~TermServiceMsgDecodeKeda(){}

    //得到定长头的长度
    virtual int GetConstHeaderLength(void){return 8;}

    //得到包的长度
    virtual int GetPackLength(qtMessage* pMsg)
    {
        unsigned char* pByte = (unsigned char*)pMsg->m_data.data();

        if(pByte[0] == 0xFF)
        {
            unsigned char BodyLengthHigh = pByte[1];
            unsigned char BodyLengthLow = pByte[2];
            int nPackLength = BodyLengthHigh * 256 + BodyLengthLow;
            return nPackLength;
        }
        return 10;
    }

    //得到包体的长度
    virtual int GetBodyLength(qtMessage* pMsg)
    {
        unsigned char* pByte = (unsigned char*)pMsg->m_data.data();

        if(pByte[0] == 0xFF)
        {
            unsigned char BodyLengthHigh = pByte[1];
            unsigned char BodyLengthLow = pByte[2];
            int nPackLength = BodyLengthHigh * 256 + BodyLengthLow;
            return nPackLength - 8;
        }
        return 0;
    }
};

class TermServiceWorkKeda : public qtMessageWorkManage
{
public:
    TermServiceWorkKeda();
    virtual ~TermServiceWorkKeda();

    virtual bool Work(qtMessage* pMsg);

    void SetPara(CTermListKeda* listTerm, qtMessagePool* pool);


private:
    //处理命令
    int DealCommand(qtMessage* pMsg, char* reply);
    int CheckMsg(qtMessage* pMsg);

    CTermListKeda* listTerm_;
    qtMessagePool* pool_;
};

class CTermServiceKeda
{
public:
	CTermServiceKeda(void);
	~CTermServiceKeda(void);

public:
	//启动服务
    int Start(CTermListKeda* listTerm);

	//停止服务
	int Stop();

public:
	//处理函数
    TermServiceWorkKeda m_process;
	//解析函数
	TermServiceMsgDecodeKeda m_decode;

    qtMessageQueue queue_;

    qtMessagePool pool_;

    IOServer server_;
};
