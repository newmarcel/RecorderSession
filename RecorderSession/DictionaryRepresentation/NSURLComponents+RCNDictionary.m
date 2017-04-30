//
//  NSURLComponents+RCNDictionary.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "NSURLComponents+RCNDictionary.h"

@implementation NSURLComponents (RCNDictionary)

- (nullable instancetype)rcn_initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    self = [self init];
    if(self)
    {
        self.scheme = dictionary[@"scheme"];
        self.user = dictionary[@"user"];
        self.password = dictionary[@"password"];
        self.host = dictionary[@"host"];
        self.port = dictionary[@"port"];
        self.path = dictionary[@"path"];
        self.query = dictionary[@"query"];
        self.fragment = dictionary[@"fragment"];
    }
    return self;
}

- (NSDictionary *)rcn_dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if(self.scheme != nil)
    {
        dict[@"scheme"] = self.scheme;
    }
    if(self.user != nil)
    {
        dict[@"user"] = self.user;
    }
    if(self.password != nil)
    {
        dict[@"password"] = self.password;
    }
    if(self.host != nil)
    {
        dict[@"host"] = self.host;
    }
    if(self.port != nil)
    {
        dict[@"port"] = self.port;
    }
    if(self.path != nil && self.path.length > 0)
    {
        dict[@"path"] = self.path;
    }
    if(self.query != nil)
    {
        dict[@"query"] = self.query;
    }
    if(self.fragment != nil)
    {
        dict[@"fragment"] = self.fragment;
    }

    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
