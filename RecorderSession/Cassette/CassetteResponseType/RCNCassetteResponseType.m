//
//  RCNCassetteResponseType.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 22.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "RCNCassetteResponseType.h"

NSString *RCNCassetteResponseTypeToString(RCNCassetteResponseType type)
{
    switch(type)
    {
        case RCNCassetteResponseTypeJSON:
            return @"json";
        case RCNCassetteResponseTypeData:
            return @"data";
        default:
            return @"none";
    }
}

RCNCassetteResponseType RCNCassetteResponseTypeFromString(NSString *string)
{
    if([string isEqualToString:@"json"])
    {
        return RCNCassetteResponseTypeJSON;
    }
    if([string isEqualToString:@"data"])
    {
        return RCNCassetteResponseTypeData;
    }
    return RCNCassetteResponseTypeNone;
}
