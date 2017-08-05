//
//  RCNFinishRecording.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 04.06.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define RCNFinishRecording(_msg, _name, _path) RCNFinishRecordingWithFunction(_msg, _name, _path, abort)

/**
 A recording completion handler compatible with `RCNFinishRecording`.

 @param message A success or failure message
 @param cassetteName The name of the cassette
 @param absolutePath The absolute output path of the JSON file
 */
typedef void(^RCNRecordingCompletionHandler)(NSString *message, NSString *cassetteName, NSString *absolutePath);

/**
 Finish recording cassettes with a helpful output log.
 
 This method never returns.
 
 @param message A success or failure message
 @param cassetteName The name of the cassette
 @param absolutePath The absolute output path of the JSON file
 @param abortFunction The function to be called in the abort case, expects a function, e.g. `abort()`.
 */
void RCNFinishRecordingWithFunction(NSString *message, NSString *cassetteName,
                                    NSString *absolutePath, void(*abortFunction)(void));

NS_ASSUME_NONNULL_END
