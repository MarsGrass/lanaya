#include <QCoreApplication>

#include "mysqlConn/mysql_pool.h"
#include "message/IoServer.h"
#include "message/qtMessageWorkManage.h"

class ParesOne : public QtMessageParse
{
public:
    ParesOne(){}
    virtual ~ParesOne(){}

    //得到定长头的长度
    virtual int GetConstHeaderLength(void){return 4;}

    //得到包的长度
    virtual int GetPackLength(qtMessage* pMsg){return 10;}

    //得到包体的长度
    virtual int GetBodyLength(qtMessage* pMsg){return 10;}
};

class WorkOne : public qtMessageWorkManage
{
public:
    WorkOne() : qtMessageWorkManage(){}
    virtual ~WorkOne(){}

    virtual bool Work(qtMessage* pMsg)
    {
        qDebug() << pMsg->m_data;
        return true;
    }
};

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    ParesOne parse;
    WorkOne work;
    qtMessageQueue queue;
    qtMessagePool pool;

    IOServer server(3698);

    work.Start(&queue);
    server.init(&parse, &queue, &pool);

    server.run();


//    QtMysqlManage DbConPool;

//    int nDbRes = DbConPool.Init("127.0.0.1", "root",
//                                "123456", "lanaya", 3306);

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
