#pragma once

#include <QString>
#include <QTime>

#include "message/IoServer.h"
#include "message/qtMessageWorkManage.h"
#include "mysqlConn/mysql_pool.h"

class CTermKeda
{
public:
    CTermKeda(QtMysqlManage* mysql, const QString& sn = "");
	~CTermKeda(void);

public:
    int DoCommand(qtMessage* pMsg, char* reply);

    int Login(qtMessage* pMsg, char* reply);
    int HeartBeat(qtMessage* pMsg, char* reply);
    int DataReport(qtMessage* pMsg, char* reply);

	void SetId(int nNumId);
	int GetId();

    void OnTime(QTime sec);

    void SendMsg(qtMessage* pMsg);


	//带数据库接口的数据上报
    int DataReport(qtMessage* pMsg, char* reply, MySQLInterface* pMySQLInterface);

public:
    QString m_strSn;
    QString m_strName;
	int m_nNumId;
	int m_online;

    QTime m_last_time;

    IOSession* m_pSession;

public:
	unsigned int m_nCurrentSensorNo;
	unsigned int m_nCurrentSensorMode;
	std::string m_nCurrentValue;

    QtMysqlManage* mysql_;

};
