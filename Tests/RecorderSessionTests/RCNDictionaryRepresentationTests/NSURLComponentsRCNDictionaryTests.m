//
//  NSURLComponentsRCNDictionaryTests.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 23.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RecorderSession/RecorderSession.h>
#import "../../../Sources/RecorderSession/RCNDictionaryRepresentation/NSURLComponents+RCNDictionary.h"

#define kScheme @"SCHEME"
#define kUser @"USER"
#define kPassword @"PASSWORD"
#define kHost @"HOST"
#define kPort @1234
#define kPath @"PATH"
#define kQuery @"QUERY"
#define kFragment @"FRGMT"

@interface NSURLComponentsRCNDictionaryTests : XCTestCase
@end

@implementation NSURLComponentsRCNDictionaryTests

- (NSDictionary *)dict
{
    return @{
        @"scheme": kScheme,
        @"user": kUser,
        @"password": kPassword,
        @"host": kHost,
        @"port": kPort,
        @"path": kPath,
        @"query": kQuery,
        @"fragment": kFragment
    };
}

- (NSDictionary *)partialDict
{
    return @{
        @"scheme": kScheme,
        @"user": kUser,
        @"password": kPassword,
        @"host": kHost,
        @"query": kQuery
    }; // removed port, path and fragment
}

- (void)testInitAndDictionaryRepresentation
{
    NSURLComponents *components = [[NSURLComponents alloc]
        rcn_initWithDictionaryRepresentation:[self dict]];
    XCTAssertNotNil(components);

    XCTAssert([components.scheme isEqualToString:kScheme]);
    XCTAssert([components.user isEqualToString:kUser]);
    XCTAssert([components.password isEqualToString:kPassword]);
    XCTAssert([components.host isEqualToString:kHost]);
    XCTAssert([components.port isEqualToNumber:kPort]);
    XCTAssert([components.path isEqualToString:kPath]);
    XCTAssert([components.query isEqualToString:kQuery]);
    XCTAssert([components.fragment isEqualToString:kFragment]);

    NSDictionary *extractedDict = components.rcn_dictionaryRepresentation;
    XCTAssertEqualObjects([self dict], extractedDict);
}

- (void)testPartialDictionaryRepresentation
{
    NSURLComponents *components = [[NSURLComponents alloc]
        rcn_initWithDictionaryRepresentation:[self partialDict]];
    XCTAssertNotNil(components);

    XCTAssert([components.scheme isEqualToString:kScheme]);
    XCTAssert([components.user isEqualToString:kUser]);
    XCTAssert([components.password isEqualToString:kPassword]);
    XCTAssert([components.host isEqualToString:kHost]);
    XCTAssertNil(components.port);
    XCTAssertEqualObjects(components.path, @""); // path resets to an empty string
    XCTAssert([components.query isEqualToString:kQuery]);
    XCTAssertNil(components.fragment);

    NSDictionary *extractedDict = components.rcn_dictionaryRepresentation;
    XCTAssertEqualObjects([self partialDict], extractedDict);
}

@end
