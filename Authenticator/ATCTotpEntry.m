//
//  ATCTotpEntry.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCTotpEntry.h"

// Private Interfaces
@interface ATCTotpEntry ()

@property ( strong, readwrite ) NSDate* createdDate;
@property ( strong, readwrite ) NSString* serviceName;
@property ( strong, readwrite ) NSString* userName;

@property ( strong, readwrite ) NSString* secretString;

@end // Private Interfaces

// ATCTotpEntry class
@implementation ATCTotpEntry

#pragma mark - Initializations

- ( instancetype ) initWithServiceName: ( NSString* )_ServiceName
                              userName: ( NSString* )_UserName
                                secret: ( NSString* )_Secret
    {
    if ( self = [ super init ] )
        {
        self.createdDate = [ NSDate date ];
        self.serviceName = _ServiceName;
        self.userName = _UserName;
        self.secretString = _Secret;

        agTotp_ = [ [ AGTotp alloc ] initWithDigits: 6 andSecret: [ AGBase32 base32Decode: self.secretString ] ];
        }

    return self;
    }

#pragma mark - Dynamic Properties

- ( NSString* ) pinCodeRightNow
    {
    NSString* pin = [ agTotp_ now ];
    return pin;
    }

@end // ATCTotpEntry class
