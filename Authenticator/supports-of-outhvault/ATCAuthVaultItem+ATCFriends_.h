//
//  ATCAuthVaultItem+ATCFriends_.h
//  Authenticator
//
//  Created by Tong G. on 2/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultItem.h"

// ATCAuthVaultItem + ATCFriends_
@interface ATCAuthVaultItem ( ATCFriends_ )

#pragma mark - Initializations

- ( instancetype ) initWithPassphraseItem_: ( WSCKeychainItem* )_KeychainItem;

@end // ATCAuthVaultItem + ATCFriends_