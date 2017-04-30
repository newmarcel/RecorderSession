//
//  NSHTTPURLResponse+RCNDictionary.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "NSHTTPURLResponse+RCNDictionary.h"
#import "NSURLComponents+RCNDictionary.h"

@implementation NSHTTPURLResponse (RCNDictionary)

- (nullable instancetype)rcn_initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    return [[RCNHTTPURLResponse alloc] rcn_initWithDictionaryRepresentation:dictionary];
}

- (NSDictionary *)rcn_dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary new];

    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:self.URL resolvingAgainstBaseURL:YES];
    if(URLComponents != nil)
    {
        dict[@"url"] = URLComponents.rcn_dictionaryRepresentation;
    }

    if(self.MIMEType != nil)
    {
        dict[@"mimeType"] = self.MIMEType;
    }

    if(self.textEncodingName != nil)
    {
        dict[@"textEncodingName"] = self.textEncodingName;
    }

    if(self.suggestedFilename != nil)
    {
        dict[@"suggestedFilename"] = self.suggestedFilename;
    }

    dict[@"expectedContentLength"] = @(self.expectedContentLength);
    dict[@"statusCode"] = @(self.statusCode);
    dict[@"allHeaderFields"] = self.allHeaderFields;

    return [NSDictionary dictionaryWithDictionary:dict];
}

@end

@interface RCNHTTPURLResponse ()
@property (copy, nonatomic) NSString *rcn_suggestedFilename;
@property (nonatomic) NSInteger rcn_statusCode;
@property (copy, nonatomic) NSDictionary *rcn_allHeaderFields;
@end

@implementation RCNHTTPURLResponse

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

    NSString *MIMEType = dictionary[@"mimeType"];
    NSNumber *expectedContentLength = dictionary[@"expectedContentLength"];
    NSString *textEncodingName = dictionary[@"textEncodingName"];

    self = [super initWithURL:URL
                     MIMEType:MIMEType
        expectedContentLength:expectedContentLength.integerValue
             textEncodingName:textEncodingName];
    if(self)
    {
        self.rcn_suggestedFilename = dictionary[@"suggestedFilename"];
        NSNumber *statusCode = dictionary[@"statusCode"];
        self.rcn_statusCode = statusCode.integerValue;
        self.rcn_allHeaderFields = dictionary[@"allHeaderFields"];
    }
    return self;
}

- (NSDictionary *)rcn_dictionaryRepresentation
{
    return [super rcn_dictionaryRepresentation];
}

- (NSString *)suggestedFilename
{
    return self.rcn_suggestedFilename;
}

- (NSInteger)statusCode
{
    return self.rcn_statusCode;
}

- (NSDictionary *)allHeaderFields
{
    return self.rcn_allHeaderFields;
}

@end
