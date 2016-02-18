//
//  ATCAuthVault.m
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVault.h"

// ATCAuthVault class
@implementation ATCAuthVault

#pragma mark - Initializations

- ( instancetype ) init
    {
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
    }

#pragma mark - Meta Data

@dynamic createdDate;
@dynamic modifiedDate;

- ( NSDate* ) createdDate
    {
    return createdDate_;
    }

- ( NSDate* ) modifiedDate
    {
    return modifiedDate_;
    }

@end // ATCAuthVault class