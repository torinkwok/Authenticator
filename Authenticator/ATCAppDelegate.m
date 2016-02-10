//
//  ATCAppDelegate.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAppDelegate.h"

// Private Interfaces
@interface ATCAppDelegate ()

@end // Private Interfaces

// ATCAppDelegate class
@implementation ATCAppDelegate

- ( void ) applicationWillResignActive: ( NSNotification* )_Notif
    {
    [ [ ATCTimer sharedTimer ] stopTiming ];
    }

- ( void ) applicationWillBecomeActive: ( NSNotification* )_Notif
    {
    [ [ ATCTimer sharedTimer ] startTiming ];
    }

@end // ATCAppDelegate class