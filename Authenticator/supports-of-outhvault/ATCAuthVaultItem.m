//
//  ATCAuthVaultItem.m
//  Authenticator
//
//  Created by Tong G. on 2/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultItem.h"

#import "ATCAuthVaultItem+ATCFriends_.h"

// ATCAuthVaultItem class
@implementation ATCAuthVaultItem

@end // ATCAuthVaultItem class

// ATCAuthVaultItem + ATCFriends_
@implementation ATCAuthVaultItem ( ATCFriends_ )

#pragma mark - Initializations

- ( instancetype ) initWithPassphraseItem_: ( WSCPassphraseItem* )_PassphraseItem
    {
    if ( self = [ super init ] )
        backingStore_ = _PassphraseItem;

    return self;
    }

@end // ATCAuthVaultItem + ATCFriends_