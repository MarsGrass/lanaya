#ifndef qtConfig_H
#define qtConfig_H

#include <QObject>
#include <QString>

class qtConfig
{
public:
    qtConfig();

    void GetConfig();

public:
    QString m_strDbServer;
    int m_nDbPort;
    QString m_strDbUser;
    QString m_strDbPasswd;
    QString m_strDbName;

    int m_nTermServerPort;

};

#endif // qtConfig_H
