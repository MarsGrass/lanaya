#include "TermListKeda.h"


CTermListKeda::CTermListKeda(void)
{
    mysql_ = NULL;
}


CTermListKeda::~CTermListKeda(void)
{
}

int CTermListKeda::Init(QtMysqlManage* pMysql, int check_time)
{
    qDebug()<< "CTermListKeda::Init";

    mysql_ = pMysql;

	int nRes;
    check_time_ = check_time;

    QtMysqlObj* pMysqlObj = mysql_->GetMysqlObj();
    if(pMysqlObj == NULL)
	{
        qDebug()<< "CTermListKeda::Init failed";
        return -1;
	}

    QVector<QVector<QString>> Querydata;
    bool bQuery = pMysqlObj->ExeQuery("select term_id, sn, name from Keda_term;", Querydata);
	if(bQuery == false)
	{
        qDebug()<< "select term_id, sn, name from Keda_term; failed";
	}	
	else
	{
        int nSize = Querydata.size();
		if(nSize > 0) //表明能够查询到数据
		{
			for (int i = 0; i < nSize; i++)
			{
                QString id = Querydata[i][0];
                QString sn = Querydata[i][1];
                QString name = Querydata[i][2];

				CTermKeda* pTerm = AddTerm(sn);
				pTerm->SetId(atoi(id.c_str()));
				pTerm->m_strName = name;
			}
		}
	}

	TermMap::iterator it = term_map_.begin();
    for(; it != term_map_.end(); it++)
    {
        CTermKeda* pTerm = it.value();
		{
            QString sql = QString("update Keda_term set link_status = 2, run_status = 2 where term_id = %1;").arg(pTerm->m_nNumId);
            pMysqlObj->ExeQuery(sql);
		}
    }

	thread_ = new boost::thread(boost::bind(&CTermListKeda::Run, this));


    return 0;
}

void CTermListKeda::UnInit()
{
}

bool CTermListKeda::IsTermExsit(std::string strTermSn)
{
	HD_TRACE(MORPHING, "CTermListKeda::IsTermExsit %p\n", this);

    ReadLock readLock(mutex);

    TermMap::iterator it = term_map_.find(strTermSn);
    return (it == term_map_.end());
}

CTermKeda* CTermListKeda::GetTermBySn(std::string strTermSn, bool auto_add)
{

    {
        ReadLock readLock(mutex);

        TermMap::iterator it = term_map_.find(strTermSn);
        if(it != term_map_.end())
        {
            return it->second;
        }
    }

    if(auto_add)
    {
        return AddTerm(strTermSn);
    }

    return NULL;
}

CTermKeda* CTermListKeda::GetTermById(int term_id)
{
    {
        ReadLock readLock(mutex);

		TermMap::iterator itr = term_map_.begin();
		for(; itr != term_map_.end(); itr++)
		{
			if(itr->second->m_nNumId == term_id)
			{
				return  itr->second;
			}
		}
    }

    return NULL;
}


CTermKeda* CTermListKeda::AddTerm(std::string strTermSn)
{
    WriteLock writeLock(mutex);

	CTermKeda* pTerm = new CTermKeda(strTermSn);
    term_map_[strTermSn] = pTerm;

    return pTerm;
}

void CTermListKeda::DelelteTerm(std::string strTermSn)
{
	WriteLock writeLock(mutex);

    TermMap::iterator it = term_map_.find(strTermSn);
    if(it != term_map_.end())
    {
        term_map_.erase(it);
    }
}

void CTermListKeda::DeleteTermById(int term_id)
{
	WriteLock writeLock(mutex);

	TermMap::iterator itr = term_map_.begin();
	for(; itr != term_map_.end(); itr++)
	{
		if(itr->second->m_nNumId == term_id)
		{
			term_map_.erase(itr);
			return ;
		}
	}
}

void CTermListKeda::Run(void)
{
	while(true)
    {
        //获取系统当前时间
        time_t sec = time(NULL);

        {
            ReadLock readLock(mutex);

            //遍历设备容器，执行定时操作
            TermMap::iterator it = term_map_.begin();
            for(; it != term_map_.end(); it++)
            {
				CTermKeda* pTerm = it->second;
				if(pTerm->m_online == 1)
				{
					pTerm->OnTime(sec, m_pServer);
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

void CTermListKeda::BindServer(NS_NET::NetServer* pServer)
{
	m_pServer = pServer;
}

