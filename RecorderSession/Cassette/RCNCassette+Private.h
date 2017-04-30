//
//  RCNCassette+Private.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 29.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCNCassette.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCNCassette ()
@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSURLRequest *request;
@property (copy, nonatomic, readwrite, nullable) NSHTTPURLResponse *response;
@property (copy, nonatomic, readwrite, nullable) NSData *responseData;
@property (copy, nonatomic, readwrite, nullable) NSError *responseError;

@property (nonatomic, nonnull) NSURL *fileURL;
@end

NS_ASSUME_NONNULL_END
