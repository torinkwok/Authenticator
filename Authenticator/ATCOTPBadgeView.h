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
    }

@property ( strong, readwrite ) ATCTotpEntry* optEntry;
@property ( strong, readwrite ) NSString* pinCode;
@property ( assign, readwrite ) BOOL isInWarning;

@end // ATCOTPBadgeView class
