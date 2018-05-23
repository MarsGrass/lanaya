QT += core sql
QT -= gui

CONFIG += c++11

TARGET = lanaya
CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

SOURCES += main.cpp \
    mysqlConn/mysql_interface.cpp \
    mysqlConn/mysql_pool.cpp \
    message/qtMessage.cpp \
    message/qtMessagePool.cpp \
    message/qtMessageQueue.cpp \
    message/qtMessageWork.cpp \
    message/qtMessageWorkManage.cpp \
    message/IoServer.cpp \
    message/IoSession.cpp \
    message/IoServicePool.cpp \
    message/qtMessageParse.cpp \
    message/IoSessionPool.cpp \
    termKeda/TermKeda.cpp \
    termKeda/TermListKeda.cpp \
    termKeda/TermServiceKeda.cpp \
    qtConfig.cpp \
    common/LogQt.cpp

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS



# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

#INCLUDEPATH += C:\study\mysql\include

INCLUDEPATH += C:\Boost\include\boost-1_66



HEADERS += \
    mysqlConn/mysql_interface.h \
    mysqlConn/mysql_pool.h \
    message/qtMessage.h \
    message/qtMessagePool.h \
    message/qtMessageQueue.h \
    message/qtMessageWork.h \
    message/qtMessageWorkManage.h \
    message/IoServer.h \
    message/IoServicePool.h \
    message/IoSession.h \
    message/qtMessageParse.h \
    message/IoSessionPool.h \
    termKeda/TermKeda.h \
    termKeda/TermListKeda.h \
    termKeda/TermServiceKeda.h \
    qtConfig.h \
    termKeda/termsql.h \
    common/LogQt.h

CONFIG(release,debug|release){
    LIBS += -LC:\Boost\lib -llibboost_thread-vc140-mt-x64-1_66

    DEFINES += _WIN32_WINNT=0x0501
}
CONFIG(debug,debug|release){
    LIBS += -LC:\Boost\lib -llibboost_thread-vc140-mt-gd-x64-1_66
 #   LIBS += C:\study\mysql\lib\libmysqld.lib

    DEFINES += -D_WIN32_WINNT=0x0501
}



