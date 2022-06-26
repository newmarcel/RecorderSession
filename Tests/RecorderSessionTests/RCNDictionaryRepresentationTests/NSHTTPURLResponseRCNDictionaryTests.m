//
//  NSHTTPURLResponseRCNDictionaryTests.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 23.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RecorderSession/RecorderSession.h>
#import "../../../Sources/RecorderSession/RCNDictionaryRepresentation/NSHTTPURLResponse+RCNDictionary.h"

@interface NSHTTPURLResponseRCNDictionaryTests : XCTestCase
@end

@implementation NSHTTPURLResponseRCNDictionaryTests

- (NSDictionary *)dict
{
    return @{
        @"mimeType": @"text/plain",
        @"url": @{
            @"path": @"/v1/posts/update",
            @"query": @"format=json",
            @"host": @"api.pinboard.in",
            @"scheme": @"https"
        },
        @"statusCode": @200,
        @"suggestedFilename": @"update.txt",
        @"textEncodingName": @"utf-8",
        @"expectedContentLength": @41,
        @"allHeaderFields": @{
            @"Server": @"Apache/2.2.22 (Ubuntu)",
            @"Content-Type": @"text/plain; charset=utf-8",
            @"Vary": @"Accept-Encoding",
            @"Date": @"Sat, 11 Mar 2017 20:14:19 GMT",
            @"Content-Encoding": @"gzip",
            @"Keep-Alive": @"timeout=5, max=100",
            @"Content-Length": @"61",
            @"Connection": @"Keep-Alive"
        }
    };
}

- (NSDictionary *)invalidDict
{
    return @{
        @"mimeType": @"text/plain",
        @"suggestedFilename": @"update.txt",
        @"textEncodingName": @"utf-8",
        @"expectedContentLength": @41,
        @"allHeaderFields": @{
            @"Server": @"Apache/2.2.22 (Ubuntu)",
            @"Content-Type": @"text/plain; charset=utf-8",
            @"Vary": @"Accept-Encoding",
            @"Date": @"Sat, 11 Mar 2017 20:14:19 GMT",
            @"Content-Encoding": @"gzip",
            @"Keep-Alive": @"timeout=5, max=100",
            @"Content-Length": @"61",
            @"Connection": @"Keep-Alive"
        }
    }; // missing url and statusCode
}

#pragma mark - NSHTTPURLResponse Tests

- (void)testInitAndDictionaryRepresentation
{
    NSDictionary *dict = [self dict];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] rcn_initWithDictionaryRepresentation:dict];
    XCTAssertNotNil(response);
    XCTAssert([response isKindOfClass:[RCNHTTPURLResponse class]]);

    NSDictionary *extractedDict = response.rcn_dictionaryRepresentation;
    XCTAssertEqualObjects([self dict], extractedDict);
}

- (void)testInitFailed
{
    NSDictionary *dict = [self invalidDict];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] rcn_initWithDictionaryRepresentation:dict];
    XCTAssertNil(response);
}

#pragma mark - RCNHTTPURLResponse Tests

- (void)testPropertyOverrides
{
    NSDictionary *dict = [self dict];
    RCNHTTPURLResponse *response = [[RCNHTTPURLResponse alloc] rcn_initWithDictionaryRepresentation:dict];

    NSString *suggestedFilenameOverride = dict[@"suggestedFilename"];
    XCTAssertEqualObjects(suggestedFilenameOverride, response.suggestedFilename);
    XCTAssertEqualObjects(suggestedFilenameOverride, [response valueForKey:@"rcn_suggestedFilename"]);

    NSNumber *statusCodeOverride = dict[@"statusCode"];
    XCTAssertEqualObjects(statusCodeOverride, @(response.statusCode));
    XCTAssertEqualObjects(statusCodeOverride, [response valueForKey:@"rcn_statusCode"]);

    NSDictionary *allHeaderFieldsOverride = dict[@"allHeaderFields"];
    XCTAssertEqualObjects(allHeaderFieldsOverride, response.allHeaderFields);
    XCTAssertEqualObjects(allHeaderFieldsOverride, [response valueForKey:@"rcn_allHeaderFields"]);
}

@end
