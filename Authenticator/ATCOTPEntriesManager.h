//
//  ATCOTPEntriesManager.h
//  Authenticator
//
//  Created by Tong G. on 2/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class ATCTotpEntry;

// ATCOTPEntriesManager class
@interface ATCOTPEntriesManager : NSObject
    {
@private
    NSMutableArray <ATCTotpEntry*> __strong* totpEntries_;
    }

#pragma mark - Initializations

+ ( instancetype ) defaultManager;

#pragma mark - Accessing Secret Keys

- ( BOOL ) presistentEntry: ( ATCTotpEntry* )_Entry;

@end // ATCOTPEntriesManager class