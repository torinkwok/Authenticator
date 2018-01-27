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

    [ NSApp setDelegate: self ];
    }

#pragma mark - Conforms to <NSWindowDelegate> 

- ( void ) windowDidEndLiveResize: ( NSNotification* )_Notif
    {
    [ self postNotificationOnBehalfOfMeWithName: ATCTotpBadgeViewShouldUpdateNotif ];
    }

#pragma mark - Conforms to <NSApplicationDelegate>

/* The code block below aims to fix the HIG Compliance issue reported by iTunes Connect reviewer:

    >>>>>>>>
    Aug 21, 2016 at 4:00 AM
    From Apple
    0. 1.0 Before You Submit - HIG Compliance

    ----------------------------------------------------------------------------------------------------

    Before you Submit


    The user interface of your app is not consistent with the OS X Human Interface Guidelines.

    Specifically, we found that when the user closes the main application window there is no menu item to re-open it.

    Next Steps

    It would be appropriate for the app to implement a Window menu that lists the main window so it can be reopened, or provide similar functionality in another menu item. OS X Human Interface Guidelines, state that "The menu bar [a]lways contains [a] Window menu".

    Alternatively, if the application is a single-window app, it might be appropriate to save data and quit the app when the main window is closed.

    For information on managing windows in Mac OS X, please review the following sections in Apple Human Interface Guidelines:

    * The Menu Bar and Its Menus
    * The Window Menu
    * The File Menu
    * Clicking in the Dock
    * Window Behavior

    Please evaluate how you can implement the appropriate changes, and resubmit your app for review.
    >>>>>>>>
  */
- ( BOOL ) applicationShouldTerminateAfterLastWindowClosed: ( NSApplication* )_Sender
  {
  return YES;
  }

// "Alternatively, if the application is a single-window app,
//  it might be appropriate to save data and quit the app when the main window is closed."
//
//- ( BOOL ) applicationShouldHandleReopen: ( NSApplication* )_Sender
//                       hasVisibleWindows: ( BOOL )_Flag
//    {
//    if ( _Flag )
//        [ self.window orderFront: self ];
//    else
//        [ self.window makeKeyAndOrderFront: self ];
//
//    return YES;
//    }

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
