
#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVector>
#include <QDebug>

class QtMysqlObj : public QObject
{
    Q_OBJECT
public:
    QtMysqlObj(QObject* qObj = 0);
    ~QtMysqlObj();

    bool connectMySQL(const QString& server, const QString& username,
                      const QString& password, const QString& database, int port);

    void closeMySQL();

    bool isOpen();

    bool ExeQuery(const QString& queryStr);

    bool ExeQuery(const QString& queryStr, QVector<QVector<QString>>& data);


private:
    QSqlDatabase db;
    bool  bIsOpen;

    static int s_nIndex;
};
