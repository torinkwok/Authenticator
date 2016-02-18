//
//  ATCAuthVault.h
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Foundation;

// ATCAuthVault class
@interface ATCAuthVault : NSObject
    {
@protected
    WSCKeychain __strong* backingStore_;

    NSString __strong* UUID_;
    NSDate __strong* createdDate_;
    NSDate __strong* modifiedDate_;
    }

#pragma mark - Initializations

+ ( ATCAuthVault* ) emptyAuthVaultWithMasterPassphrase: ( NSString* )_MasterPassphrase error: ( NSError** )_Error;

#pragma mark - Meta Data

@property ( strong, readonly ) NSString* UUID;

@property ( strong, readonly ) NSDate* createdDate;
@property ( strong, readonly ) NSDate* modifiedDate;

@end // ATCAuthVault class