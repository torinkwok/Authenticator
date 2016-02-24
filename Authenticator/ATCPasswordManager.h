//
//  ATCPasswordManager.h
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// ATCPasswordManager class
@interface ATCPasswordManager : NSObject

+ ( void ) setMasterPassword: ( NSString* )_Password;
+ ( NSString* ) masterPassword;

@end // ATCPasswordManager class