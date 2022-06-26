//
//  RCNCassetteResponseTypeTests.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 29.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RecorderSession/RecorderSession.h>
#import "../../Sources/RecorderSession/RCNCassette/RCNCassetteResponseType.h"

@interface RCNCassetteResponseTypeTests : XCTestCase
@end

@implementation RCNCassetteResponseTypeTests

- (void)testNone
{
    RCNCassetteResponseType type = RCNCassetteResponseTypeNone;
    NSString *string = RCNCassetteResponseTypeToString(type);
    XCTAssertEqualObjects(string, @"none");

    RCNCassetteResponseType convertedType = RCNCassetteResponseTypeFromString(string);
    XCTAssertEqual(type, convertedType);
    XCTAssertNotEqual(convertedType, RCNCassetteResponseTypeData);
    XCTAssertNotEqual(convertedType, RCNCassetteResponseTypeJSON);
}

- (void)testJSON
{
    RCNCassetteResponseType type = RCNCassetteResponseTypeJSON;
    NSString *string = RCNCassetteResponseTypeToString(type);
    XCTAssertEqualObjects(string, @"json");

    RCNCassetteResponseType convertedType = RCNCassetteResponseTypeFromString(string);
    XCTAssertEqual(type, convertedType);
    XCTAssertNotEqual(convertedType, RCNCassetteResponseTypeData);
    XCTAssertNotEqual(convertedType, RCNCassetteResponseTypeNone);
}

- (void)testData
{
    RCNCassetteResponseType type = RCNCassetteResponseTypeData;
    NSString *string = RCNCassetteResponseTypeToString(type);
    XCTAssertEqualObjects(string, @"data");

    RCNCassetteResponseType convertedType = RCNCassetteResponseTypeFromString(string);
    XCTAssertEqual(type, convertedType);
    XCTAssertNotEqual(convertedType, RCNCassetteResponseTypeNone);
    XCTAssertNotEqual(convertedType, RCNCassetteResponseTypeJSON);
}

@end
