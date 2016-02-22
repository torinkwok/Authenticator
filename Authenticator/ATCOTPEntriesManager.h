//
//  ATCOTPEntriesManager.h
//  Authenticator
//
//  Created by Tong G. on 2/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class ATCTotpEntry;

// ATCOTPEntriesManager class
@interface ATCOTPEntriesManager : NSObject <WSCKeychainManagerDelegate>
    {
@private
    NSMutableArray <ATCTotpEntry*> __strong* totpEntries_;

    WSCKeychain __strong* defaultVault_;
    }

#pragma mark - Initializations

+ ( instancetype ) defaultManager;

@end // ATCOTPEntriesManager class