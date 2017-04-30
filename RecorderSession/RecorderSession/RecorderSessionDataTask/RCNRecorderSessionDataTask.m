//
//  RCNRecorderSessionDataTask.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "RCNRecorderSessionDataTask.h"
#import "RecorderSessionMacros.h"
#import "RCNCassette.h"

@interface RCNRecorderSessionDataTask ()
@property (nonatomic, readwrite) RCNCassette *cassette;
@property (copy, nonatomic, readwrite) RCNRecorderSessionDataTaskCompletionHandler completionHandler;
@end

@implementation RCNRecorderSessionDataTask

- (instancetype)initWithCassette:(RCNCassette *)cassette completionHandler:(nonnull RCNRecorderSessionDataTaskCompletionHandler)completionHandler
{
    NSParameterAssert(cassette);
    NSParameterAssert(completionHandler);

    self = [super init];
    if(self)
    {
        self.cassette = cassette;
        self.completionHandler = completionHandler;
    }
    return self;
}

- (void)cancel
{
    RCNExitWithMessage(@"RecorderSession data tasks cannot be cancelled.");
}

- (void)resume
{
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_async(queue, ^{
        [self executeCompletionHandler];
    });
}

- (void)executeCompletionHandler
{
    NSData *data = self.cassette.responseData;
    NSURLResponse *response = self.cassette.response;
    NSError *error = self.cassette.responseError;

    self.completionHandler(data, response, error);
}

@end
