//
//  RCNDictionaryRepresentation.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 23.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An implementing type is able to serialize itself as dictionary
 and initialize itself with a previously serialized dictionary.
 */
@protocol RCNDictionaryRepresentation <NSObject>

/**
 Returns the dictionary representation of the current type.
 */
@property (nonatomic, readonly) NSDictionary *rcn_dictionaryRepresentation NS_SWIFT_NAME(dictionaryRepresentation);

/**
 Initializes itself with a dictionary previously retrieved from
 `rcn_dictionaryRepresentation`.

 @param dictionary A dictionary representation of the current type.
 @return A new instance if the supplied dictionary is valid.
 */
- (nullable instancetype)rcn_initWithDictionaryRepresentation:(NSDictionary *)dictionary NS_SWIFT_NAME(init(dictionaryRepresentation:)) __attribute__((objc_method_family(init)));

@end

NS_ASSUME_NONNULL_END
