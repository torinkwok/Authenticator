//
//  ATCSecretKeyManager.m
//  Authenticator
//
//  Created by Tong G. on 2/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCSecretKeyManager.h"

// ATCSecretKeyManager class
@implementation ATCSecretKeyManager

#pragma mark - Initializations

+ ( instancetype ) sharedManager
    {
    return [ [ self alloc ] init ];
    }

ATCSecretKeyManager static* sSecretManager;
- ( instancetype ) init
    {
    if ( !sSecretManager )
        {
        if ( self = [ super init ] )
            {
            secretKeys_ = [ NSMutableOrderedSet orderedSet ];

            sSecretManager = self;
            }
        }

    return sSecretManager;
    }

@end // ATCSecretKeyManager class