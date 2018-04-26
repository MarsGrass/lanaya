#include <QDebug>

#include "mysql_pool.h"

QtMysqlManage::QtMysqlManage(QObject* qObj)
    : QObject(qObj)
{
    m_nMaxSize = 20;
    m_nCurrentSize = 0;
}

QtMysqlManage::~QtMysqlManage()
{
    UnInit();
}

//初始化
int QtMysqlManage::Init(const QString& server, const QString& username, const QString& password,
         const QString& database, int port, int nSize)
{
    m_strServer = server;
    m_strUsername = username;
    m_strPassword = password;
    m_strDatabase = database;
    m_nPort = port;
    m_nCurrentSize = nSize;

    for(int i = 0; i < nSize; i++)
    {
        QtMysqlObj* pMySQLObj = CreateMysqlObj();
        if(pMySQLObj == NULL)
        {
            continue;
        }
        m_listMysqlCon.push_back(pMySQLObj);
        Sleep(100);
    }

    if(m_listMysqlCon.size() == nSize)
    {
        return 0;
    }
    return -1;
}

//析构
void QtMysqlManage::UnInit()
{

}

//获取连接
QtMysqlObj* QtMysqlManage::GetMysqlObj()
{
    QtMysqlObj* pMysqlObj = NULL;
    boost::unique_lock<boost::shared_mutex> writeLock(mutex);

    if (m_listMysqlCon.size() > 0) //连接池容器中还有连接
    {
        pMysqlObj = m_listMysqlCon.front(); //得到第一个连接
        m_listMysqlCon.pop_front();   //移除第一个连接
        if (pMysqlObj->isOpen() == false)   //如果连接已经被关闭，删除后重新建立一个
        {
            delete pMysqlObj;
            pMysqlObj = this->CreateMysqlObj();
        }
        //如果连接为空，则创建连接出错
        if (pMysqlObj == NULL)
        {
            --m_nCurrentSize;
        }
        return pMysqlObj;
    }
    else
    {
        if (m_nCurrentSize < m_nMaxSize) //还可以创建新的连接
        {
            pMysqlObj = this->CreateMysqlObj();
            if(pMysqlObj)
            {
                ++m_nCurrentSize;
                return pMysqlObj;
            }
            else
            {
                qDebug() << "MYSQL " << "pMySQLInterface is NULL \n";
                return pMysqlObj;
            }
        }
        else //建立的连接数已经达到maxSize
        {
            qDebug() << "MYSQL " << "mysql connect already Max \n";
            return NULL;
        }
    }
    return pMysqlObj;
}

//释放连接
void QtMysqlManage::ReleaseMysqlObj(QtMysqlObj* pMysqlObj)
{
    if(pMysqlObj)
    {
        boost::unique_lock<boost::shared_mutex> writeLock(mutex);
        m_listMysqlCon.push_back(pMysqlObj);
    }
}

//创建一个连接
QtMysqlObj* QtMysqlManage::CreateMysqlObj()
{
    QtMysqlObj* pMysqlObj = new QtMysqlObj();
    bool bConnect = pMysqlObj->connectMySQL(m_strServer, m_strUsername, m_strPassword, m_strDatabase, m_nPort);
    if(bConnect == false)
    {
        qDebug() << "MYSQL " << "connect mysql failed\n";
        delete pMysqlObj;
        return NULL;
    }
    qDebug() << "MYSQL " << "connect mysql successed\n";
    return pMysqlObj;
}



