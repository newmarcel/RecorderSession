//
//  RCNRecorderSession.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <RecorderSession/RCNRecorderSession.h>
#import "RecorderSessionDefines.h"
#import "RCNRecorderSessionDataTask.h"
#import "RCNCassette/RCNCassette.h"
#import "NSBundle+RCNCassette+Private.h"
#import "RCNFinishRecording.h"

@interface RCNRecorderSession ()
@property (nonatomic, readwrite) NSURLSession *backingSession;
@property (nonatomic, readwrite) NSBundle *cassetteBundle;
@property (nonatomic) NSMutableArray *insertedMutableCassettes;
@property (nonatomic, readonly, nullable) NSString *currentCassette;
@property (copy, nonatomic, nonnull) RCNRecordingCompletionHandler recordingCompletionHandler;
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
        
        self.recordingCompletionHandler = ^(NSString *message, NSString *cassetteName, NSString *absolutePath) {
            RCNFinishRecording(message, cassetteName, absolutePath);
        };
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

#pragma mark - NSURLSessionDataTask Creation

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
    __auto_type handler = ^(NSData *data, NSURLResponse *response, NSError *error) {
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
        
        NSString *message;
        if(isWritten)
        {
            message = @"Finished recording cassette.";
        }
        else
        {
            message = @"Failed to record cassette.";
        }
        self.recordingCompletionHandler(message, cassette.name, cassette.fileURL.absoluteString);
    };
    return [self.backingSession dataTaskWithRequest:request completionHandler:handler];
}

@end
