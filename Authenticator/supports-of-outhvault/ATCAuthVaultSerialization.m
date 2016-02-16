//
//  ATCAuthVaultSerialization.m
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultSerialization.h"

// ATCAuthVaultSerialization class
@implementation ATCAuthVaultSerialization

@end // ATCAuthVaultSerialization class

#import "ATCAuthVault.h"

// ATCAuthVault + ATCFriends
@interface ATCAuthVault ( ATCFriends )

#pragma mark - Initializations

- ( instancetype ) initWithPropertyList: ( NSDictionary* )_PlistDict keychain: ( WSCKeychain* )_BackingStore;

@end

@implementation ATCAuthVault ( ATCFriends )

#pragma mark - Initializations

- ( instancetype ) initWithPropertyList: ( NSDictionary* )_PlistDict
                               keychain: ( WSCKeychain* )_BackingStore
    {
    if ( self = [ super init ] )
        backingStore_ = _BackingStore;

    return self;
    }

@end // ATCAuthVault + ATCFriends