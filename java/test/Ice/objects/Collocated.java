// **********************************************************************
//
// Copyright (c) 2001
// MutableRealms, Inc.
// Huntsville, AL, USA
//
// All Rights Reserved
//
// **********************************************************************

public class Collocated
{
    private static int
    run(String[] args, Ice.Communicator communicator)
    {
        String endpts = "default -p 12345 -t 2000";
        Ice.ObjectAdapter adapter = communicator.createObjectAdapterWithEndpoints("TestAdapter", endpts);
        Initial initial = new InitialI(adapter);
        adapter.add(initial, Ice.Util.stringToIdentity("initial"));
        // TODO: It should not be necessary to call activate(), but there
        // is a JDK bug (4531740) which currently causes the test to hang
        // without it. Remove this when the bug is fixed, or a workaround
        // is added to ThreadPool.
        adapter.activate();
        AllTests.allTests(communicator, true);
        // We must call shutdown even in the collocated case for cyclic dependency cleanup
        initial.shutdown(null);
        return 0;
    }

    public static void
    main(String[] args)
    {
        int status = 0;
        Ice.Communicator communicator = null;

        try
        {
            communicator = Ice.Util.initialize(args);
            status = run(args, communicator);
        }
        catch(Ice.LocalException ex)
        {
            ex.printStackTrace();
            status = 1;
        }

        if (communicator != null)
        {
            try
            {
                communicator.destroy();
            }
            catch(Ice.LocalException ex)
            {
                ex.printStackTrace();
                status = 1;
            }
        }

        System.exit(status);
    }
}
