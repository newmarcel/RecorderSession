//
//  NSBundleRCNCassetteTests.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 23.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RecorderSession/RecorderSession.h>
#import "../../../Sources/RecorderSession/NSBundle+RCNCassette+Private.h"
#import "../../../Sources/RecorderSession/RCNCassette/RCNCassette.h"

@interface NSBundleRCNCassetteTests : XCTestCase
@end

@implementation NSBundleRCNCassetteTests

- (void)testCassetteBundle
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSBundle *cassetteBundle = bundle.cassetteBundle;
    XCTAssertNotNil(cassetteBundle);

    // Assume the xctest bundle doesn't contain a cassette bundle
    XCTAssertNil([NSBundle mainBundle].cassetteBundle);
}

- (void)testCassetteWithName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSBundle *cassetteBundle = bundle.cassetteBundle;

    RCNCassette *cassette = [cassetteBundle cassetteWithName:@"GetSomething"];
    XCTAssertNotNil(cassette);
}

- (void)testCassetteWithNameInSubdirectory
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSBundle *cassetteBundle = bundle.cassetteBundle;

    RCNCassette *cassette = [cassetteBundle cassetteWithName:@"Items/GetItems"];
    XCTAssertNotNil(cassette);
}

- (void)testCassetteWithNameFailed
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSBundle *cassetteBundle = bundle.cassetteBundle;

    RCNCassette *cassette = [cassetteBundle cassetteWithName:@"Void"];
    XCTAssertNil(cassette);
}

- (void)testCassetteEmpty
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSBundle *cassetteBundle = bundle.cassetteBundle;
    
    RCNCassette *cassette = [cassetteBundle cassetteWithName:@"Empty"];
    XCTAssertNil(cassette);
}

- (void)testCassetteInvalid
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSBundle *cassetteBundle = bundle.cassetteBundle;
    
    RCNCassette *cassette = [cassetteBundle cassetteWithName:@"Invalid"];
    XCTAssertNil(cassette);
}

@end
