//
//  RCNCassette.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCNValidationOptions.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The `RCNCassette` error domain.
 */
extern NSString *const RCNCassetteErrorDomain;

/**
 Cassette Errors.
 */
typedef NS_ENUM(NSInteger, RCNCassetteError) {
    /**
     A request doesn't match the cassette's recorded request.
     Please check the userInfo `NSLocalizedFailureReasonErrorKey` value
     for the underlying reason.
     */
    RCNCassetteErrorRequestValidationFailed = 1
};

/**
 An internal representation of a cassette.
 
 A cassette is a recorded network interaction consisting
 of an HTTP request and response.
 Cassettes are persisted on disk as simple JSON files.
 */
@interface RCNCassette : NSObject

/**
 The cassette name, also used as file name + the `json` extension.
 */
@property (copy, nonatomic, readonly) NSString *name;

/**
 The recorded HTTP request.
 */
@property (copy, nonatomic, readonly) NSURLRequest *request;

/**
 The recorded HTTP response.
 */
@property (copy, nonatomic, readonly, nullable) NSHTTPURLResponse *response;

/**
 Recorded response data or nil if the request failed without response.
 */
@property (copy, nonatomic, readonly, nullable) NSData *responseData;

/**
 An optional response error.
 */
@property (copy, nonatomic, readonly, nullable) NSError *responseError;

/**
 The URL to the cassette on disk (even if it has not been persisted yet).
 */
@property (nonatomic, readonly) NSURL *fileURL;

/**
 Convenience initializer to create a cassette with the given parameters.

 @param name The cassette name
 @param request An URL request
 @param response A (HTTP) URL response
 @param data Optional response data
 @param error Optional error
 */
- (instancetype)initWithName:(NSString *)name
                     request:(NSURLRequest *)request
                    response:(nullable NSHTTPURLResponse *)response
                        data:(nullable NSData *)data
                       error:(nullable NSError *)error;

/**
 Writes a cassette to disk at `fileURL`.

 @return YES if the file was written successfully
 */
- (BOOL)writeToDisk;

/**
 Validates the cassette's recorded `NSURLRequest` by comparing
 it to the supplied `request`.

 @param request The `NSURLRequest` for validation
 @param options Options to control the validation behavior
 @param error An optional error
 @return YES if the supplied request matches the cassette's recorded request
 */
- (BOOL)validateRequest:(NSURLRequest *)request validationOptions:(RCNValidationOptions)options error:(NSError *_Nullable *)error;

@end

NS_ASSUME_NONNULL_END
