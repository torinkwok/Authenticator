//
//  ATCQRCodeScannerWindow.m
//  ScreenshotLab
//
//  Created by Tong G. on 2/22/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCQRCodeScannerWindow.h"

// ATCQRCodeScannerWindow class
@implementation ATCQRCodeScannerWindow

#pragma mark - Initializations

- ( void ) awakeFromNib
    {
    [ self setOpaque: NO ];
    [ self setBackgroundColor: [ NSColor clearColor ] ];
    [ self setTitleVisibility: NSWindowTitleHidden ];
    [ self setStyleMask: NSBorderlessWindowMask ];
    [ self setHasShadow: NO ];

    [ self setLevel: NSScreenSaverWindowLevel ];

    [ self setFrame: [ NSScreen mainScreen ].frame display: YES ];

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( applicationWillResignActive: ) name: NSApplicationWillResignActiveNotification object: NSApp ];
    }

- ( void ) applicationWillResignActive:(NSNotification *)notification
    {
    [ self close ];
    }

@end // ATCQRCodeScannerWindow class