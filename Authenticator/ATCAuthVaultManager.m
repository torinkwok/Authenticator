//
//  ATCAuthVaultManager.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultManager.h"

// ATCAuthVaultManager class
@implementation ATCAuthVaultManager

NSString static* sMasterPassword;
+ ( void ) setMasterPassword: ( NSString* )_Password
    {
    if ( sMasterPassword != _Password )
        {
        sMasterPassword = _Password;

        [ [ NSNotificationCenter defaultCenter ]
            postNotificationName: ATCMasterPasswordDidChangeNotif object: self ];
        }
    }

+ ( NSString* ) masterPassword
    {
    return sMasterPassword;
    }

@end // ATCAuthVaultManager class