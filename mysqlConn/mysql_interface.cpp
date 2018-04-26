
#include <QSqlError>
#include <QSqlRecord>

#include "MySQL_Interface.h"

int QtMysqlObj::s_nIndex = 1;

QtMysqlObj::QtMysqlObj(QObject* qObj)
    : QObject(qObj)
{
    db = QSqlDatabase::addDatabase("QMYSQL", QString::number(s_nIndex++));

    bIsOpen = false;
}

QtMysqlObj::~QtMysqlObj()
{

}

bool QtMysqlObj::connectMySQL(const QString& server, const QString& username, const QString& password, const QString& database, int port)
{
    if(bIsOpen == false)
    {
        db.setHostName(server);
        db.setDatabaseName(database);
        db.setUserName(username);
        db.setPassword(password);
        db.setPort(port);

        if(!db.open()){
            qDebug() << "connect mysql failed";
            return false;
        }

        bIsOpen = true;
    }

    return true;
}

bool QtMysqlObj::isOpen()
{
    return bIsOpen;
}

void QtMysqlObj::closeMySQL()
{
    db.close();
    bIsOpen = false;
}

bool QtMysqlObj::ExeQuery(const QString& queryStr)
{
    if(bIsOpen == false)
    {
        qDebug() << "mysql not connect";
        return false;
    }
    QSqlQuery query(db);
    bool Res = query.exec(queryStr);
    if(!Res)
    {
        qDebug() << "Error "<< queryStr << query.lastError();
    }
    return Res;
}

bool QtMysqlObj::ExeQuery(const QString& queryStr , QVector<QVector<QString>>& data)
{
    if(bIsOpen == false)
    {
        qDebug() << "mysql not connect";
        return false;
    }

    QSqlQuery query(db);
    bool Res = query.exec(queryStr);
    if(!Res)
    {
        qDebug() << "Error "<< queryStr << query.lastError();
    }
    else
    {
        QSqlRecord rec = query.record();

        while (query.next())
        {
            QVector<QString> linedata;
            for(int i = 0; i < rec.count(); i++)
            {
                linedata.push_back(query.value(i).toString());
            }
            data.push_back(linedata);
        }
    }

    return Res;
}

      
