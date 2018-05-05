﻿#include "TermKeda.h"
#include "termsql.h"

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

    if(m_online == 0)
    {
        QtMysqlObj* pMysqlObj = mysql_->GetMysqlObj();
        if(pMysqlObj)
        {
            QString sql = QString(TERM_ON).arg(m_strSn);
            if(pMysqlObj->ExeQuery(sql) == false){
                qDebug() << "execute sql:" << sql << " failed";
            }
            mysql_->ReleaseMysqlObj(pMysqlObj);
        }
        m_online = 1;
    }
    m_last_time = QTime::currentTime();


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

        year = year/16*10 + year%16;
        month = month/16*10 + month%16;
        day = day/16*10 + day%16;
        hour = hour/16*10 + hour%16;
        min = min/16*10 + min%16;
        second = second/16*10 + second%16;


        QDate date(2000+year, month, day);
        QTime time(hour, min, second);

        QDateTime datetime(date, time);

        QString str = datetime.toString("yyyy-MM-dd HH-mm-ss");

        qDebug() << nData1<< nData2<<nData3<< nData4 << str;

        QtMysqlObj* pMysqlObj = mysql_->GetMysqlObj();
        if(pMysqlObj)
        {
            QString sql = QString(TERM_DATA_INSERT).arg(m_strSn).arg(ntype1).arg(nData1)
                    .arg(str).arg(m_strSn).arg(ntype1);
            if(pMysqlObj->ExeQuery(sql) == false){
                qDebug() << "execute sql:" << sql << " failed";
            }
            sql = QString(TERM_DATA_INSERT).arg(m_strSn).arg(ntype2).arg(nData2)
                    .arg(str).arg(m_strSn).arg(ntype2);
            if(pMysqlObj->ExeQuery(sql) == false){
                qDebug() << "execute sql:" << sql << " failed";
            }
            sql = QString(TERM_DATA_INSERT).arg(m_strSn).arg(ntype3).arg(nData3)
                    .arg(str).arg(m_strSn).arg(ntype3);
            if(pMysqlObj->ExeQuery(sql) == false){
                qDebug() << "execute sql:" << sql << " failed";
            }
            sql = QString(TERM_DATA_INSERT).arg(m_strSn).arg(ntype4).arg(nData4)
                    .arg(str).arg(m_strSn).arg(ntype4);
            if(pMysqlObj->ExeQuery(sql) == false){
                qDebug() << "execute sql:" << sql << " failed";
            }
            mysql_->ReleaseMysqlObj(pMysqlObj);
        }
    }

    return 10;
}


void CTermKeda::SendMsg(qtMessage* pMsg)
{
    if(m_pSession)
    {
        char binData[4096] = "";
        for(int i = 0; i < pMsg->m_nWritePos; i++)
        {
            sprintf(binData + i*3, " %02X", (unsigned char)pMsg->m_data.at(i));
        }
        qDebug() << "send data:" << binData;

        m_pSession->asynWrite(pMsg);
    }
}

void CTermKeda::ExecuteContent(const QString& content)
{
    qDebug() << content;
}

void CTermKeda::OnTime(QTime sec)
{
    if(m_last_time.secsTo(sec) > 90) //登入超时
	{
		m_online = 0;

        QtMysqlObj* pMysqlObj = mysql_->GetMysqlObj();
        if(pMysqlObj)
        {
            QString sql = QString(TERM_OFF).arg(m_strSn);
            if(pMysqlObj->ExeQuery(sql) == false){
                qDebug() << "execute sql:" << sql << " failed";
            }
            mysql_->ReleaseMysqlObj(pMysqlObj);
        }
	}
}
