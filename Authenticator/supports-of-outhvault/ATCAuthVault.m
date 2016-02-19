//
//  ATCAuthVault.m
//  Authenticator
//
//  Created by Tong G. on 2/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVault.h"

NSString* const kUUIDKey = @"uuid";
NSString* const kCreatedDateKey = @"created-date";
NSString* const kModifiedDateKey = @"modified-date";
NSString* const kOtpEntriesKey = @"otp-entries";

// ATCAuthVault class
@implementation ATCAuthVault

#pragma mark - Creating Auth Vault

- ( instancetype ) initWithData: ( NSData* )_Data
                          error: ( NSError** )_Error
    {
    if ( self = [ super init ] )
        {
        NSError* error = nil;

        
        }

    return self;
    }

@end // ATCAuthVault class