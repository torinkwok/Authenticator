//
//  ATCAuthVault.h
//  Authenticator
//
//  Created by Tong G. on 2/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class ATCAuthVaultItem;

@protocol ATCAuthVaultDelegate;

// ATCAuthVault class
@interface ATCAuthVault : NSObject
    {
@private
    NSData __strong* backingStore_;
    }

@property ( weak, readwrite ) id <ATCAuthVaultDelegate> delegate;

#pragma mark - Creating Auth Vault

- ( instancetype ) initWithMasterPassword: ( NSString* )_Password error: ( NSError** )_Error;
- ( instancetype ) initWithData: ( NSData* )_Data masterPassword: ( NSString* )_Password error: ( NSError** )_Error;

#pragma mark - Persistent

- ( BOOL ) writeToFile: ( NSString* )_Path atomically: ( BOOL )_Atomically;
- ( BOOL ) writeToFile: ( NSString* )_Path options: ( NSDataWritingOptions )_Mask error: ( NSError** )_Error;

- ( BOOL ) writeToURL: ( NSURL* )_URL atomically: ( BOOL )_Atomically;
- ( BOOL ) writeToURL: ( NSURL* )_URL options: ( NSDataWritingOptions )_Mask error: ( NSError** )_Error;

#pragma mark - Meta Data

@property ( strong, readonly ) NSString* UUID;
@property ( strong, readonly ) NSDate* createdDate;
@property ( strong, readonly ) NSDate* modifiedDate;

@property ( assign, readonly ) NSUInteger numberOfOtpEntries;

#pragma mark - Managing Otp Entries

- ( BOOL ) addAuthVaultItem: ( ATCAuthVaultItem* )_NewItem withMasterPassword: ( NSString* )_Password error: ( NSError** )_Error;
- ( BOOL ) deleteAuthVaultItem: ( ATCAuthVaultItem* )_NewItem withMasterPassword: ( NSString* )_Password error: ( NSError** )_Error;

- ( NSArray <ATCAuthVaultItem*>* ) authVaultItems;
- ( BOOL ) setAuthVaultItems: ( NSArray <ATCAuthVaultItem*>* )_Items error: ( NSError** )_Error;

@end // ATCAuthVault class

// ATCAuthVaultDelegate protocol
@protocol ATCAuthVaultDelegate <NSObject>

@required
- ( NSString* ) authVaultNeedsPasswordToUnlock: ( ATCAuthVault* )_AuthVault;

@end // ATCAuthVaultDelegate protocol