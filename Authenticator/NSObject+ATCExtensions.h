//
//  NSObject+ATCExtensions.h
//  Authenticator
//
//  Created by Tong G. on 2/12/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Foundation;

// NSObject + ATCExtensions
@interface NSObject ( ATCExtensions )

#pragma mark - Handling Notifications

- ( void ) postNotificationOnBehalfOfMeWithName: ( NSString* )_NotifName;

- ( void ) postNotificationOnBehalfOfMeWithName: ( NSString* )_NotifName
                                       userInfo: ( NSDictionary* )_UsrInfo;

@end // NSObject + ATCExtensions
