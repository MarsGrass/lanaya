#include <QCoreApplication>

#include "mysqlConn/mysql_pool.h"
#include "message/IoServer.h"
#include "message/qtMessageWorkManage.h"

#include "termKeda/TermServiceKeda.h"
#include "termKeda/TermListKeda.h"


#include "qtConfig.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    qtConfig g_config;

    CTermListKeda listTerm;
    CTermServiceKeda server(g_config.m_nTermServerPort);

    QtMysqlManage DbConPool;

    int nDbRes = DbConPool.Init(g_config.m_strDbServer,
                                g_config.m_strDbUser,
                                g_config.m_strDbPasswd,
                                g_config.m_strDbName,
                                g_config.m_nDbPort);

    if(nDbRes == -1)
    {
        qDebug() << "mysql init failed!";
        return -1;
    }

    listTerm.Init(&DbConPool);
    server.Start(&listTerm);

    return a.exec();
}
