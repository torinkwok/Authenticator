//
//  ATCOTPEntryTableCellView.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Cocoa;

@class ATCOTPEntry;
@class ATCOTPBadgeView;

// ATCOTPEntryTableCellView class
@interface ATCOTPEntryTableCellView : NSTableCellView
    {
@private
    ATCOTPEntry __strong* optEntry_;
    }

@property ( strong, readwrite ) ATCOTPEntry* optEntry;

#pragma mark - Outlets

@property ( weak ) IBOutlet NSTextField* createdDateField;
@property ( weak ) IBOutlet NSTextField* serviceNameField;
@property ( weak ) IBOutlet NSTextField* userNameField;

@property ( weak ) IBOutlet ATCOTPBadgeView* otpBadgeView;

@end // ATCOTPEntryTableCellView class