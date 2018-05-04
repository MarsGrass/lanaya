#include "TermListKeda.h"
#include "termsql.h"

CTermListKeda::CTermListKeda(void)
{
    mysql_ = NULL;
}

CTermListKeda::CTermListKeda(QtMysqlManage* pMysql, int check_time)
{
    Init(pMysql, check_time);
}

CTermListKeda::~CTermListKeda(void)
{
}

int CTermListKeda::Init(QtMysqlManage* pMysql, int check_time)
{
    qDebug()<< "CTermListKeda::Init";

    mysql_ = pMysql;
    check_time_ = check_time;

    QtMysqlObj* pMysqlObj = mysql_->GetMysqlObj();
    if(pMysqlObj == NULL){
        qDebug()<< "CTermListKeda::Init failed";
        return -1;
	}

    QVector<QVector<QString>> Querydata;
    bool bQuery = pMysqlObj->ExeQuery(TERM_LIST, Querydata);
    if(bQuery == false)
    {
        qDebug() << "execute sql:" << TERM_LIST << " failed";
    }
    else
    {
        int nSize = Querydata.size();
        if(nSize > 0) //表明能够查询到数据
        {
            for (int i = 0; i < nSize; i++)
            {
                QString sn = Querydata[i][0];
                CTermKeda* pTerm = new CTermKeda(mysql_, sn);
                term_map_.insert(sn, pTerm);
            }
        }
    }

	TermMap::iterator it = term_map_.begin();
    for(; it != term_map_.end(); it++)
    {
        CTermKeda* pTerm = it.value();
		{
            QString sql = QString(TERM_OFF).arg(pTerm->m_strSn);
            pMysqlObj->ExeQuery(sql);
		}
    }
    mysql_->ReleaseMysqlObj(pMysqlObj);

	thread_ = new boost::thread(boost::bind(&CTermListKeda::Run, this));


    return 0;
}

void CTermListKeda::UnInit()
{
}

bool CTermListKeda::IsTermExsit(const QString& strTermSn)
{
    ReadLock readLock(mutex);

    TermMap::iterator it = term_map_.find(strTermSn);
    return (it == term_map_.end());
}

CTermKeda* CTermListKeda::GetTermBySn(const QString& strTermSn, bool auto_add)
{
    {
        ReadLock readLock(mutex);

        TermMap::iterator it = term_map_.find(strTermSn);
        if(it != term_map_.end())
        {
            return it.value();
        }
    }

    if(auto_add)
    {
        return AddTerm(strTermSn);
    }

    return NULL;
}

//CTermKeda* CTermListKeda::GetTermById(int term_id)
//{
//    {
//        ReadLock readLock(mutex);

//		TermMap::iterator itr = term_map_.begin();
//		for(; itr != term_map_.end(); itr++)
//		{
//            if(itr.value()->m_nNumId == term_id)
//			{
//                return  itr.value();
//			}
//		}
//    }

//    return NULL;
//}


CTermKeda* CTermListKeda::AddTerm(const QString& strTermSn)
{
    WriteLock writeLock(mutex);

    CTermKeda* pTerm = new CTermKeda(mysql_, strTermSn);
    term_map_.insert(strTermSn, pTerm);

    QtMysqlObj* pMysqlObj = mysql_->GetMysqlObj();
    QString sql = QString(TERM_INSERT).arg(strTermSn).arg(strTermSn);
    bool bQuery = pMysqlObj->ExeQuery(sql);
    if(bQuery == false){
        qDebug() << "execute sql:" << sql << " failed";
    }
    mysql_->ReleaseMysqlObj(pMysqlObj);

    return pTerm;
}

void CTermListKeda::DelelteTerm(const QString& strTermSn)
{
	WriteLock writeLock(mutex);

    TermMap::iterator it = term_map_.find(strTermSn);
    if(it != term_map_.end())
    {
        term_map_.erase(it);
    }
}

//void CTermListKeda::DeleteTermById(int term_id)
//{
//	WriteLock writeLock(mutex);

//	TermMap::iterator itr = term_map_.begin();
//	for(; itr != term_map_.end(); itr++)
//	{
//		if(itr->second->m_nNumId == term_id)
//		{
//			term_map_.erase(itr);
//			return ;
//		}
//	}
//}

void CTermListKeda::Run(void)
{
	while(true)
    {
        //获取系统当前时间
        QTime sec = QTime::currentTime();

        {
            ReadLock readLock(mutex);

            //遍历设备容器，执行定时操作
            TermMap::iterator it = term_map_.begin();
            for(; it != term_map_.end(); it++)
            {
                CTermKeda* pTerm = it.value();
				if(pTerm->m_online == 1)
				{
                    pTerm->OnTime(sec);
				}
            }
        }

        //定时睡眠
        boost::xtime xt;
        boost::xtime_get(&xt, boost::TIME_UTC_);
        xt.sec += check_time_;
        boost::thread::sleep(xt);
    }
}


