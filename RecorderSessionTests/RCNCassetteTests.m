//
//  RCNCassetteTests.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 23.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

@import XCTest;
@import RecorderSession;
#import "RCNCassette+Private.h"

#define kURL [NSURL URLWithString:@"https://www.example.com/"]
#define kName @"GetExampleCom"

@interface RCNCassetteTests : XCTestCase
@end

@implementation RCNCassetteTests

- (NSURLRequest *)request
{
    return [[NSURLRequest alloc] initWithURL:kURL];
}

- (NSHTTPURLResponse *)response
{
    return [[NSHTTPURLResponse alloc] initWithURL:kURL
                                       statusCode:200
                                      HTTPVersion:@"HTTP/1.1"
                                     headerFields:@{}];
}

- (NSData *)data
{
    return [@"{\"hello\": \"world\"}" dataUsingEncoding:NSUTF8StringEncoding];
}

- (RCNCassette *)cassette
{
    return [[RCNCassette alloc] initWithName:kName
                                     request:[self request]
                                    response:[self response]
                                        data:[self data]
                                       error:nil];
}

#pragma mark -

- (void)testInit
{
    RCNCassette *cassette = [self cassette];
    XCTAssertEqualObjects(cassette.name, kName);
    XCTAssertEqualObjects(cassette.request, [self request]);
    XCTAssertEqualObjects(cassette.response.URL, [self response].URL);
    XCTAssertEqual(cassette.response.statusCode, [self response].statusCode);
    XCTAssertEqualObjects(cassette.responseData, [self data]);
}

- (void)testFileURL
{
    RCNCassette *cassette = [self cassette];

    NSString *expectedPathComponent = [NSString stringWithFormat:@"%@.json", kName];
    XCTAssertEqualObjects(cassette.fileURL.lastPathComponent, expectedPathComponent);
}

- (void)testWrite
{
    RCNCassette *cassette = [self cassette];
    BOOL success = [cassette writeToDisk];
    XCTAssertTrue(success);

    XCTAssertTrue([NSFileManager.defaultManager fileExistsAtPath:cassette.fileURL.path]);
    XCTAssertTrue([NSFileManager.defaultManager removeItemAtURL:cassette.fileURL error:NULL]);

    // Try to cleanup the cassette folder, if empty
    [NSFileManager.defaultManager removeItemAtURL:[cassette.fileURL URLByDeletingLastPathComponent] error:NULL];
}

- (void)testRequestValidationNone
{
    RCNCassette *cassette = [self cassette];

    NSError *error;
    BOOL result = [cassette validateRequest:[self request] validationOptions:RCNValidationOptionNone error:&error];
    XCTAssertTrue(result);
    XCTAssertNil(error);
}

- (void)testRequestValidationScheme
{
    NSMutableURLRequest *invalidRequest = (NSMutableURLRequest *)[[self request] mutableCopy];
    NSURLComponents *components = [NSURLComponents componentsWithURL:invalidRequest.URL resolvingAgainstBaseURL:YES];
    components.scheme = @"test";
    invalidRequest.URL = components.URL;

    [self runTestOptions:RCNValidationOptionScheme invalidRequest:invalidRequest];
    [self runWithoutErrorTestOptions:RCNValidationOptionScheme invalidRequest:invalidRequest];
}

- (void)testRequestValidationHostUser
{
    NSMutableURLRequest *invalidRequest = (NSMutableURLRequest *)[[self request] mutableCopy];
    NSURLComponents *components = [NSURLComponents componentsWithURL:invalidRequest.URL resolvingAgainstBaseURL:YES];
    components.user = @"invalid";
    invalidRequest.URL = components.URL;

    [self runTestOptions:RCNValidationOptionHost invalidRequest:invalidRequest];
}

- (void)testRequestValidationHostPassword
{
    NSMutableURLRequest *invalidRequest = (NSMutableURLRequest *)[[self request] mutableCopy];
    NSURLComponents *components = [NSURLComponents componentsWithURL:invalidRequest.URL resolvingAgainstBaseURL:YES];
    components.password = @"invalid";
    invalidRequest.URL = components.URL;

    [self runTestOptions:RCNValidationOptionHost invalidRequest:invalidRequest];
}

- (void)testRequestValidationHost
{
    NSMutableURLRequest *invalidRequest = (NSMutableURLRequest *)[[self request] mutableCopy];
    NSURLComponents *components = [NSURLComponents componentsWithURL:invalidRequest.URL resolvingAgainstBaseURL:YES];
    components.host = @"invalid";
    invalidRequest.URL = components.URL;

    [self runTestOptions:RCNValidationOptionHost invalidRequest:invalidRequest];
}

- (void)testRequestValidationHostPort
{
    NSMutableURLRequest *invalidRequest = (NSMutableURLRequest *)[[self request] mutableCopy];
    NSURLComponents *components = [NSURLComponents componentsWithURL:invalidRequest.URL resolvingAgainstBaseURL:YES];
    components.port = @66666;
    invalidRequest.URL = components.URL;

    [self runTestOptions:RCNValidationOptionHost invalidRequest:invalidRequest];
}

- (void)testRequestValidationPath
{
    NSMutableURLRequest *invalidRequest = (NSMutableURLRequest *)[[self request] mutableCopy];
    NSURLComponents *components = [NSURLComponents componentsWithURL:invalidRequest.URL resolvingAgainstBaseURL:YES];
    components.path = @"/invalid/path";
    invalidRequest.URL = components.URL;

    [self runTestOptions:RCNValidationOptionPath invalidRequest:invalidRequest];
}

- (void)testRequestValidationQuery
{
    NSMutableURLRequest *invalidRequest = (NSMutableURLRequest *)[[self request] mutableCopy];
    NSURLComponents *components = [NSURLComponents componentsWithURL:invalidRequest.URL resolvingAgainstBaseURL:YES];
    components.query = @"invalid=query&value=false";
    invalidRequest.URL = components.URL;

    [self runTestOptions:RCNValidationOptionQuery invalidRequest:invalidRequest];
}

- (void)testRequestValidationHTTPMethod
{
    NSMutableURLRequest *invalidRequest = (NSMutableURLRequest *)[[self request] mutableCopy];
    invalidRequest.HTTPMethod = @"OPTIONS";

    [self runTestOptions:RCNValidationOptionHTTPMethod invalidRequest:invalidRequest];
}

- (void)testRequestValidationHTTPBody
{
    NSMutableURLRequest *invalidRequest = (NSMutableURLRequest *)[[self request] mutableCopy];
    invalidRequest.HTTPBody = [@"something.else" dataUsingEncoding:NSUTF8StringEncoding];

    [self runTestOptions:RCNValidationOptionHTTPBody invalidRequest:invalidRequest];
}

- (void)testRequestValidationHTTPHeaderFields
{
    NSMutableURLRequest *invalidRequest = (NSMutableURLRequest *)[[self request] mutableCopy];
    invalidRequest.allHTTPHeaderFields = @{ @"invalid": @"header",
        @"Content-Type": @"text/invalid" };

    [self runTestOptions:RCNValidationOptionHTTPHeaderFields invalidRequest:invalidRequest];
}

- (void)runTestOptions:(RCNValidationOptions)options invalidRequest:(NSURLRequest *)invalidRequest
{
    RCNCassette *cassette = [self cassette];
    NSURLRequest *validRequest = [self request];

    NSError *error;
    BOOL result = [cassette validateRequest:validRequest validationOptions:options error:&error];
    XCTAssertTrue(result);
    XCTAssertNil(error);

    result = [cassette validateRequest:invalidRequest validationOptions:options error:&error];
    XCTAssertFalse(result);
    XCTAssertNotNil(error);
}

- (void)runWithoutErrorTestOptions:(RCNValidationOptions)options invalidRequest:(NSURLRequest *)invalidRequest
{
    RCNCassette *cassette = [self cassette];
    NSURLRequest *validRequest = [self request];
    XCTAssertTrue([cassette validateRequest:validRequest validationOptions:options error:NULL]);
    XCTAssertFalse([cassette validateRequest:invalidRequest validationOptions:options error:NULL]);
}

@end
