//
//  RCNFinishRecordingTests.m
//  RecorderSessionTests-macOS
//
//  Created by Marcel Dierkes on 05.08.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

@import XCTest;
@import RecorderSession;
#import "RCNFinishRecording.h"

static BOOL didCallFn = NO;

@interface RCNFinishRecordingTests : XCTestCase
@end

static void abortFunction()
{
    didCallFn = YES;
}

@implementation RCNFinishRecordingTests

- (void)testFinishRecording
{
    XCTAssertFalse(didCallFn);
    RCNFinishRecordingWithFunction(@"MSG", @"CASSETTE", @"/path", abortFunction);
    XCTAssertTrue(didCallFn);
}

@end
