//
//  ATCAuthVaultManager.h
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class ATCAuthVault;
@class ATCAuthVaultItem;

// ATCAuthVaultManager class
@interface ATCAuthVaultManager : NSObject

+ ( NSURL* ) defaultAuthVaultLocation;
+ ( BOOL ) defaultAuthVaultExists;
+ ( BOOL ) generateDefaultAuthVaultWithMasterPassword: ( NSString* )_Password error: ( NSError** )_Error;
+ ( BOOL ) writeAuthVaultBackIntoDefaultAuthVault: ( ATCAuthVault* )_ModifiedAuthVault error: ( NSError** )_Error;

+ ( NSArray <ATCAuthVaultItem*>* ) allItemsOfDefaultAuthVaultWithError: ( NSError** )_Error;
+ ( BOOL ) addItemIntoDefaultAuthVault: ( ATCAuthVaultItem* )_Item error: ( NSError** )_Error;

+ ( BOOL ) defaultAuthVaultInDefaultLocationWithPassword: ( NSString* )_Password error: ( NSError** )_Error;

+ ( NSString* ) tmpMasterPassword;

@end // ATCAuthVaultManager class