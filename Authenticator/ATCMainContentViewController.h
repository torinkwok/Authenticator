//
//  ATCMainContentViewController.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Cocoa;

@class ATCTotpEntry;
@class ATCQRCodeScannerWindowController;

// ATCMainContentViewController class
@interface ATCMainContentViewController : NSViewController
    <NSTableViewDataSource, NSTableViewDelegate>
    {
@private
    NSMutableOrderedSet <ATCTotpEntry*>* otpEntries_;

    ATCQRCodeScannerWindowController __strong* QRCodeScannerWindow_;
    }

@property ( weak ) IBOutlet NSTableView* optEntriesTableView;

#pragma mark - IBActions

- ( IBAction ) scanQRCodeOnScreenAction_: ( id )_Sender;

@end // ATCMainContentViewController class