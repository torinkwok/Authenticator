//
//  ATCTotpEntryTableCellView.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPEntryTableCellView.h"
#import "ATCOTPBadgeView.h"

// ATCTotpEntryTableCellView class
@implementation ATCTotpEntryTableCellView

- ( void ) awakeFromNib
    {
    [ self configureForAutoLayout ];
    }

#pragma mark - Dynamic Properties

@dynamic optEntry;

- ( void ) setOptEntry: ( ATCAuthVaultItem* )_NewEntry
    {
    if ( optEntry_ != _NewEntry )
        {
        optEntry_ = _NewEntry;
        self.otpBadgeView.optEntry = optEntry_;
        }
    }

- ( ATCAuthVaultItem* ) optEntry
    {
    return optEntry_;
    }

@end // ATCTotpEntryTableCellView class