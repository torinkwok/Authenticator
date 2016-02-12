//
//  ATCOTPBadgeView.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPBadgeView.h"
#import "ATCTotpEntry.h"

// ATCOTPBadgeView class
@implementation ATCOTPBadgeView

- ( void ) awakeFromNib
    {
    optDrawingAttrs_ = @{ NSFontAttributeName : [ NSFont fontWithName: @"Courier New" size: 44.f ]
                        , NSForegroundColorAttributeName : [ NSColor whiteColor ]
                        };

    self.wantsLayer = YES;
    isInWarning_ = [ AGClock remainingSecondsForRecalculation ] < ATCWarningTimeStep;

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( totpEntryShouldUpdate: ) name: ATCTotpBadgeViewShouldUpdateNotif object: nil ];

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( totpEntryShouldUpdate: ) name: ATCShouldShowWarningsNotif object: nil ];

    self.needsDisplay = YES;
    }

- ( void ) totpEntryShouldUpdate: ( NSNotification* )_Notif
    {
    if ( [ _Notif.name isEqualToString: ATCShouldShowWarningsNotif ] )
        isInWarning_ = YES;

    if ( [ AGClock remainingSecondsForRecalculation ] > ATCWarningTimeStep )
        isInWarning_ = NO;

    self.needsDisplay = YES;
    }

#pragma mark - Drawing

- ( BOOL ) isFlipped
    {
    return YES;
    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    isInWarning_ ? [ ATCWarningPINColor() set ] : [ ATCNormalPINColor() set ];

    NSBezierPath* roundedBoundsPath =
        [ NSBezierPath bezierPathWithRoundedRect: self.bounds
                       withRadiusOfTopLeftCorner: 6.f
                                bottomLeftCorner: 6.f
                                  topRightCorner: 6.f
                               bottomRightCorner: 6.f
                                       isFlipped: NO ];

    [ roundedBoundsPath fill ];

    [ optEntry_.pinCodeRightNow drawAtPoint: NSMakePoint( 0, 0 ) withAttributes: optDrawingAttrs_ ];
    }

#pragma mark - Dynamic Properties

@dynamic optEntry;

- ( void ) setOptEntry: ( ATCTotpEntry* )_NewEntry
    {
    if ( optEntry_ != _NewEntry )
        {
        optEntry_ = _NewEntry;
        self.needsDisplay = YES;
        }
    }

- ( ATCTotpEntry* ) optEntry
    {
    return optEntry_;
    }

@end // ATCOTPBadgeView class
