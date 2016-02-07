//
//  ATCOTPEntryTableCellView.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPEntryTableCellView.h"
#import "ATCOTPBadgeView.h"

// ATCOTPEntryTableCellView class
@implementation ATCOTPEntryTableCellView

- ( void ) awakeFromNib
    {
    [ self configureForAutoLayout ];
    }

#pragma mark - Dynamic Properties

@dynamic optEntry;

- ( void ) setOptEntry: ( ATCOTPEntry* )_NewEntry
    {
    if ( optEntry_ != _NewEntry )
        {
        optEntry_ = _NewEntry;
        self.otpBadgeView.optEntry = optEntry_;
        }
    }

- ( ATCOTPEntry* ) optEntry
    {
    return optEntry_;
    }

@end // ATCOTPEntryTableCellView class