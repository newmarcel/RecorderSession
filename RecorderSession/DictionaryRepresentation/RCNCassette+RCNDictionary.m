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

@implementation RCNCassette (RCNDictionary)

- (NSDictionary *)rcn_dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary new];

    dict[@"name"] = self.name;

    if(self.request)
    {
        dict[@"request"] = self.request.rcn_dictionaryRepresentation;
    }

    if(self.response)
    {
        dict[@"response"] = self.response.rcn_dictionaryRepresentation;
    }

    dict[@"body"] = [self bodyDictionary];

    if(self.responseError)
    {
        dict[@"error"] = @(self.responseError.code);
    }

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (nullable instancetype)rcn_initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    NSParameterAssert(dictionary);

    self = [super init];
    if(self)
    {
        NSString *name = dictionary[@"name"];
        if(name == nil)
        {
            return nil;
        }
        self.name = name;

        NSDictionary *requestDict = dictionary[@"request"];
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

        NSDictionary *responseDict = dictionary[@"response"];
        if(responseDict != nil)
        {
            self.response = [[RCNHTTPURLResponse alloc] rcn_initWithDictionaryRepresentation:responseDict];
        }

        if(dictionary[@"body"] != nil)
        {
            [self setResponseDataWithBodyDictionary:dictionary[@"body"]];
        }

        NSAssert(dictionary[@"error"] == nil, @"Error is not supported yet.");
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
                @"type": RCNCassetteResponseTypeToString(RCNCassetteResponseTypeJSON),
                @"payload": responseObject
            };
        }
        else
        {
            NSString *base64 = [data base64EncodedStringWithOptions:kNilOptions];
            if(base64)
            {
                return @{
                    @"type": RCNCassetteResponseTypeToString(RCNCassetteResponseTypeData),
                    @"payload": base64
                };
            }
        }
    }

    return @{ @"type": RCNCassetteResponseTypeToString(RCNCassetteResponseTypeNone) };
}

- (void)setResponseDataWithBodyDictionary:(NSDictionary *)dictionary
{
    RCNCassetteResponseType type = RCNCassetteResponseTypeFromString(dictionary[@"type"]);
    {
        switch(type)
        {
            case RCNCassetteResponseTypeNone:
                self.responseData = nil;
                break;
            case RCNCassetteResponseTypeJSON:
            {
                NSDictionary *payload = dictionary[@"payload"];
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
                NSString *payload = dictionary[@"payload"];
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
