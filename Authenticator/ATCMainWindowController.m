//
//  ATCMainWindowController.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainWindowController.h"

// Private Interfaces
@interface ATCMainWindowController ()

@end // Private Interfaces

// ATCMainWindowController class
@implementation ATCMainWindowController

- ( void ) windowDidLoad
    {
    [ super windowDidLoad ];
    
    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( didScanQRCodeOnScreen_: ) name: ATCDidScanQRCodeOnScreenNotif object: nil ];
    }

- ( void ) didScanQRCodeOnScreen_: ( NSNotification* )_Notif
    {
    [ self.window makeKeyAndOrderFront: self ];
    }

#pragma mark - Conforms to <NSWindowDelegate> 

- ( void ) windowDidEndLiveResize: ( NSNotification* )_Notif
    {
    [ self postNotificationOnBehalfOfMeWithName: ATCTotpBadgeViewShouldUpdateNotif ];
    }

@end // ATCMainWindowController class