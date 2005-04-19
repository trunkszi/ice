// **********************************************************************
//
// Copyright (c) 2003-2005 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#ifndef SESSION_FACTORY_I_H
#define SESSION_FACTORY_I_H

#include <Session.h>

class SessionFactoryI : public Demo::SessionFactory, public IceUtil::Mutex
{
public:

    SessionFactoryI();
    virtual ~SessionFactoryI();

    virtual Demo::SessionPrx create(const ::Ice::Current&);
    virtual void shutdown(const Ice::Current&);
};

#endif
