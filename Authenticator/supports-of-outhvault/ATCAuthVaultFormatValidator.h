//
//  ATCAuthVaultFormatValidator.h
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Foundation;

// ATCAuthVaultFormatValidator class
@interface ATCAuthVaultFormatValidator : NSObject

+ ( BOOL ) isContentsOfURLValidAuthVault: ( NSURL* )_URL;

@end // ATCAuthVaultFormatValidator class