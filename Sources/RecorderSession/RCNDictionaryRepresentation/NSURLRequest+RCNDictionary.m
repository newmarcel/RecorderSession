//
//  NSURLRequest+RCNDictionary.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "NSURLRequest+RCNDictionary.h"
#import "NSURLComponents+RCNDictionary.h"

@implementation NSURLRequest (RCNDictionary)

- (NSDictionary *)rcn_dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary new];

    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:self.URL resolvingAgainstBaseURL:YES];
    dict[@"url"] = URLComponents.rcn_dictionaryRepresentation;

    dict[@"httpMethod"] = self.HTTPMethod;

    if(self.allHTTPHeaderFields != nil)
    {
        dict[@"allHTTPHeaderFields"] = self.allHTTPHeaderFields;
    }

    NSString *body = [self.HTTPBody base64EncodedStringWithOptions:kNilOptions];
    if(body != nil)
    {
        dict[@"httpBody"] = body;
    }

    return [NSDictionary dictionaryWithDictionary:dict];
}

@end

@implementation NSMutableURLRequest (RCNDictionary)

- (nullable instancetype)rcn_initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    NSParameterAssert(dictionary);

    NSDictionary *componentsDict = dictionary[@"url"];
    if(componentsDict == nil)
    {
        return nil;
    }
    NSURLComponents *components = [[NSURLComponents alloc] rcn_initWithDictionaryRepresentation:componentsDict];
    NSURL *URL = components.URL;
    if(URL == nil)
    {
        return nil;
    }

    self = [self initWithURL:URL];
    if(self)
    {
        NSString *method = dictionary[@"httpMethod"];
        if(method == nil)
        {
            return nil;
        }
        self.HTTPMethod = method;

        NSDictionary *headers = dictionary[@"allHTTPHeaderFields"];
        if(headers != nil)
        {
            self.allHTTPHeaderFields = headers;
        }

        if(dictionary[@"httpBody"] != nil)
        {
            self.HTTPBody = [[NSData alloc] initWithBase64EncodedString:dictionary[@"httpBody"] options:kNilOptions];
        }
    }
    return self;
}

@end
