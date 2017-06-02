//
//  RCNCassette+RCNDictionary.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 12.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "RCNCassette+RCNDictionary.h"
#import "RCNCassette+Private.h"
#import "RCNCassetteResponseType.h"
#import "NSURLRequest+RCNDictionary.h"
#import "NSHTTPURLResponse+RCNDictionary.h"

#define kKeyName @"name"
#define kKeyRequest @"request"
#define kKeyRequestHeaders @"additionalRequestHeaders"
#define kKeyResponse @"response"
#define kKeyBody @"body"
#define kKeyError @"error"
#define kKeyType @"type"
#define kKeyPayload @"payload"

@implementation RCNCassette (RCNDictionary)

- (NSDictionary *)rcn_dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary new];

    dict[kKeyName] = self.name;

    if(self.request)
    {
        dict[kKeyRequest] = self.request.rcn_dictionaryRepresentation;
    }

    if(self.response)
    {
        dict[kKeyResponse] = self.response.rcn_dictionaryRepresentation;
    }
    
    
    if(self.additionalRequestHeaders)
    {
        dict[kKeyRequestHeaders] = self.additionalRequestHeaders;
    }

    dict[kKeyBody] = [self bodyDictionary];

    if(self.responseError)
    {
        dict[kKeyError] = @(self.responseError.code);
    }

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (nullable instancetype)rcn_initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    NSParameterAssert(dictionary);

    self = [super init];
    if(self)
    {
        NSString *name = dictionary[kKeyName];
        if(name == nil)
        {
            return nil;
        }
        self.name = name;

        NSDictionary *requestDict = dictionary[kKeyRequest];
        if(requestDict == nil)
        {
            return nil;
        }

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] rcn_initWithDictionaryRepresentation:requestDict];
        if(request == nil)
        {
            return nil;
        }
        self.request = [request copy];

        NSDictionary *responseDict = dictionary[kKeyResponse];
        if(responseDict != nil)
        {
            self.response = [[RCNHTTPURLResponse alloc] rcn_initWithDictionaryRepresentation:responseDict];
        }
        
        if(dictionary[kKeyRequestHeaders])
        {
            self.additionalRequestHeaders = dictionary[kKeyRequestHeaders];
        }

        if(dictionary[kKeyBody] != nil)
        {
            [self setResponseDataWithBodyDictionary:dictionary[kKeyBody]];
        }

        NSAssert(dictionary[kKeyError] == nil, @"Error is not supported yet.");
    }
    return self;
}

- (NSDictionary *)bodyDictionary
{
    NSData *data = self.responseData;
    if(data)
    {
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
        if(responseObject != nil)
        {
            return @{
                kKeyType: RCNCassetteResponseTypeToString(RCNCassetteResponseTypeJSON),
                kKeyPayload: responseObject
            };
        }
        else
        {
            NSString *base64 = [data base64EncodedStringWithOptions:kNilOptions];
            if(base64)
            {
                return @{
                    kKeyType: RCNCassetteResponseTypeToString(RCNCassetteResponseTypeData),
                    kKeyPayload: base64
                };
            }
        }
    }

    return @{ kKeyType: RCNCassetteResponseTypeToString(RCNCassetteResponseTypeNone) };
}

- (void)setResponseDataWithBodyDictionary:(NSDictionary *)dictionary
{
    RCNCassetteResponseType type = RCNCassetteResponseTypeFromString(dictionary[kKeyType]);
    {
        switch(type)
        {
            case RCNCassetteResponseTypeNone:
                self.responseData = nil;
                break;
            case RCNCassetteResponseTypeJSON:
            {
                NSDictionary *payload = dictionary[kKeyPayload];
                if([NSJSONSerialization isValidJSONObject:payload])
                {
                    NSError *error;
                    NSData *data = [NSJSONSerialization dataWithJSONObject:payload options:kNilOptions error:&error];
                    if(error == nil)
                    {
                        self.responseData = data;
                    }
                }
                break;
            }
            case RCNCassetteResponseTypeData:
            {
                NSString *payload = dictionary[kKeyPayload];
                if(payload != nil)
                {
                    NSData *data = [[NSData alloc] initWithBase64EncodedString:payload options:kNilOptions];
                    self.responseData = data;
                }
                break;
            }
        }
    }
}

@end
