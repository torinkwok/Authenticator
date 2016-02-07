//
//  ATCOTPBadgeView.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPBadgeView.h"

// ATCOTPBadgeView class
@implementation ATCOTPBadgeView

- ( void ) awakeFromNib
    {
    optDrawingAttrs_ = @{ NSFontAttributeName : [ NSFont fontWithName: @"Courier New" size: 44.f ]
                        , NSForegroundColorAttributeName : [ NSColor whiteColor ]
                        };
    }

#pragma mark - Drawing

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    
    [ [ NSColor colorWithHTMLColor: @"52AAEE" ] set ];

    NSBezierPath* roundedBoundsPath =
        [ NSBezierPath bezierPathWithRoundedRect: self.bounds
                       withRadiusOfTopLeftCorner: 6.f
                                bottomLeftCorner: 6.f
                                  topRightCorner: 6.f
                               bottomRightCorner:6.f
                                       isFlipped: NO ];

    [ roundedBoundsPath fill ];

//    optEntry_.
    }

#pragma mark - Dynamic Properties

@dynamic optEntry;

- ( void ) setOptEntry: ( ATCOTPEntry* )_NewEntry
    {
    if ( optEntry_ != _NewEntry )
        {
        optEntry_ = _NewEntry;
        self.needsDisplay = YES;
        }
    }

- ( ATCOTPEntry* ) optEntry
    {
    return optEntry_;
    }

@end // ATCOTPBadgeView class
