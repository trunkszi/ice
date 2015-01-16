// **********************************************************************
//
// Copyright (c) 2003-2015 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#import <objc/Ice.h>
#import <TestCommon.h>
#import <objects/TestI.h>
#ifdef ICE_OBJC_GC
#   import <Foundation/NSGarbageCollector.h>
#endif

@interface CollocatedMyObjectFactory : NSObject<ICEObjectFactory>
@end

@implementation CollocatedMyObjectFactory

// Note that the object factory must not autorelease the
// returned objects.
-(ICEObject*) create:(NSString*)type
{
    if([type isEqualToString:@"::Test::B"])
    {
        return  [[TestObjectsBI alloc] init];
    }
    else if([type isEqualToString:@"::Test::C"])
    {
        return [[TestObjectsCI alloc] init];
    }
    else if([type isEqualToString:@"::Test::D"])
    {
        return [[TestObjectsDI alloc] init];
    }
    else if([type isEqualToString:@"::Test::E"])
    {
        return [[TestObjectsEI alloc] init];
    }
    else if([type isEqualToString:@"::Test::F"])
    {
        return [[TestObjectsFI alloc] init];
    }
    else if([type isEqualToString:@"::Test::I"])
    {
        return [[TestObjectsI alloc] init];
    }
    else if([type isEqualToString:@"::Test::J"])
    {
        return [[TestObjectsJI alloc] init];
    }
    else if([type isEqualToString:@"::Test::H"])
    {
        return [[TestObjectsHI alloc] init];
    }
    else
    {
        test(NO);
    }
    return nil;
}

-(void) destroy
{
    // Nothing to do
}
@end

static int
run(id<ICECommunicator> communicator)
{
#if defined(__clang__) && !__has_feature(objc_arc)
    id<ICEObjectFactory> factory = [[[CollocatedMyObjectFactory alloc] init] autorelease];
#else
    id<ICEObjectFactory> factory = [[CollocatedMyObjectFactory alloc] init];
#endif
    [communicator addObjectFactory:factory sliceId:@"::Test::B"];
    [communicator addObjectFactory:factory sliceId:@"::Test::C"];
    [communicator addObjectFactory:factory sliceId:@"::Test::D"];
    [communicator addObjectFactory:factory sliceId:@"::Test::E"];
    [communicator addObjectFactory:factory sliceId:@"::Test::F"];
    [communicator addObjectFactory:factory sliceId:@"::Test::I"];
    [communicator addObjectFactory:factory sliceId:@"::Test::J"];
    [communicator addObjectFactory:factory sliceId:@"::Test::H"];

    [[communicator getProperties] setProperty:@"TestAdapter.Endpoints" value:@"default -p 12010"];
    id<ICEObjectAdapter> adapter = [communicator createObjectAdapter:@"TestAdapter"];
#if defined(__clang__) && !__has_feature(objc_arc)
    TestObjectsInitialI* initial = [[[TestObjectsInitialI alloc] init] autorelease];
#else
    TestObjectsInitialI* initial = [[TestObjectsInitialI alloc] init];
#endif
    [adapter add:initial identity:[communicator stringToIdentity:@"initial"]];

#if defined(__clang__) && !__has_feature(objc_arc)
    ICEObject* uoet = [[[UnexpectedObjectExceptionTestI alloc] init] autorelease];
#else
    ICEObject* uoet = [[UnexpectedObjectExceptionTestI alloc] init];
#endif
    [adapter add:uoet identity:[communicator stringToIdentity:@"uoet"]];

    id<TestObjectsInitialPrx> objectsAllTests(id<ICECommunicator>, bool);
    objectsAllTests(communicator, NO);

    // We must call shutdown even in the collocated case for cyclic dependency cleanup
    [initial shutdown:nil];

    return EXIT_SUCCESS;
}

#if TARGET_OS_IPHONE
#  define main objectsCollocated
#endif

int
main(int argc, char* argv[])
{
    int status;
    @autoreleasepool
    {
        id<ICECommunicator> communicator = nil;
        @try
        {
            ICEInitializationData* initData = [ICEInitializationData initializationData];
            initData.properties = defaultServerProperties(&argc, argv);
#if TARGET_OS_IPHONE
            initData.prefixTable__ = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"TestObjects", @"::Test",
                                      nil];
#endif
            communicator = [ICEUtil createCommunicator:&argc argv:argv initData:initData];
            status = run(communicator);
        }
        @catch(ICEException* ex)
        {
            tprintf("%@\n", ex);
            status = EXIT_FAILURE;
        }

        if(communicator)
        {
            @try
            {
                [communicator destroy];
            }
            @catch(ICEException* ex)
            {
                tprintf("%@\n", ex);
                status = EXIT_FAILURE;
            }
        }
    }
#ifdef ICE_OBJC_GC
    [[NSGarbageCollector defaultCollector] collectExhaustively];
#endif
    return status;
}
