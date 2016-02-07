//
//  ATCMainContentViewController.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Cocoa;

@class ATCOTPEntry;

// ATCMainContentViewController class
@interface ATCMainContentViewController : NSViewController
    <NSTableViewDataSource, NSTableViewDelegate>
    {
@private
    NSMutableOrderedSet <ATCOTPEntry*>* optEntries_;
    }

@end // ATCMainContentViewController class