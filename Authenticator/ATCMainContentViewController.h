//
//  ATCMainContentViewController.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Cocoa;

@class ATCTotpEntry;

// ATCMainContentViewController class
@interface ATCMainContentViewController : NSViewController
    <NSTableViewDataSource, NSTableViewDelegate>
    {
@private
    NSMutableOrderedSet <ATCTotpEntry*>* optEntries_;
    }

@property ( weak ) IBOutlet NSTableView* optEntriesTableView;

@end // ATCMainContentViewController class