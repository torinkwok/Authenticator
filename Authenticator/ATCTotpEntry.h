//
//  ATCTotpEntry.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "AeroGearOTP.h"

// ATCTotpEntry class
@interface ATCTotpEntry : NSObject
    {
@protected
    AGTotp __strong* agTotp_;
    }

@property ( strong, readonly ) NSDate* createdDate;
@property ( strong, readonly ) NSString* serviceName;
@property ( strong, readonly ) NSString* userName;

@property ( strong, readonly ) NSString* secretString;
@property ( strong, readonly ) NSString* pinCodeRightNow;

#pragma mark - Initializations

- ( instancetype ) initWithServiceName: ( NSString* )_ServiceName
                              userName: ( NSString* )_UserName
                                secret: ( NSString* )_Secret;

@end // ATCTotpEntry class
