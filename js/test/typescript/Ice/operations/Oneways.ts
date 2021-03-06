// **********************************************************************
//
// Copyright (c) 2003-2018 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

import {Ice} from "ice";;
import {Test} from "./Test";
import {TestHelper} from "../../../Common/TestHelper";
const test = TestHelper.test;

export async function run(communicator:Ice.Communicator, prx:Test.MyClassPrx, bidir:boolean)
{
    prx = prx.ice_oneway();
    await prx.ice_ping();

    try
    {
        await prx.ice_isA(Test.MyClass.ice_staticId());
        test(false);
    }
    catch(ex)
    {
        // Expected: twoway proxy required
        test(ex instanceof Ice.TwowayOnlyException, ex);
    }

    try
    {
        await prx.ice_id();
        test(false);
    }
    catch(ex)
    {
        // Expected: twoway proxy required
        test(ex instanceof Ice.TwowayOnlyException, ex);
    }

    try
    {
        await prx.ice_ids();
        test(false);
    }
    catch(ex)
    {
        // Expected: twoway proxy required
        test(ex instanceof Ice.TwowayOnlyException, ex);
    }

    await prx.opVoid();
    await prx.opIdempotent();
    await prx.opNonmutating();

    try
    {
        await prx.opByte(0xff, 0x0f);
        test(false);
    }
    catch(ex)
    {
        // Expected: twoway proxy required
        test(ex instanceof Ice.TwowayOnlyException, ex);
    }
}
