﻿
#include "qtMessagePool.h"

qtMessagePool::qtMessagePool(int nCount, QObject* qObj)
    : QObject(qObj)
{
    for(int i = 0; i < nCount; i++)
    {
        qtMessage* pMessage = new qtMessage(this);
        m_listMessage.push_back(pMessage);
    }
}

qtMessagePool::~qtMessagePool()
{
    for(int i = 0; i < m_listMessage.size(); i++)
    {
        qtMessage* pMessage = m_listMessage[i];
        delete pMessage;
    }
    m_listMessage.clear();
}

qtMessage* qtMessagePool::GetQtMessage(unsigned int nMsgSize)
{
    boost::mutex::scoped_lock lock(m_mutex);

    if(m_listMessage.size() == 0)
    {
        qtMessage* pMessage = new qtMessage(this);
        return pMessage;
    }

    qtMessage* pMessage = m_listMessage.front();
    m_listMessage.pop_front();
    if(pMessage->m_nSize < nMsgSize)
    {
        pMessage->m_data.resize(nMsgSize);
    }

    return pMessage;
}

void qtMessagePool::ReleaseQtMessage(qtMessage* pMessage)
{
    boost::mutex::scoped_lock lock(m_mutex);

    m_listMessage.push_back(pMessage);
}
