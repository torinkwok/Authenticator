//
//  ATCOTPBadgeView.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPBadgeView.h"
#import "ATCTotpEntry.h"
#import "ATCOTPBadgeLayer.h"

// Private Interfaces
@interface ATCOTPBadgeView ()

// Drawing
- ( void ) recalculateAndRerenderOTP_;

// Notification Selectors
- ( void ) shouldUpdateOTP_: ( NSNotification* )_Notif;

@end // Private Interfaces

// ATCOTPBadgeView class
@implementation ATCOTPBadgeView

- ( void ) awakeFromNib
    {
    self.wantsLayer = YES;
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( shouldUpdateOTP_: ) name: ATCTotpBadgeViewShouldUpdateNotif object: nil ];
    }

#pragma mark - Animation

- ( CALayer* ) makeBackingLayer
    {
    ATCOTPBadgeLayer* backingLayer = [ [ ATCOTPBadgeLayer alloc ] init ];
    backingLayer.delegate = self;

    return backingLayer;
    }

#pragma mark - Drawing

- ( BOOL ) isFlipped
    {
    return YES;
    }

#pragma mark - Dynamic Properties

@dynamic optEntry;

- ( void ) setOptEntry: ( ATCTotpEntry* )_NewEntry
    {
    if ( optEntry_ != _NewEntry )
        {
        optEntry_ = _NewEntry;
        [ self recalculateAndRerenderOTP_ ];
        }
    }

- ( ATCTotpEntry* ) optEntry
    {
    return optEntry_;
    }

#pragma mark - Private Interfaces

// Drawing
- ( void ) recalculateAndRerenderOTP_
    {
    [ ( ATCOTPBadgeLayer* )( self.layer ) setPinCode: optEntry_.pinCodeRightNow ];
    }

// Notification Selectors
- ( void ) shouldUpdateOTP_: ( NSNotification* )_Notif
    {
    [ self recalculateAndRerenderOTP_ ];
    }

@end // ATCOTPBadgeView class
