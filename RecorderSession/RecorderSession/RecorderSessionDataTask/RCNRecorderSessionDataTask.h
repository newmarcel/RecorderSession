//
//  RCNRecorderSessionDataTask.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RCNCassette;

typedef void (^RCNRecorderSessionDataTaskCompletionHandler)(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error);

/**
 An NSURLSessionDataTask subclass that replays the supplied cassette on a background
 queue and calls the supplied completion handler.
 */
@interface RCNRecorderSessionDataTask : NSURLSessionDataTask
@property (nonatomic, readonly) RCNCassette *cassette;
@property (copy, nonatomic, readonly) RCNRecorderSessionDataTaskCompletionHandler completionHandler;

/**
 The designated initializer.

 @param cassette A cassette to replay the data task
 @param completionHandler A custom completion handler
 @return A new data task
 */
- (instancetype)initWithCassette:(RCNCassette *)cassette
               completionHandler:(RCNRecorderSessionDataTaskCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
