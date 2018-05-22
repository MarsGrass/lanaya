#pragma once

#include <QString>
#include <QTime>

#include "message/IoServer.h"
#include "message/qtMessageWorkManage.h"
#include "mysqlConn/mysql_pool.h"

class CTermKeda
{
public:
    CTermKeda();
    CTermKeda(QtMysqlManage* mysql, const QString& sn = "");
	~CTermKeda(void);

public:
    int DoCommand(qtMessage* pMsg, QByteArray& reply);

    int Login(qtMessage* pMsg, QByteArray& reply);

    int DataReport(qtMessage* pMsg, QByteArray& reply);

    int SetPeriod(qtMessage* pMsg, QByteArray& reply);

    void OnTime(QTime sec);

    void SendMsg(qtMessage* pMsg);

    void ExecuteContent(const QString& content, const QString& taskID);


public:
    QString m_strSn;
    QString m_strTaskId;
    QByteArray m_byteSn;
    QString m_strName;
	int m_nNumId;
	int m_online;

    int m_nCmdTimes;

    QTime m_last_time;

    IOSession* m_pSession;

public:
    QtMysqlManage* mysql_;


};
