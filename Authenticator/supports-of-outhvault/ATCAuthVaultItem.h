//
//  ATCAuthVaultItem.h
//  Authenticator
//
//  Created by Tong G. on 2/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Foundation;

// ATCAuthVaultItem class
@interface ATCAuthVaultItem : NSObject
    {
@protected
    WSCPassphraseItem __strong* backingStore_;
    }

@end // ATCAuthVaultItem class