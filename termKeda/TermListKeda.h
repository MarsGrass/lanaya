#pragma once
#include "TermKeda.h"
#include <QMap>


class CTermListKeda
{
    typedef QMap<std::string, CTermKeda*> TermMap;

public:
	CTermListKeda(void);
	~CTermListKeda(void);

public:
	//初始化命令
    int Init(QtMysqlManage* pMysql, int check_time = 60);

	//析构
	void UnInit();

	//查询该sn的终端是否注册
	bool IsTermExsit(std::string strTermSn);

	//获取设备
	CTermKeda* GetTermBySn(std::string strTermSn, bool auto_add = true);

	//获取设备
	CTermKeda* GetTermById(int term_id);
	
    //添加设备
    CTermKeda*  AddTerm(std::string strTermSn);

    //删除设备
    void DelelteTerm(std::string strTermSn);

	//根据设备ID删除设备
	void DeleteTermById(int term_id);

    //定时检查程序
    void Run(void);

private:
	TermMap term_map_;		//设备容器对象
	boost::thread* thread_; //设备管理线程
    boost::mutex mutex;    //共享读控制锁
	int check_time_;

    QtMysqlManage* mysql_;
};

