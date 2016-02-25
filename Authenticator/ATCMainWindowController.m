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

// Private Interfaces
- ( void ) beginScanningQRCodeOnScreen_: ( NSNotification* )_Notif;
- ( void ) finishScanningQRCodeOnScreen_: ( NSNotification* )_Notif;

@end // Private Interfaces

// ATCMainWindowController class
@implementation ATCMainWindowController

- ( void ) windowDidLoad
    {
    [ super windowDidLoad ];

    [ self.window setFrameUsingName: [ [ NSBundle mainBundle ].bundleIdentifier stringByAppendingString: @".MainWindow" ] force: NO ];

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( beginScanningQRCodeOnScreen_: ) name: ATCBeginScanningQRCodeOnScreenNotif object: nil ];
    
    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( finishScanningQRCodeOnScreen_: ) name: ATCFinishScanningQRCodeOnScreenNotif object: nil ];
    }

#pragma mark - Conforms to <NSWindowDelegate> 

- ( void ) windowDidEndLiveResize: ( NSNotification* )_Notif
    {
    [ self postNotificationOnBehalfOfMeWithName: ATCTotpBadgeViewShouldUpdateNotif ];
    }

#pragma mark - Private Interfaces

- ( void ) beginScanningQRCodeOnScreen_: ( NSNotification* )_Notif
    {
    [ self.window orderOut: self ];
    }

- ( void ) finishScanningQRCodeOnScreen_: ( NSNotification* )_Notif
    {
    [ self.window makeKeyAndOrderFront: self ];
    }

@end // ATCMainWindowController class