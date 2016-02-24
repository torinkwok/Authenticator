//
//  ATCPasswordManager.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCPasswordManager.h"

// ATCPasswordManager class
@implementation ATCPasswordManager

NSString static* sMasterPassword;
+ ( void ) setMasterPassword: ( NSString* )_Password
    {
    NSParameterAssert( ( _Password ) );
    sMasterPassword = _Password;
    }

+ ( NSString* ) masterPassword
    {
    return sMasterPassword;
    }

@end // ATCPasswordManager class