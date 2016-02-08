//
//  ATCOTPBadgeView.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Cocoa;

@class ATCTotpEntry;

// ATCOTPBadgeView class
@interface ATCOTPBadgeView : NSControl
    {
@private
    ATCTotpEntry __strong* optEntry_;
    NSDictionary __strong* optDrawingAttrs_;
    }

@property ( strong, readwrite ) ATCTotpEntry* optEntry;

@end // ATCOTPBadgeView class
