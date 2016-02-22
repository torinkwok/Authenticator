//
//  ATCOTPVaultsManager.h
//  Authenticator
//
//  Created by Tong G. on 2/15/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "WSCKeychainManager.h"

// ATCOTPVaultsManager class
@interface ATCOTPVaultsManager : WSCKeychainManager

+ ( instancetype ) defaultManager;

@end // ATCOTPVaultsManager class