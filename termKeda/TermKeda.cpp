#include "TermKeda.h"

CTermKeda::CTermKeda()
{
    m_online = 0;
    m_last_time = QTime::currentTime();
    m_pSession = NULL;
    mysql_ = NULL;
}

CTermKeda::CTermKeda(QtMysqlManage* mysql, const QString& sn)
    : m_strSn(sn), mysql_(mysql)
{
	m_online = 0;
    m_last_time = QTime::currentTime();
    m_pSession = NULL;
}


CTermKeda::~CTermKeda(void)
{
}

int CTermKeda::DoCommand(qtMessage* pMsg, char* reply)
{
    m_pSession = pMsg->getSession();

	int nLength;
    unsigned char* pByte = (unsigned char*)pMsg->m_data.data();

    m_last_time = QTime::currentTime();
	m_online = 1;

	switch(pByte[3])
	{
		case 0x01:
			nLength = Login(pMsg, reply);
			break;
		case 0x02:
			nLength = DataReport(pMsg, reply);
			break;
        case 0x03:
            nLength = SetPeriod(pMsg, reply);
			break;
		default:
			nLength = 0;
			break;
	}
	return nLength;
}


int CTermKeda::Login(qtMessage* pMsg, char* reply)
{
    unsigned char* pByte = (unsigned char*)pMsg->m_data.data();

	reply[0] = 0xFE;
	reply[1] = 0x00;
    reply[2] = 0x10;
	reply[3] = 0x01;
    memcpy(reply + 4, pByte + 4, 11);
    reply[15] = 0xFE;
	
    return 16;
}

int CTermKeda::SetPeriod(qtMessage* pMsg, char* reply)
{
    return 0;
}

int CTermKeda::DataReport(qtMessage* pMsg, char* reply)
{
    unsigned char* pByte = (unsigned char*)pMsg->m_data.data();
	reply[0] = 0xFE;
	reply[1] = 0x00;
    reply[2] = 0x0A;
	reply[3] = 0x02;
    memcpy(reply + 4, pByte + 4, 5);
    reply[9] = 0xFE;

    int nDataPos = 9;
    unsigned int nLength = (unsigned int)pByte[1] * 256 + (unsigned int)pByte[2];
    int nCount = pByte[nDataPos];
    if(nLength != nCount * 27 + nDataPos + 2)
    {
        qDebug() << "data length error";
        return 10;
    }

    for(int i = 0; i < nCount; i++)
    {
        unsigned char ntype1, ntype2, ntype3, ntype4, ntypeTime;
        int nData1, nData2, nData3, nData4;
        ntype1 = pByte[nDataPos + 1 + i*27];
        memcpy(&nData1, pByte + nDataPos + 2 + i*27, 4);
        ntype2 = pByte[nDataPos + 6 + i*27];
        memcpy(&nData2, pByte + nDataPos + 7 + i*27, 4);
        ntype3 = pByte[nDataPos + 11 + i*27];
        memcpy(&nData3, pByte + nDataPos + 12 + i*27, 4);
        ntype4 = pByte[nDataPos + 16 + i*27];
        memcpy(&nData4, pByte + nDataPos + 17 + i*27, 4);
        ntypeTime = pByte[nDataPos + 21 + i*27];

        unsigned char year = pByte[nDataPos + 22 + i*27];
        unsigned char month = pByte[nDataPos + 23 + i*27];
        unsigned char day = pByte[nDataPos + 24 + i*27];
        unsigned char hour = pByte[nDataPos + 25 + i*27];
        unsigned char min = pByte[nDataPos + 26 + i*27];
        unsigned char second = pByte[nDataPos + 27 + i*27];

        nData1 = ntohl(nData1);
        nData2 = ntohl(nData2);
        nData3 = ntohl(nData3);
        nData4 = ntohl(nData4);

        year = ((year>>4)&0x0F)*10 + year&0x0F;
        month = ((month>>4)&0x0F)*10 + month&0x0F;
        day = ((day>>4)&0x0F)*10 + day&0x0F;
        hour = ((hour>>4)&0x0F)*10 + hour&0x0F;
        min = ((min>>4)&0x0F)*10 + min&0x0F;
        second = ((second>>4)&0x0F)*10 + second&0x0F;

        QDate date(2000+year, month, day);
        QTime time(hour, min, second);

        QDateTime datetime(date, time);

        QString str = datetime.toString("yyyy-MM-dd HH-mm-ss");

        qDebug() << nData1<< nData2<<nData3<< nData4<<str;
    }

    return 10;
}


void CTermKeda::SendMsg(qtMessage* pMsg)
{
    if(m_pSession)
    {
        m_pSession->asynWrite(pMsg);
    }
}
//void CTermKeda::SendMsg(unsigned char* request, int length)
//{
//    qtMessage* pSendMsg = pServer->GetMessage();
//	unsigned char* pByte = pSendMsg->WriterPtr();
//	memcpy(pByte, request, length);
//	pSendMsg->WriterPtr(length);

//	char binData[4096] = "";
//	for(int i = 0; i < length; i++)
//	{
//		sprintf(binData + i*3, " %02X", (unsigned char)request[i]);
//	}
//	HD_INFO(MORPHING, "发送数据：%s\n", binData);

//	pSendMsg->SetMsgType(m_nMsgType);
//	pSendMsg->SetNetHandle(m_netHandle);
//	pServer->AsyncWrite(pSendMsg);
//	pSendMsg->Release();
//}

void CTermKeda::OnTime(QTime sec)
{
    if(m_last_time.secsTo(sec) > 90) //登入超时
	{
		m_online = 0;

//		MySQLInterface* pMySQLInterface = DbConPool.GetMysqlCon();
//		if(pMySQLInterface == NULL)
//		{
//			return;
//		}
//		char sql[256] ="";
//		sprintf(sql, "update Keda_term set link_status = 2, run_status = 2 where sn = '%s';", m_strSn.c_str());
//		pMySQLInterface->writeDataToDB(sql);

//		DbConPool.ReleaseMysqlCon(pMySQLInterface);
	}
}
