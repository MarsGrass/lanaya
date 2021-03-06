﻿#include "TermKeda.h"
#include "termsql.h"

CTermKeda::CTermKeda()
{
    m_online = 0;
    m_last_time = QTime::currentTime();
    m_pSession = NULL;
    mysql_ = NULL;

    m_byteSn.resize(4);
    m_nCmdTimes = 0;
}

CTermKeda::CTermKeda(QtMysqlManage* mysql, const QString& sn)
    : m_strSn(sn), mysql_(mysql)
{
	m_online = 0;
    m_last_time = QTime::currentTime();
    m_pSession = NULL;

    m_byteSn.resize(4);

    if(sn.length() == 8)
    {
        m_byteSn[0] = (char)sn.mid(0,2).toInt(0, 16);
        m_byteSn[1] = (char)sn.mid(2,2).toInt(0, 16);
        m_byteSn[2] = (char)sn.mid(4,2).toInt(0, 16);
        m_byteSn[3] = (char)sn.mid(6,2).toInt(0, 16);
    }
}


CTermKeda::~CTermKeda(void)
{
}

int CTermKeda::DoCommand(qtMessage* pMsg, QByteArray& reply)
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


int CTermKeda::Login(qtMessage* pMsg, QByteArray& reply)
{
    unsigned char* pByte = (unsigned char*)pMsg->m_data.data();

    QtMysqlObj* pMysqlObj = mysql_->GetMysqlObj();
    if(pMysqlObj)
    {
        QString sql = QString(TERM_FREQ).arg(pByte[14]).arg(m_strSn);
        if(pMysqlObj->ExeQuery(sql) == false){
            qDebug() << "execute sql:" << sql << " failed";
        }
        mysql_->ReleaseMysqlObj(pMysqlObj);
    }

    reply.resize(16);
    reply[0] = (char)0xFE;
	reply[1] = 0x00;
    reply[2] = 0x10;
	reply[3] = 0x01;
    reply.replace(4, 4, (char*)pByte + 4, 4);
    QDateTime datatime = QDateTime::currentDateTime();
    int year = datatime.date().year() - 2000;
    int month = datatime.date().month();
    int day = datatime.date().day();
    int hour = datatime.time().hour();
    int minute = datatime.time().minute();
    int second = datatime.time().second();
    reply[8] = (year/10)*16 + (year%10);
    reply[9] = (month/10)*16 + (month%10);
    reply[10] = (day/10)*16 + (day%10);
    reply[11] = (hour/10)*16 + (hour%10);
    reply[12] = (minute/10)*16 + (minute%10);
    reply[13] = (second/10)*16 + (second%10);
    reply[14] = pByte[14];
    reply[15] = (char)0xFE;
	
    return 16;
}

int CTermKeda::SetPeriod(qtMessage* pMsg, QByteArray& reply)
{
    QtMysqlObj* pMysqlObj = mysql_->GetMysqlObj();
    if(pMysqlObj && m_strTaskId.length() > 0)
    {
        QString sql = QString(TERM_CMD_COMP).arg(m_strTaskId);
        if(pMysqlObj->ExeQuery(sql) == false){
            qDebug() << "execute sql:" << sql << " failed";
        }
        mysql_->ReleaseMysqlObj(pMysqlObj);
    }

    reply.clear();

    return 0;
}

int CTermKeda::DataReport(qtMessage* pMsg, QByteArray& reply)
{
    unsigned char* pByte = (unsigned char*)pMsg->m_data.data();

    reply.resize(10);
	reply[0] = 0xFE;
	reply[1] = 0x00;
    reply[2] = 0x0A;
	reply[3] = 0x02;
    reply.replace(4, 5, (char*)pByte + 4, 5);
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

        double aData4 = 5 * (double)nData4 / 4095;
        double fData4 = 3.3875*sinh(pow(aData4, 3)*0.1692 - pow(aData4, 2)*1.2898 + 4.085*aData4 - 4.7506);

        QString strData1 = QString::number(double(nData1) / 100.0, 'f', 1);
        QString strData2 = QString::number(double(nData2) / 100.0, 'f', 2);
        QString strData3 = QString::number(double(nData3) / 100.0, 'f', 0);
        QString strData4 = QString::number(fData4, 'f', 2);

        QDate date(2000+year, month, day);
        QTime time(hour, min, second);

        QDateTime datetime(date, time);

        QString str = datetime.toString("yyyy-MM-dd HH-mm-ss");

        qDebug() << strData1 << strData2 << strData3 << strData4 << aData4 << str;

        QtMysqlObj* pMysqlObj = mysql_->GetMysqlObj();
        if(pMysqlObj)
        {
            QString sql = QString(TERM_DATA_INSERT).arg(m_strSn).arg(ntype1).arg(strData1)
                    .arg(str).arg(m_strSn).arg(ntype1);
            if(pMysqlObj->ExeQuery(sql) == false){
                qDebug() << "execute sql:" << sql << " failed";
            }
            sql = QString(TERM_DATA_INSERT).arg(m_strSn).arg(ntype2).arg(strData2)
                    .arg(str).arg(m_strSn).arg(ntype2);
            if(pMysqlObj->ExeQuery(sql) == false){
                qDebug() << "execute sql:" << sql << " failed";
            }
            sql = QString(TERM_DATA_INSERT).arg(m_strSn).arg(ntype3).arg(strData3)
                    .arg(str).arg(m_strSn).arg(ntype3);
            if(pMysqlObj->ExeQuery(sql) == false){
                qDebug() << "execute sql:" << sql << " failed";
            }
            sql = QString(TERM_DATA_INSERT).arg(m_strSn).arg(ntype4).arg(strData4)
                    .arg(str).arg(m_strSn).arg(ntype4);
            if(pMysqlObj->ExeQuery(sql) == false){
                qDebug() << "execute sql:" << sql << " failed";
            }

            if(i == nCount - 1)
            {
                sql = QString(SENSOR_UPDATE_1).arg(strData1).arg(m_strSn);
                if(pMysqlObj->ExeQuery(sql) == false){
                    qDebug() << "execute sql:" << sql << " failed";
                }
                sql = QString(SENSOR_UPDATE_2).arg(strData2).arg(m_strSn);
                if(pMysqlObj->ExeQuery(sql) == false){
                    qDebug() << "execute sql:" << sql << " failed";
                }
                sql = QString(SENSOR_UPDATE_3).arg(strData3).arg(m_strSn);
                if(pMysqlObj->ExeQuery(sql) == false){
                    qDebug() << "execute sql:" << sql << " failed";
                }
                sql = QString(SENSOR_UPDATE_4).arg(strData4).arg(m_strSn);
                if(pMysqlObj->ExeQuery(sql) == false){
                    qDebug() << "execute sql:" << sql << " failed";
                }
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

void CTermKeda::ExecuteContent(const QString& content, const QString& taskID)
{
    qDebug() << "content" << content << " task ID" << taskID;

    if(m_strTaskId == taskID)
    {
        m_nCmdTimes++;
        if(m_nCmdTimes > 5)
        {
            QtMysqlObj* pMysqlObj = mysql_->GetMysqlObj();
            if(pMysqlObj > 0)
            {
                QString sql = QString(TERM_CMD_FAILED).arg(m_strTaskId);
                if(pMysqlObj->ExeQuery(sql) == false){
                    qDebug() << "execute sql:" << sql << " failed";
                }
                mysql_->ReleaseMysqlObj(pMysqlObj);
            }
        }
    }
    else
    {
        m_strTaskId = taskID;
        m_nCmdTimes = 0;

    }

    if(m_pSession)
    {
       if(m_pSession->pServer_ == NULL)
       {
           qDebug() << "ExecuteContent server NULL";
       }
       if(m_pSession->pServer_->pMessagePool_ == NULL)
       {
           qDebug() << "ExecuteContent MessagePool NULL";
       }

       qtMessage* pMessage = m_pSession->pServer_->pMessagePool_->GetQtMessage();
       if (pMessage == NULL)
       {
           return;
       }
       pMessage->setSession(m_pSession);

       unsigned char* pByte = (unsigned char*)pMessage->m_data.data();
       pByte[0] = 0xFE;
       pByte[1] = 0x00;
       pByte[2] = 0x0A;
       pByte[3] = 0x03;
       memcpy(pByte+4, m_byteSn.data(), 4);
       pByte[8] = (unsigned char)content.toInt();
       pByte[9] = 0xFE;

       pMessage->WritePos(10);

       SendMsg(pMessage);
    }

}

void CTermKeda::OnTime(QTime sec)
{
    if(m_last_time.secsTo(sec) > 90) //登入超时
	{
		m_online = 0;
        m_strTaskId.clear();

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
