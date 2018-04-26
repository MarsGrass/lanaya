#include <QCoreApplication>

#include "mysqlConn/mysql_pool.h"
#include "message/IoServer.h"
#include "message/qtMessageWorkManage.h"

#include "termKeda/TermServiceKeda.h"
#include "termKeda/TermListKeda.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    CTermListKeda listTerm;
    CTermServiceKeda server;

    QtMysqlManage DbConPool;

    int nDbRes = DbConPool.Init("127.0.0.1", "root",
                                "123456", "lanaya", 3306);

    listTerm.Init(&DbConPool);
    server.Start(&listTerm);

//    if(nDbRes == -1)
//    {
//        qDebug() << "mysql init failed!";
//        return -1;
//    }



//    QtMysqlObj* pMySQLObj = DbConPool.GetMysqlObj();
//    if(pMySQLObj)
//    {
//        QString queryStr = "select group_name from ld_group;";
//        QVector<QVector<QString> > Querydata;
//        bool bQuery = pMySQLObj->ExeQuery(queryStr, Querydata);
//        if(bQuery == false)
//        {
//            //HD_ERROR("MYSQL", "%s, failed!\n", queryStr);
//        }
//        int nSize = Querydata.size();
//        if(nSize > 0) //表明能够查询到数据
//        {
//            for (int i = 0; i < nSize; i++)
//            {
//               QString id = Querydata[i][0];
////				std::string sn = Querydata[i][1];
////				std::string name = Querydata[i][2];
//            }
//        }
//    }

    return a.exec();
}
