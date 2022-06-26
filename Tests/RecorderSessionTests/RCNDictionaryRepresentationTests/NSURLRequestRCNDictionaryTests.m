//
//  NSURLRequestRCNDictionaryTests.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 23.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RecorderSession/RecorderSession.h>
#import "../../../Sources/RecorderSession/RCNDictionaryRepresentation/NSURLRequest+RCNDictionary.h"

@interface NSURLRequestRCNDictionaryTests : XCTestCase
@end

@implementation NSURLRequestRCNDictionaryTests

- (NSDictionary *)dict
{
    return @{
        @"url": @{
            @"path": @"/v1/posts/all",
            @"query": @"format=json&results=25",
            @"host": @"api.pinboard.in",
            @"scheme": @"https"
        },
        @"httpMethod": @"GET",
        @"allHTTPHeaderFields": @{ @"Content-Type": @"application/json" }
    };
}

- (NSDictionary *)invalidDict
{
    return @{
        @"httpMethod": @"GET",
        @"allHTTPHeaderFields": @{ @"Content-Type": @"application/json" }
    }; // missing url
}

- (void)testMutableInitAndDictionaryRepresentation
{
    NSDictionary *dict = [self dict];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] rcn_initWithDictionaryRepresentation:dict];
    XCTAssertNotNil(request);

    NSDictionary *extractedDict = request.rcn_dictionaryRepresentation;
    XCTAssertEqualObjects([self dict], extractedDict);
}

- (void)testMutableInitFailed
{
    NSDictionary *dict = [self invalidDict];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] rcn_initWithDictionaryRepresentation:dict];
    XCTAssertNil(request);
}

@end
