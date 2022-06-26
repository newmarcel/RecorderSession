//
//  NSBundle+RCNCassette.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 22.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Convenience extension for `NSBundle` to retrieve the `cassetteBundle` URL.
 */
@interface NSBundle (RCNCassette)

/**
 Returns the 'Cassettes.bundle' from the supplied test framework bundle.
 */
@property (nonatomic, readonly, nullable) NSBundle *cassetteBundle NS_SWIFT_NAME(cassetteBundle);

@end

NS_ASSUME_NONNULL_END
