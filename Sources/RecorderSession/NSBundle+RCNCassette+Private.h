//
//  NSBundle+RCNCassette+Private.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 24.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RecorderSession/NSBundle+RCNCassette.h>

NS_ASSUME_NONNULL_BEGIN

@class RCNCassette;

@interface NSBundle (RCNCassettePrivate)

/**
 Returns the cassette for the supplied name or nil if no cassette
 with the supplied name can be found.
 
 @param name A cassette name
 @return A recorded cassette or nil.
 */
- (nullable RCNCassette *)cassetteWithName:(NSString *)name NS_SWIFT_NAME(cassette(name:));

@end

NS_ASSUME_NONNULL_END
