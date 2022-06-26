//
//  NSURLRequest+RCNDictionary.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 11.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCNDictionaryRepresentation.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (RCNDictionary)
@property (nonatomic, readonly) NSDictionary *rcn_dictionaryRepresentation;
@end

@interface NSMutableURLRequest (RCNDictionary) <RCNDictionaryRepresentation>
@end

NS_ASSUME_NONNULL_END
