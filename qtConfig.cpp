#include "qtConfig.h"

#include <QSettings>
#include <QCoreApplication>
#include "QtConfig.h"

qtConfig::qtConfig()
{
    GetConfig();
}

void qtConfig::GetConfig()
{
    QString strConfig = QCoreApplication::applicationDirPath() + "/config.txt";
    QSettings config(strConfig, QSettings::IniFormat);

    config.beginGroup("db");

    m_strDbServer = config.value("server", "127.0.0.1").toString();
    m_nDbPort = config.value("port", 3306).toInt();
    m_strDbUser = config.value("user", "root").toString();
    m_strDbPasswd = config.value("password", "123456").toString();
    m_strDbName = config.value("name", "lanaya").toString();

    config.endGroup();

    config.beginGroup("term");
    m_nTermServerPort = config.value("t_port", 3698).toInt();
    config.endGroup();
}
