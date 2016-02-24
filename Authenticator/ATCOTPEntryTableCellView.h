//
//  ATCTotpEntryTableCellView.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Cocoa;

@class ATCAuthVaultItem;
@class ATCOTPBadgeView;

// ATCTotpEntryTableCellView class
@interface ATCTotpEntryTableCellView : NSTableCellView
    {
@private
    ATCAuthVaultItem __strong* optEntry_;
    }

@property ( strong, readwrite ) ATCAuthVaultItem* optEntry;

#pragma mark - Outlets

@property ( weak ) IBOutlet NSTextField* createdDateField;
@property ( weak ) IBOutlet NSTextField* serviceNameField;
@property ( weak ) IBOutlet NSTextField* userNameField;

@property ( weak ) IBOutlet ATCOTPBadgeView* otpBadgeView;

@end // ATCTotpEntryTableCellView class