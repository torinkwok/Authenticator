//
//  ATCAuthVaultSerialization.h
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Foundation;

@class ATCAuthVault;

typedef NS_ENUM ( uint32_t, ATCAuthVaultVersion )
    { ATCAuthVault_v1_0 = 1
    };

// ATCAuthVaultSerialization class
@interface ATCAuthVaultSerialization : NSObject

#pragma mark - Serializing an Auth Vault

+ ( NSData* ) dataWithAuthVault: ( ATCAuthVault* )_AuthVault error: ( NSError** )_Error;

#pragma mark - Deserializing a Auth Vault

+ ( ATCAuthVault* ) authVaultWithContentsOfURL: ( NSURL* )_URL error: ( NSError** )_Error;
+ ( ATCAuthVault* ) authVaultWithData: ( NSData* )_Data error: ( NSError** )_Error;

@end // ATCAuthVaultSerialization class