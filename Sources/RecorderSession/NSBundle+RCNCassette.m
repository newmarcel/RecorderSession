//
//  NSBundle+RCNCassette.m
//  RecorderSession
//
//  Created by Marcel Dierkes on 22.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <RecorderSession/NSBundle+RCNCassette.h>
#import "RecorderSessionDefines.h"
#import "RCNDictionaryRepresentation/RCNCassette+RCNDictionary.h"

#define kCassetteBundleName @"Cassettes"
#define kBundleExtension @"bundle"

@implementation NSBundle (RCNCassette)

- (NSBundle *)cassetteBundle
{
    NSURL *cassetteBundleURL = [self URLForResource:kCassetteBundleName withExtension:kBundleExtension];
    if(cassetteBundleURL == nil)
    {
        return nil;
    }
    return [NSBundle bundleWithURL:cassetteBundleURL];
}

- (nullable RCNCassette *)cassetteWithName:(NSString *)name
{
    NSParameterAssert(name);

    NSString *actualName = name.lastPathComponent;
    NSString *subPath = [name stringByDeletingLastPathComponent];

    NSURL *cassetteURL = [self URLForResource:actualName withExtension:@"json" subdirectory:subPath];
    if(cassetteURL == nil)
    {
        RCNLog(@"Missing cassette for name \"%@\".", name);
        return nil;
    }

    NSData *data = [NSData dataWithContentsOfURL:cassetteURL];
    if(data == nil || data.length == 0)
    {
        RCNLog(@"The cassette \"%@\" appears to be empty.", name);
        return nil;
    }

    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error != nil || dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]])
    {
        RCNLog(@"The cassette \"%@\" is not a valid json file.", name);
        return nil;
    }

    return [[RCNCassette alloc] rcn_initWithDictionaryRepresentation:dictionary];
}

@end
