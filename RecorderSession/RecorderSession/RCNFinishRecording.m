//
//  RCNFinishRecording.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 04.06.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "RCNFinishRecording.h"
#import "RecorderSessionMacros.h"

void RCNFinishRecordingWithFunction(NSString *message, NSString *cassetteName, NSString *absolutePath, void(*abortFunction)(void))
{
    RCNLog(@"%@ \n - Name: %@\n - Path: %@", message, cassetteName, absolutePath);
    
    /*
     Finished recording the cassette.
     
     Please check the log message for the output path
     and potential errors.
     
     Please add the recorded JSON file to your `Cassettes.bundle`.
     */
    abortFunction();
}
