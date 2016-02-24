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

+ ( BOOL ) defaultAuthVaultExists;
+ ( ATCAuthVault* ) generateDefaultAuthVaultWithMasterPassword: ( NSString* )_Password error: ( NSError** )_Error;

+ ( void ) setMasterPassword: ( NSString* )_Password;
+ ( NSString* ) masterPassword;

@end // ATCAuthVaultManager class