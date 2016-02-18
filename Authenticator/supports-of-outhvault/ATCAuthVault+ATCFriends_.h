//
//  ATCAuthVault+ATCFriends_.h
//  Authenticator
//
//  Created by Tong G. on 2/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVault.h"

// ATCAuthVault + ATCFriends_
@interface ATCAuthVault ( ATCFriends_ )

@property ( strong, readwrite ) NSString* UUID;

@property ( strong, readwrite ) NSDate* createdDate;
@property ( strong, readwrite ) NSDate* modifiedDate;

@end // ATCAuthVault + ATCFriends_