//
//  ATCOTPEntry.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPEntry.h"

// Private Interfaces
@interface ATCOTPEntry ()

@property ( strong, readwrite ) NSDate* createdDate;
@property ( strong, readwrite ) NSString* serviceName;
@property ( strong, readwrite ) NSString* userName;

@property ( strong, readwrite ) NSString* secretString;

@end // Private Interfaces

// ATCOTPEntry class
@implementation ATCOTPEntry

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
        }

    return self;
    }

@end // ATCOTPEntry class
