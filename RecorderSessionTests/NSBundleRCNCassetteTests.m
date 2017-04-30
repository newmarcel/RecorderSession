//
//  NSBundleRCNCassetteTests.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 23.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

@import XCTest;
@import RecorderSession;
#import "NSBundle+RCNCassette+Private.h"
#import "RCNCassette.h"

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

@end
