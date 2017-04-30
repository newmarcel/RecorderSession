//
//  RecorderSessionMacros.h
//  RecorderSession
//
//  Created by Marcel Dierkes on 18.03.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#ifndef RCN_MACROS_H
#define RCN_MACROS_H

#ifndef RCN_LOG_ENABLED
#define RCN_LOG_ENABLED 1
#endif

#if RCN_LOG_ENABLED
#define RCNLog(args...) NSLog(args)
#else
#define RCNLog(args...)
#endif

#define RCNUnimplemented() @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Missing implementation" userInfo:nil]

#define RCNExit() abort();
#define RCNExitWithMessage(message) \
    RCNLog(@"%@", message);         \
    abort();

#endif /* RCN_MACROS_H */
