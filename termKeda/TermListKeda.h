#pragma once
#include "TermKeda.h"
#include <QMap>


typedef boost::shared_mutex ReadWriteLock;
typedef boost::shared_lock<ReadWriteLock> ReadLock;
typedef boost::unique_lock<ReadWriteLock> WriteLock;

class CTermListKeda
{
    typedef QMap<QString, CTermKeda*> TermMap;

public:
	CTermListKeda(void);
    CTermListKeda(QtMysqlManage* pMysql, int check_time = 60);
	~CTermListKeda(void);

public:
	//初始化命令
    int Init(QtMysqlManage* pMysql, int check_time = 60);

	//析构
	void UnInit();

    //
    bool IsTermExsit(const QString& strTermSn);

	//获取设备
    CTermKeda* GetTermBySn(const QString& strTermSn, bool auto_add = true);

//	//获取设备
//	CTermKeda* GetTermById(int term_id);
	
    //添加设备
    CTermKeda*  AddTerm(const QString& strTermSn);

    //删除设备
    void DelelteTerm(const QString& strTermSn);

//	//根据设备ID删除设备
//	void DeleteTermById(int term_id);

    //定时检查程序
    void Run(void);

private:
	TermMap term_map_;		//设备容器对象
	boost::thread* thread_; //设备管理线程
    ReadWriteLock mutex;    //共享读控制锁
	int check_time_;

    QtMysqlManage* mysql_;
};

