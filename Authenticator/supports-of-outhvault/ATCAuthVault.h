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
    }

@end // ATCAuthVault class