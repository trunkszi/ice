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
        Ice.Object object = new ThrowerI(adapter);
        adapter.add(object, Ice.Util.stringToIdentity("thrower"));

        AllTests.allTests(communicator, true);

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
        catch (Ice.LocalException ex)
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
            catch (Ice.LocalException ex)
            {
                ex.printStackTrace();
                status = 1;
            }
        }

        System.exit(status);
    }
}
