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
    int DoCommand(qtMessage* pMsg, char* reply);

    int Login(qtMessage* pMsg, char* reply);

    int DataReport(qtMessage* pMsg, char* reply);

    int SetPeriod(qtMessage* pMsg, char* reply);

    void OnTime(QTime sec);

    void SendMsg(qtMessage* pMsg);

    void ExecuteContent(const QString& content);


public:
    QString m_strSn;
    QString m_strName;
	int m_nNumId;
	int m_online;

    QTime m_last_time;

    IOSession* m_pSession;

public:
    QtMysqlManage* mysql_;

};
