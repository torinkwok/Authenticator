//
//  ATCQRCodeScannerWindowController.m
//  Authenticator
//
//  Created by Tong G. on 2/23/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCQRCodeScannerWindowController.h"

// ATCQRCodeScannerWindowController class
@implementation ATCQRCodeScannerWindowController

#pragma mark - Conforms to <NSWindowDelegate>

- ( void ) windowWillClose: ( NSNotification* )_Notification
    {
    [ [ NSNotificationCenter defaultCenter ]
        postNotificationName: ATCDidScanQRCodeOnScreenNotif object: self ];
    }

@end // ATCQRCodeScannerWindowController class