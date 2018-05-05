#pragma once

#include <boost/thread.hpp>
#include <boost/thread/mutex.hpp>

#include "mysql_interface.h"
#include <QList>


class QtMysqlManage : public QObject
{
    Q_OBJECT
public:
    QtMysqlManage(QObject* qObj = 0);
    ~QtMysqlManage();

    //初始化
    int Init(const QString& server, const QString& username, const QString& passwd,
             const QString& database, int port = 3336, int nSize = 4);

    //析构
    void UnInit();

    //获取连接
    QtMysqlObj* GetMysqlObj();

    //释放连接
    void ReleaseMysqlObj(QtMysqlObj* pMysqlObj);

private:
    //创建一个连接
    QtMysqlObj* CreateMysqlObj();

private:
    QString m_strServer;
    QString m_strUsername;
    QString m_strPassword;
    QString m_strDatabase;
    int m_nPort;

    int m_nCurrentSize;  //当前已建立的数据库连接数量
    int m_nMaxSize;		//连接池中定义的最大数据库连接数

    boost::shared_mutex mutex;    //共享读控制锁
    QList<QtMysqlObj*> m_listMysqlCon;
};

