//
//  RCNValidationOptions.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 24.04.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Validation options for comparing `NSURLRequest` objects.
 */
typedef NS_OPTIONS(NSUInteger, RCNValidationOptions) {

    /**
     Doesn't match any requests at all.
     */
    RCNValidationOptionNone NS_SWIFT_UNAVAILABLE("Use [] instead.") = 0,

    /**
     Validates the URL's scheme
     */
    RCNValidationOptionScheme = 1 << 0,

    /**
     Validates the URL's user, password, host and port
     */
    RCNValidationOptionHost = 1 << 1,

    /**
     Validates the URL's path
     */
    RCNValidationOptionPath = 1 << 2,

    /**
     Validates the URL's query
     */
    RCNValidationOptionQuery = 1 << 3,

    /**
     Validates the request's HTTP method
     */
    RCNValidationOptionHTTPMethod = 1 << 4,

    /**
     Validates the request's HTTP body
     */
    RCNValidationOptionHTTPBody = 1 << 5,

    /**
     Validates the request's HTTP headers
     */
    RCNValidationOptionHTTPHeaderFields = 1 << 6,

    /**
     Validates additional HTTP request headers
     */
    RCNValidationOptionAdditionalRequestHeaders = 1 << 7,

    /**
     Default validation options for `NSURLRequest` components.
     */
    RCNValidationOptionDefault = RCNValidationOptionScheme
        | RCNValidationOptionHost
        | RCNValidationOptionPath
        | RCNValidationOptionQuery
        | RCNValidationOptionHTTPMethod
        | RCNValidationOptionHTTPBody
        | RCNValidationOptionHTTPHeaderFields
};
