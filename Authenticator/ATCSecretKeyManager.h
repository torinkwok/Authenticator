//
//  ATCSecretKeyManager.h
//  Authenticator
//
//  Created by Tong G. on 2/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// ATCSecretKeyManager class
@interface ATCSecretKeyManager : NSObject
    {
@private
    NSMutableOrderedSet <NSString*> __strong* secretKeys_;
    }

#pragma mark - Initializations

+ ( instancetype ) sharedManager;

@end // ATCSecretKeyManager class