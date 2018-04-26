#include "TermKeda.h"

extern QtMysqlManage DbConPool;

CTermKeda::CTermKeda(QtMysqlManage* mysql, const QString& sn)
    : m_strSn(sn), mysql_(mysql)
{
	m_online = 0;
	m_last_time = time(NULL);

    m_pSession = NULL;


	for(int i = 0; i < 10; i++)
	{
		m_nCurrentData[i] = 0;
 	}
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
			nLength = HeartBeat(pMsg, reply);
			break;
		default:
			nLength = 0;
			break;
	}
	return nLength;
}


int CTermKeda::Login(qtMessage* pMsg, char* reply)
{
	unsigned char* pByte = pMsg->ReaderPtr();

	reply[0] = 0xFE;
	reply[1] = 0x00;
	reply[2] = 0x26;
	reply[3] = 0x01;
	memcpy(reply + 4, pByte + 4, 32);
	reply[36] = 0x01;
	reply[37] = 0xFE; 
	
	return 38;
}

int CTermKeda::HeartBeat(qtMessage* pMsg, char* reply)
{
	unsigned char* pByte = pMsg->ReaderPtr();

	reply[0] = 0XFE;
	reply[1] = 0x00;
	reply[2] = 0x26;
	reply[3] = 0x03;
	memcpy(reply + 4, pByte + 4, 32);
	reply[36] = 0x00;
	reply[37] = 0xFE; 
	
	return 38;
}

int CTermKeda::DataReport(qtMessage* pMsg, char* reply)
{
	unsigned char* pByte = pMsg->ReaderPtr();
	reply[0] = 0xFE;
	reply[1] = 0x00;
	reply[2] = 0x26;
	reply[3] = 0x02;
	memcpy(reply + 4, pByte + 4, 32);
	reply[36] = 0x00;
	reply[37] = 0xFE; 

	return 38;
}



int CTermKeda::DataReport(qtMessage* pMsg, char* reply, MySQLInterface* pMySQLInterface)
{
	unsigned char* pByte = pMsg->ReaderPtr();
	unsigned int nLength = (unsigned int)pByte[1] * 256 + (unsigned int)pByte[2];
	unsigned int dataCount = (unsigned int)pByte[36] * 256 + (unsigned int)pByte[37];

	for(unsigned int i = 0; i < dataCount; i++)
	{
		m_nCurrentSensorNo = (unsigned int)pByte[38 + i * 14] * 256 + (unsigned int)pByte[39 + i * 14]; 
		m_nCurrentSensorMode = (unsigned int)pByte[40 + i * 14];

		char key_sn[256] =""; 
		sprintf(key_sn, "%s_%d", m_strSn.c_str(),m_nCurrentSensorNo);

		
		if(m_nCurrentSensorNo == 0xFF)
		{/*
			if(m_nCurrentData[i] == -2)//不插入历史数据表		
			{	
			}
			else
			{
				m_nCurrentData[i] = -2;
				char sql[256] ="";
				sprintf(sql, "insert into Keda_sensor_data (sensor_id, data, upload_time) value (%d, '-2', now());", nSersonId);
				HD_INFO("MYSQL", "%s\n", sql);
				pMySQLInterface->writeDataToDB(sql);
			}*/
		}
		else
		{
			int nData;
			unsigned char dataflag = (unsigned char)pByte[47 + i * 14];
			if(dataflag == 0)
			{
				memcpy(&nData, pByte + 48 + i*14, 4);
				nData = ntohl(nData);

				char strCurrentValue[10] = "";
				if(m_nCurrentSensorMode == 6) //表示是压强
				{
					sprintf(strCurrentValue, "%.3f", (float)nData / 1000);
				}
				else
				{
					sprintf(strCurrentValue, "%.2f", (float)nData / 100);
				}
				m_nCurrentValue = strCurrentValue;
			}
			else
			{
				char errInfop[10] = "";
				memcpy(errInfop, pByte + 48 + i*14, 4);
				m_nCurrentValue = errInfop;
				if(m_nCurrentValue.find("E001") >= 0)
				{
					nData = -1;
					m_nCurrentValue = "-1";
				}
				else if(m_nCurrentValue.find("E003") >= 0)
				{
					nData = -3;
					m_nCurrentValue = "-3";
				}

			}

			//if(m_nCurrentData[i] == nData)//不插入历史数据表
			{		
			}
			//else
			{
				m_nCurrentData[i] = nData;
				char sql[256] ="";
				sprintf(sql, "insert into Keda_sensor_data (key_sn, data, upload_time) value ('%s', '%s', now());", key_sn, m_nCurrentValue.c_str());
				HD_INFO("MYSQL", "%s\n", sql);
				pMySQLInterface->writeDataToDB(sql);
			}

			{
				char sql[256] ="";
				sprintf(sql, "INSERT INTO Keda_sensor (key_sn, type_id, no, term_id, latest_data, latest_time) VALUES ('%s', %d, %d, %d, '%s', now()) "\
					"ON DUPLICATE KEY UPDATE latest_time = now(), latest_data = '%s'; ", key_sn, m_nCurrentSensorMode, m_nCurrentSensorNo, m_nNumId, m_nCurrentValue.c_str(), m_nCurrentValue.c_str());
				HD_INFO("MYSQL", "%s\n", sql);
				pMySQLInterface->writeDataToDB(sql);
			}
		}
	}
	
	reply[0] = 0xFE;
	reply[1] = 0x00;
	reply[2] = 0x26;
	reply[3] = 0x02;
	memcpy(reply + 4, pByte + 4, 32);
	reply[36] = 0x00;
	reply[37] = 0xFE; 

	return 38;
}

void CTermKeda::SetId(int nNumId)
{
	m_nNumId = nNumId;
}

int CTermKeda::GetId()
{
	return m_nNumId;
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

		MySQLInterface* pMySQLInterface = DbConPool.GetMysqlCon();
		if(pMySQLInterface == NULL)
		{
			return;
		}
		char sql[256] ="";
		sprintf(sql, "update Keda_term set link_status = 2, run_status = 2 where sn = '%s';", m_strSn.c_str());
		pMySQLInterface->writeDataToDB(sql);

		DbConPool.ReleaseMysqlCon(pMySQLInterface);
	}
}
