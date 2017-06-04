//
//  RCNRecorderSessionTests.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 23.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

@import XCTest;
@import RecorderSession;

@interface RCNRecorderSession (TestPrivate)
@property (nonatomic, readonly, nullable) NSString *currentCassette;
@end

@interface RCNRecorderSessionTests : XCTestCase
@end

@implementation RCNRecorderSessionTests

- (NSBundle *)cassetteBundle
{
    return [NSBundle bundleForClass:[self class]].cassetteBundle;
}

- (RCNRecorderSession *)session
{
    return [[RCNRecorderSession alloc] initWithBackingSession:NSURLSession.sharedSession cassetteBundle:[self cassetteBundle]];
}

#pragma mark -

- (void)testInit
{
    RCNRecorderSession *session = [self session];
    XCTAssertEqualObjects(session.backingSession, NSURLSession.sharedSession);
    XCTAssertEqualObjects(session.cassetteBundle, [self cassetteBundle]);
    XCTAssertEqual(session.insertedCassettes.count, 0);
    
    // Test forwarding
    XCTAssertEqualObjects(session.configuration, session.backingSession.configuration);
    [session invalidateAndCancel];
}

- (void)testInsertCassette
{
    RCNRecorderSession *session = [self session];
    XCTAssertEqual(session.insertedCassettes.count, 0);

    [session insertCassetteWithName:@"Tape1"];
    XCTAssertEqual(session.insertedCassettes.count, 1);

    // Inserting a new cassette will replace the original
    [session insertCassetteWithName:@"Tape2"];
    XCTAssertEqual(session.insertedCassettes.count, 1);
    XCTAssertEqualObjects(session.insertedCassettes.firstObject, @"Tape2");
}

- (void)testInsertCassettes
{
    RCNRecorderSession *session = [self session];
    XCTAssertEqual(session.insertedCassettes.count, 0);

    NSArray *cassettes = @[@"Tape1", @"Tape2", @"Tape3"];
    [session insertCassettes:cassettes];
    XCTAssertEqual(session.insertedCassettes.count, cassettes.count);

    // Inserting new cassettes will replace the original
    NSArray *newCassettes = @[@"Tape4", @"Tape5"];
    [session insertCassettes:newCassettes];
    XCTAssertEqual(session.insertedCassettes.count, newCassettes.count);
}

- (void)testEjectCassette
{
    RCNRecorderSession *session = [self session];
    XCTAssertEqual(session.insertedCassettes.count, 0);

    [session insertCassettes:@[@"Tape1", @"Tape2", @"Tape3"]];

    [session ejectCassette];
    NSArray *expectedCassettes = @[@"Tape2", @"Tape3"];
    XCTAssertEqualObjects(session.insertedCassettes, expectedCassettes);

    [session ejectCassette];
    expectedCassettes = @[@"Tape3"];
    XCTAssertEqualObjects(session.insertedCassettes, expectedCassettes);

    [session ejectCassette];
    expectedCassettes = @[];
    XCTAssertEqualObjects(session.insertedCassettes, expectedCassettes);
}

- (void)testEjectAllCassettes
{
    RCNRecorderSession *session = [self session];
    XCTAssertEqual(session.insertedCassettes.count, 0);

    [session insertCassettes:@[@"Tape1", @"Tape2", @"Tape3"]];
    [session ejectAllCassettes];
    XCTAssertEqual(session.insertedCassettes.count, 0);
}

- (void)testCurrentCassette
{
    RCNRecorderSession *session = [self session];
    XCTAssertNil(session.currentCassette);

    [session insertCassettes:@[@"Tape1", @"Tape2", @"Tape3"]];
    XCTAssertEqualObjects(session.currentCassette, @"Tape1");

    [session ejectCassette];
    XCTAssertEqualObjects(session.currentCassette, @"Tape2");

    [session ejectCassette];
    XCTAssertEqualObjects(session.currentCassette, @"Tape3");

    [session ejectCassette];
    XCTAssertNil(session.currentCassette);
}

@end
