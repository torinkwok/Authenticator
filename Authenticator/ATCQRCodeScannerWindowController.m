//
//  ATCQRCodeScannerWindowController.m
//  Authenticator
//
//  Created by Tong G. on 2/23/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCQRCodeScannerWindowController.h"

// Private Interfaces
@interface ATCQRCodeScannerWindowController ()

- ( void ) beginScanningQRCodeOnScreen_: ( NSNotification* )_Notif;
- ( void ) finishScanningQRCodeOnScreen_: ( NSNotification* )_Notif;

@end // Private Interfaces

// ATCQRCodeScannerWindowController class
@implementation ATCQRCodeScannerWindowController

#pragma mark - Initializations

- ( instancetype ) initWithWindowNibName: ( NSString* )_WindowNibName
    {
    if ( self = [ super initWithWindowNibName: _WindowNibName ] )
        {
        [ [ NSNotificationCenter defaultCenter ]
            addObserver: self selector: @selector( beginScanningQRCodeOnScreen_: ) name: ATCBeginScanningQRCodeOnScreenNotif object: nil ];

        [ [ NSNotificationCenter defaultCenter ]
            addObserver: self selector: @selector( finishScanningQRCodeOnScreen_: ) name: ATCFinishScanningQRCodeOnScreenNotif object: nil ];
        }

    return self;
    }

#pragma mark - Private Interfaces

- ( void ) beginScanningQRCodeOnScreen_: ( NSNotification* )_Notif
    {
    [ self.window makeKeyAndOrderFront: self ];
    }

- ( void ) finishScanningQRCodeOnScreen_: ( NSNotification* )_Notif
    {
    [ self.window orderOut: self ];
    }

@end // ATCQRCodeScannerWindowController class