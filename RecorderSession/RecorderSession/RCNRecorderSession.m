//
//  RCNRecorderSession.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "RCNRecorderSession.h"
#import "RecorderSessionMacros.h"
#import "RCNRecorderSessionDataTask.h"
#import "RCNCassette.h"
#import "NSBundle+RCNCassette+Private.h"

@interface RCNRecorderSession ()
@property (nonatomic, readwrite) NSURLSession *backingSession;
@property (nonatomic, readwrite) NSBundle *cassetteBundle;
@property (nonatomic) NSMutableArray *insertedMutableCassettes;
@property (nonatomic, readonly, nullable) NSString *currentCassette;
@end

@implementation RCNRecorderSession

- (instancetype)initWithBackingSession:(NSURLSession *)backingSession cassetteBundle:(nullable NSBundle *)bundle
{
    NSParameterAssert(backingSession);
    NSParameterAssert(bundle);

    self = [super init];
    if(self)
    {
        self.backingSession = backingSession;
        self.cassetteBundle = bundle;
        self.validationOptions = RCNValidationOptionDefault;
        self.insertedMutableCassettes = [NSMutableArray new];
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.backingSession;
}

#pragma mark - Insert and Eject

- (NSArray<NSString *> *)insertedCassettes
{
    return [NSArray arrayWithArray:self.insertedMutableCassettes];
}

- (nullable NSString *)currentCassette
{
    if(self.insertedMutableCassettes.count == 0)
    {
        return nil;
    }
    return self.insertedMutableCassettes[0];
}

- (void)insertCassetteWithName:(NSString *)name
{
    NSParameterAssert(name);

    [self insertCassettes:@[name]];
}

- (void)insertCassettes:(NSArray<NSString *> *)cassetteNames
{
    NSParameterAssert(cassetteNames);

    self.insertedMutableCassettes = [NSMutableArray arrayWithArray:cassetteNames];
}

- (void)ejectCassette
{
    if(self.insertedMutableCassettes.count > 0)
    {
        [self.insertedMutableCassettes removeObjectAtIndex:0];
    }
}

- (void)ejectAllCassettes
{
    [self.insertedMutableCassettes removeAllObjects];
}

#pragma mark - NSURLSession Subclass

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(nonnull void (^)(NSData *_Nullable, NSURLResponse *_Nullable, NSError *_Nullable))completionHandler
{
    RCNCassette *cassette = [self.cassetteBundle cassetteWithName:self.currentCassette];
    if(cassette)
    {
        NSError *error;
        [cassette validateRequest:request
                additionalHeaders:self.configuration.HTTPAdditionalHeaders
                validationOptions:self.validationOptions
                            error:&error];
        if(error != nil && error.domain == RCNCassetteErrorDomain && error.code == RCNCassetteErrorRequestValidationFailed)
        {
            NSString *reason = error.userInfo[NSLocalizedFailureReasonErrorKey];
            RCNExitWithMessage(reason);
        }

        // Replay and eject a recorded cassette
        [self ejectCassette];
        return [[RCNRecorderSessionDataTask alloc] initWithCassette:cassette completionHandler:completionHandler];
    }

    RCNHeaderDictionary *additionalHeaders = self.configuration.HTTPAdditionalHeaders;

    // Perform the live request and record the response
    id handler = ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *currentCassette = self.currentCassette;
        if(currentCassette == nil)
        {
            // Call the real completion handler if no cassette was inserted
            completionHandler(data, response, error);
            return;
        }

        RCNCassette *cassette = [[RCNCassette alloc] initWithName:currentCassette
                                                          request:request
                                         additionalRequestHeaders:additionalHeaders
                                                         response:(NSHTTPURLResponse *)response
                                                             data:data
                                                            error:error];
        BOOL isWritten = [cassette writeToDisk];
        if(isWritten)
        {
            RCNLog(@"Recorded new cassette \"%@\" at location %@.\nPlease add it to your test bundle to replay the request.",
                cassette.name,
                cassette.fileURL.absoluteString);
        }
        else
        {
            RCNLog(@"Failed to write cassette \"%@\" to %@.\nPlease check that the path is writable.",
                cassette.name,
                cassette.fileURL.absoluteString);
        }
        // Leave the test execution
        RCNExit();
    };
    return [self.backingSession dataTaskWithRequest:request completionHandler:handler];
}

@end
