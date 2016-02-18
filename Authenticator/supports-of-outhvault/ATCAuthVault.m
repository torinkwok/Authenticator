//
//  ATCAuthVault.m
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVault.h"

#import "ATCAuthVault+ATCFriends_.h"

// Private Interfaces
@interface ATCAuthVault ()

@end // Private Interfaces

// ATCAuthVault class
@implementation ATCAuthVault

#pragma mark - Initializations

+ ( ATCAuthVault* ) emptyAuthVaultWithMasterPassphrase: ( NSString* )_MasterPassphrase
                                                 error: ( NSError** )_Error
    {
    return [ [ self alloc ] initWithMasterPassphrase: _MasterPassphrase error: _Error ];
    }

- ( ATCAuthVault* ) initWithMasterPassphrase: ( NSString* )_MasterPassphrase
                                       error: ( NSError** )_Error
    {
    NSParameterAssert( ( _MasterPassphrase.length ) >= 6 );

    if ( self = [ super init ] )
        {
        NSError* error = nil;

        self.UUID = TKNonce();

        NSURL* tmpKeychainURL = [ ATCTemporaryDirURL() URLByAppendingPathComponent: [ NSString stringWithFormat: @"%@.dat", self.UUID ] ];

        backingStore_ = [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: tmpKeychainURL passphrase: _MasterPassphrase becomesDefault: NO error: &error ];
        if ( backingStore_ )
            [ [ WSCKeychainManager defaultManager ] unlockKeychain: backingStore_ withPassphrase: _MasterPassphrase error: &error ];

        self.createdDate = [ NSDate date ];
        self.modifiedDate = [ self.createdDate copy ];
        }

    return self;
    }

#pragma mark - Meta Data

@dynamic UUID;
@dynamic createdDate;
@dynamic modifiedDate;

- ( NSString* ) UUID
    {
    return UUID_;
    }

- ( NSDate* ) createdDate
    {
    return createdDate_;
    }

- ( NSDate* ) modifiedDate
    {
    return modifiedDate_;
    }

@end // ATCAuthVault class