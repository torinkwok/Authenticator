//
//  ATCAuthVault+ATCFriends_.m
//  Authenticator
//
//  Created by Tong G. on 2/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVault+ATCFriends_.h"

// ATCAuthVault + ATCFriends_
@implementation ATCAuthVault ( ATCFriends_ )

#pragma mark - Meta Data

@dynamic UUID;
@dynamic createdDate;
@dynamic modifiedDate;

- ( void ) setUUID: ( NSString* )_NewUUID
    {
    UUID_ = _NewUUID;
    }

- ( void ) setCreatedDate: ( NSDate* )_Date
    {
    createdDate_ = _Date;
    }

- ( void ) setModifiedDate: ( NSDate* )_Date
    {
    modifiedDate_ = _Date;
    }

#pragma mark - Real Private Interfaces

@dynamic backingStoreData_;

- ( NSData* ) backingStoreData_
    {
    NSData* data = [ NSData dataWithContentsOfURL: backingStore_.URL ];
    return data;
    }

@end // ATCAuthVault + ATCFriends_