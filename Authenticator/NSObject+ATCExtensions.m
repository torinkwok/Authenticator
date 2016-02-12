//
//  NSObject+ATCExtensions.m
//  Authenticator
//
//  Created by Tong G. on 2/12/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "NSObject+ATCExtensions.h"

// NSObject + ATCExtensions
@implementation NSObject ( ATCExtensions )

#pragma mark - Handling Notifications

- ( void ) postNotificationOnBehalfOfMeWithName: ( NSString* )_NotifName
    {
    [ self postNotificationOnBehalfOfMeWithName: _NotifName userInfo: nil ];
    }

- ( void ) postNotificationOnBehalfOfMeWithName: ( NSString* )_NotifName
                                       userInfo: ( NSDictionary* )_UsrInfo
    {
    [ [ NSNotificationCenter defaultCenter ]
        postNotificationName: _NotifName object: self userInfo: _UsrInfo ];
    }

@end // NSObject + ATCExtensions
