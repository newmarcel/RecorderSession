//
//  RCNRecorderSession.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCNValidationOptions.h"

NS_ASSUME_NONNULL_BEGIN

/**
 An `NSURLSession` subclass that can record and replay
 network requests as "cassettes".
 
 This class is intended as replacement for any
 `NSURLSession` instance during testing for mocking
 network requests and responses.
 */
@interface RCNRecorderSession : NSURLSession

/**
 The backing `NSURLSession` used for recording network requests
 and responses.
 */
@property (nonatomic, readonly) NSURLSession *backingSession;

/**
 The bundle that contains all recorded network requests.
 
 This is usually a `Cassettes.bundle` folder inside your test
 target containing the recorded cassette JSON files.
 */
@property (nonatomic, readonly, nullable) NSBundle *cassetteBundle;

/**
 The currently inserted cassettes. These names will be used
 as file names for recorded and replayed network requests.
 */
@property (nonatomic, readonly) NSArray<NSString *> *insertedCassettes;

/**
 Validation options for the supplied request. These options
 allow managing the granularity of the matching between
 the original and the recorded URL request.
 
 You can set individual validation options or XOR (^) out individual
 options from `.all`.
 
 e.g.:
 
 ```
 RCNValidationOptionScheme | RCNValidationOptionHost | RCNValidationOptionPath
 ```
 
 ```
 RCNValidationOptionAll ^ RCNValidationOptionQuery
 ```
 
 Defaults to `.default`
 */
@property (nonatomic) RCNValidationOptions validationOptions;

- (instancetype)init NS_UNAVAILABLE;

/**
 The designated initializer.

 @param backingSession The original session used for recording
 @param bundle A cassette bundle
 @return A new instance
 */
- (instancetype)initWithBackingSession:(NSURLSession *)backingSession
                        cassetteBundle:(nullable NSBundle *)bundle NS_DESIGNATED_INITIALIZER;

/**
 Inserts an empty or recorded cassette. If a cassette JSON file with
 the supplied name exists, it will be used for the following
 network request.
 
 If no cassette JSON file exists, a new cassette will be recorded
 and stored on disk, when the next network request is performed.

 @param name The cassette name
 */
- (void)insertCassetteWithName:(NSString *)name NS_SWIFT_NAME(insertCassette(name:));

/**
 Insert empty or recorded cassettes. If a cassette JSON file with
 the supplied name exists, it will be used for the following
 network request.
 
 If no cassette JSON file exists, a new cassette will be recorded
 and stored on disk, when the next network request is performed.
 
 `cassetteNames` will be used in order for subsequent requests,
 the first object will be dropped with the each request.

 @param cassetteNames Cassette names
 */
- (void)insertCassettes:(NSArray<NSString *> *)cassetteNames;

/**
 Ejects the currently inserted cassette.
 */
- (void)ejectCassette;

/**
 Ejects all inserted cassettes.
 */
- (void)ejectAllCassettes;

@end

NS_ASSUME_NONNULL_END
