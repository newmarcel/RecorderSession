//
//  RCNCassetteResponseType.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 22.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RCNCassetteResponseTypeNone = 0,
    RCNCassetteResponseTypeJSON,
    RCNCassetteResponseTypeData
} RCNCassetteResponseType;

NSString *RCNCassetteResponseTypeToString(RCNCassetteResponseType type);
RCNCassetteResponseType RCNCassetteResponseTypeFromString(NSString *string);

NS_ASSUME_NONNULL_END
