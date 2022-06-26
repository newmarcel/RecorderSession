//
//  RCNRecorderSessionDataTaskTests.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 29.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RecorderSession/RecorderSession.h>
#import "../../Sources/RecorderSession/RCNCassette/RCNCassette.h"
#import "../../Sources/RecorderSession/NSBundle+RCNCassette+Private.h"
#import "../../Sources/RecorderSession/RCNRecorderSessionDataTask.h"
#import "../../Sources/RecorderSession/RCNDictionaryRepresentation/NSHTTPURLResponse+RCNDictionary.h"

@interface RCNRecorderSessionDataTaskTests : XCTestCase
@property (nonatomic, nullable) RCNRecorderSessionDataTaskCompletionHandler completion;
@end

@implementation RCNRecorderSessionDataTaskTests

- (void)tearDown
{
    self.completion = nil;
    [super tearDown];
}

- (RCNCassette *)cassette
{
    NSBundle *bundle = SWIFTPM_MODULE_BUNDLE.cassetteBundle;
    RCNCassette *cassette = [bundle cassetteWithName:@"GetSomething"];
    XCTAssertNotNil(cassette);
    return cassette;
}

- (void)testInit
{
    self.completion = ^(NSData *data, NSURLResponse *response, NSError *error) {
    };
    RCNRecorderSessionDataTask *task = [[RCNRecorderSessionDataTask alloc] initWithCassette:[self cassette]
                                                                          completionHandler:self.completion];
    XCTAssertNotNil(task);
}

- (void)testResume
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testResume"];

    RCNCassette *cassette = [self cassette];

    __weak typeof(self) weakSelf = self;
    self.completion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        [weakSelf validateBlockWithData:data response:response error:error];
        [expectation fulfill];
    };
    RCNRecorderSessionDataTask *task = [[RCNRecorderSessionDataTask alloc] initWithCassette:cassette completionHandler:self.completion];
    XCTAssertNotNil(task);
    [task resume];

    XCTWaiterResult result = [[XCTWaiter new] waitForExpectations:@[expectation] timeout:5.0];
    XCTAssertEqual(result, XCTWaiterResultCompleted);
}

- (void)validateBlockWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error
{
    RCNCassette *cassette = [self cassette];
    XCTAssertEqualObjects(cassette.responseData, data);
    // compare response dicts because there is no equality check for RCNHTTPURLResponse yet
    XCTAssertEqualObjects(cassette.response.rcn_dictionaryRepresentation,
        ((RCNHTTPURLResponse *)response).rcn_dictionaryRepresentation);
    XCTAssertEqualObjects(cassette.responseError, error);
}

@end
