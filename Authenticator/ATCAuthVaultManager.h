//
//  ATCAuthVaultManager.h
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class ATCAuthVault;

// ATCAuthVaultManager class
@interface ATCAuthVaultManager : NSObject

+ ( NSURL* ) defaultAuthVaultLocation;
+ ( BOOL ) defaultAuthVaultExists;
+ ( ATCAuthVault* ) generateDefaultAuthVaultWithMasterPassword: ( NSString* )_Password error: ( NSError** )_Error;
+ ( BOOL ) writeAuthVaultBackIntoDefaultAuthVault: ( ATCAuthVault* )_ModifiedAuthVault error: ( NSError** )_Error;

+ ( ATCAuthVault* ) defaultAuthVaultInDefaultLocationWithPassword: ( NSString* )_Password error: ( NSError** )_Error;

+ ( NSString* ) tmpMasterPassword;

@end // ATCAuthVaultManager class