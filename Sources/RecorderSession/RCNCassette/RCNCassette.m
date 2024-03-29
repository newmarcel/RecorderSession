//
//  RCNCassette.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "RCNCassette.h"
#import "RCNCassette+Private.h"
#import "../RCNDictionaryRepresentation/RCNCassette+RCNDictionary.h"

NSString *const RCNCassetteErrorDomain = @"info.marcel-dierkes.RecorderSession.RCNCassetteErrorDomain";

static BOOL RCNIsEqual(id _Nullable lhs, id _Nullable rhs);

@implementation RCNCassette

- (instancetype)initWithName:(NSString *)name request:(NSURLRequest *)request additionalRequestHeaders:(nullable RCNHeaderDictionary *)additionalRequestHeaders response:(nullable NSHTTPURLResponse *)response data:(nullable NSData *)data error:(nullable NSError *)error
{
    NSParameterAssert(name);
    NSParameterAssert(request);

    self = [super init];
    if(self)
    {
        self.name = name;
        self.request = request;
        self.additionalRequestHeaders = additionalRequestHeaders;
        self.response = response;
        self.responseData = data;
        self.responseError = error;
    }
    return self;
}

- (NSURL *)outputDirectoryURL
{
#if TARGET_OS_OSX
    NSSearchPathDirectory searchPath = NSDesktopDirectory;
#else
    NSSearchPathDirectory searchPath = NSDocumentDirectory;
#endif

    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSURL *sourceDirectoryURL = [fileManager URLsForDirectory:searchPath inDomains:NSUserDomainMask].firstObject;
    NSURL *directoryURL = [sourceDirectoryURL URLByAppendingPathComponent:NSStringFromClass([self class])];

    [fileManager createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:NULL];
    return directoryURL;
}

- (NSString *)outputFileName
{
    NSString *sourceName = self.name;
    NSString *name = [sourceName stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.alphanumericCharacterSet];
    return [NSString stringWithFormat:@"%@.json", name];
}

- (NSURL *)fileURL
{
    return [[self outputDirectoryURL] URLByAppendingPathComponent:[self outputFileName]];
}

- (BOOL)writeToDisk
{
    NSDictionary *dict = self.rcn_dictionaryRepresentation;

    if(![NSJSONSerialization isValidJSONObject:dict])
    {
        return NO;
    }

    NSError *error;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if(error != nil)
    {
        return NO;
    }

    return [JSONData writeToURL:self.fileURL atomically:YES];
}

#pragma mark - Validation

- (BOOL)validateRequest:(NSURLRequest *)request additionalHeaders:(nullable RCNHeaderDictionary *)headers validationOptions:(RCNValidationOptions)options error:(NSError *_Nullable *)error
{
    NSParameterAssert(request);

    if(options == RCNValidationOptionNone)
    {
        if(error != NULL)
        {
            *error = nil;
        }
        return YES;
    }

    NSURLRequest *recordedRequest = self.request;

    // scheme
    if(options & RCNValidationOptionScheme)
    {
        if(recordedRequest.URL.scheme && ![recordedRequest.URL.scheme isEqual:request.URL.scheme])
        {
            NSString *reason = NSLocalizedString(@"The request's scheme doesn't match the recorded request.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
    }

    // user, password, host, port
    if(options & RCNValidationOptionHost)
    {
        if(!RCNIsEqual(recordedRequest.URL.user, request.URL.user))
        {
            NSString *reason = NSLocalizedString(@"The request's user doesn't match the recorded request.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
        if(!RCNIsEqual(recordedRequest.URL.password, request.URL.password))
        {
            NSString *reason = NSLocalizedString(@"The request's password doesn't match the recorded request.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
        if(!RCNIsEqual(recordedRequest.URL.host, request.URL.host))
        {
            NSString *reason = NSLocalizedString(@"The request's host doesn't match the recorded request.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
        if(!RCNIsEqual(recordedRequest.URL.port, request.URL.port))
        {
            NSString *reason = NSLocalizedString(@"The request's port doesn't match the recorded request.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
    }

    // path
    if(options & RCNValidationOptionPath)
    {
        if(![recordedRequest.URL.path isEqual:request.URL.path])
        {
            NSString *reason = NSLocalizedString(@"The request's path doesn't match the recorded request.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
    }

    // query
    if(options & RCNValidationOptionQuery)
    {
        if((recordedRequest.URL.query == nil && request.URL.query != nil)
            || (recordedRequest.URL.query && ![recordedRequest.URL.query isEqual:request.URL.query]))
        {
            NSString *reason = NSLocalizedString(@"The request's query doesn't match the recorded request.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
    }

    // HTTP method
    if(options & RCNValidationOptionHTTPMethod)
    {
        if(![recordedRequest.HTTPMethod isEqual:request.HTTPMethod])
        {
            NSString *reason = NSLocalizedString(@"The request's HTTP method doesn't match the recorded request.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
    }

    // HTTP body
    if(options & RCNValidationOptionHTTPBody)
    {
        if((recordedRequest.HTTPBody == nil && request.HTTPBody != nil)
            || (recordedRequest.HTTPBody && ![recordedRequest.HTTPBody isEqual:request.HTTPBody]))
        {
            NSString *reason = NSLocalizedString(@"The request's HTTP body doesn't match the recorded request.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
    }

    // HTTP headers
    if(options & RCNValidationOptionHTTPHeaderFields)
    {
        if((recordedRequest.allHTTPHeaderFields == nil && request.allHTTPHeaderFields != nil)
            || (recordedRequest.allHTTPHeaderFields && ![recordedRequest.allHTTPHeaderFields isEqual:request.allHTTPHeaderFields]))
        {
            NSString *reason = NSLocalizedString(@"The request's HTTP headers don't match the recorded request.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
    }

    // Additional request headers
    if(options & RCNValidationOptionAdditionalRequestHeaders)
    {
        if(!RCNIsEqual(self.additionalRequestHeaders, headers))
        {
            NSString *reason = NSLocalizedString(@"The additional HTTP request headers don't match the recorded headers.", nil);
            [self updateValidationError:error withReason:reason];
            return NO;
        }
    }

    return YES;
}

- (BOOL)updateValidationError:(NSError *_Nonnull *)error withReason:(nonnull NSString *)reason
{
    if(error == NULL)
    {
        return NO;
    }

    NSDictionary *userInfo = @{ NSLocalizedFailureReasonErrorKey: reason };
    *error = [NSError errorWithDomain:RCNCassetteErrorDomain code:RCNCassetteErrorRequestValidationFailed userInfo:userInfo];
    
    return YES;
}

@end

static BOOL RCNIsEqual(id _Nullable lhs, id _Nullable rhs)
{
    if(lhs == nil && rhs == nil)
    {
        return YES;
    }
    if(lhs == nil && rhs != nil)
    {
        return NO;
    }

    if([lhs isKindOfClass:[NSString class]])
    {
        return [lhs isEqualToString:rhs];
    }

    if([lhs isKindOfClass:[NSNumber class]])
    {
        return [lhs isEqualToNumber:rhs];
    }

    if([lhs isKindOfClass:[NSDictionary class]])
    {
        return [lhs isEqualToDictionary:rhs];
    }

    if([lhs isKindOfClass:[NSArray class]])
    {
        return [lhs isEqualToArray:rhs];
    }

    return [lhs isEqual:rhs];
}
