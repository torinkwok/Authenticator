//
//  ATCOTPBadgeView.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Cocoa;

@class ATCOTPEntry;

// ATCOTPBadgeView class
@interface ATCOTPBadgeView : NSControl
    {
@private
    ATCOTPEntry __strong* optEntry_;
    NSDictionary __strong* optDrawingAttrs_;

    AGOtp __strong* agOtp_;
    }

@property ( strong, readwrite ) ATCOTPEntry* optEntry;

@end // ATCOTPBadgeView class
