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

// ATCOTPBadgeView class
@implementation ATCOTPBadgeView

- ( void ) awakeFromNib
    {
    self.wantsLayer = YES;
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( shouldRedraw_: ) name: ATCTotpBadgeViewShouldUpdateNotif object: nil ];
    }

- ( void ) shouldRedraw_: ( NSNotification* )_Notif
    {
    [ ( ATCOTPBadgeLayer* )( self.layer ) setPinCode: optEntry_.pinCodeRightNow ];
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
//        NSLog( @"%@", optEntry_.pinCodeRightNow );
        [ ( ATCOTPBadgeLayer* )( self.layer ) setPinCode: optEntry_.pinCodeRightNow ];
        }
    }

- ( ATCTotpEntry* ) optEntry
    {
    return optEntry_;
    }

@end // ATCOTPBadgeView class
