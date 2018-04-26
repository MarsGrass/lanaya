#include "TermServiceKeda.h"


/*------------------------------------------------------------------
TermServiceMsgProcessKeda
------------------------------------------------------------------*/

TermServiceWorkKeda::TermServiceWorkKeda(void)
{

}

TermServiceWorkKeda::~TermServiceWorkKeda(void)
{
}

virtual bool TermServiceWorkKeda::Work(qtMessage* pMsg)
{
    unsigned char* pByte;
    char reply[1040] = "";
    int nLength = DealCommand(pMsg, reply);
}

int TermServiceWorkKeda::DealCommand(qtMessage* pMsg, char* reply)
{
    unsigned char* pByte = (unsigned char*)pMsg->m_data.data();

    //网络阻塞暂时不处理
    int res = CheckMsg(pMsg);
    if(res == -1)
    {
        qDebug() << "data error, flag";
        return -1;
    }

    int termId = 0;
    bool bExist = true;

    char sn[9] = "";
    sprintf(sn, "%02X%02X%02X%02X", pByte[4], pByte[5], pByte[6], pByte[7]);

    CTermKeda* pTermKeda = TermListKeda.GetTermBySn(std::string(sn));
    if(pTermKeda == NULL)
    {

    }
    else
    {
        res = pTermKeda->DoCommand(pMsg, reply);
    }

    return res;
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

//读消息
int TermServiceMsgProcessKeda::HandleRead(NS_NET::Message* pMsg)
{
	unsigned char* pByte;
	char reply[1040] = "";
	int nLength = DealCommand(pMsg, reply);
	
    //收到消息，发送一个回去
	if(nLength > 0)
	{
		unsigned int nType = pMsg->GetMsgType();
		NS_NET::NET_HANDLE netHandle = pMsg->GetNetHandle();
		pMsg->Reset();

		pByte = pMsg->WriterPtr();
		memcpy(pByte, reply, nLength);
		pMsg->WriterPtr(nLength);

		char binData[4096] = "";
		for(int i = 0; i < nLength; i++)
		{
			sprintf(binData + i*3, " %02X", (unsigned char)reply[i]);
		}
		HD_INFO(MORPHING, "发送数据：%s\n", binData);

		pMsg->SetMsgType(nType);
		pMsg->SetNetHandle(netHandle);
		m_pServer->AsyncWrite(pMsg);
	}
    pMsg->Release();
	
    return HD_ENO_SUCCESS;
}



/*------------------------------------------------------------------
CWebService
------------------------------------------------------------------*/
CTermServiceKeda::CTermServiceKeda(void)
{
}


CTermServiceKeda::~CTermServiceKeda(void)
{
}

int CTermServiceKeda::Start(std::string strAddress)
{
	if (m_server.Initialize() != HD_ENO_SUCCESS)
	{
		fprintf(stderr, "initialize net error.\n");
		return HD_ENO_FALSE;
	}

	m_process.BindServer(&m_server);

	m_hSvrHandle = m_server.CreateServer(strAddress.c_str(), &m_decode, &m_process);
    if (m_hSvrHandle == INVALID_NET_HANDLE)
    {
        fprintf(stderr, "create reactor msg server error.\n");
        return HD_ENO_FALSE;
    }

	return HD_ENO_SUCCESS;
}

int CTermServiceKeda::Stop()
{
	m_server.DestoryHandle(m_hSvrHandle);
	m_server.Uninitialize();
	return HD_ENO_SUCCESS;
}
