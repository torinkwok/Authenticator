//
//  ATCOTPEntriesManager.m
//  Authenticator
//
//  Created by Tong G. on 2/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPEntriesManager.h"
#import "ATCOTPVaultsManager.h"
#import "ATCOTPVault.h"
#import "ATCOTPVaultItem.h"

// Private Interfaces
@interface ATCOTPEntriesManager ()

@property ( weak, readonly ) WSCKeychainManager* defaultVaultsManager;
@property ( strong, readonly ) WSCKeychain* defaultVault;

@end // Private Interfaces

// ATCOTPEntriesManager class
@implementation ATCOTPEntriesManager

#pragma mark - Initializations

+ ( instancetype ) defaultManager
    {
    return [ [ self alloc ] init ];
    }

ATCOTPEntriesManager static* sSecretManager;
- ( instancetype ) init
    {
    if ( !sSecretManager )
        {
        if ( self = [ super init ] )
            {
            NSError* error = nil;

            totpEntries_ = [ NSMutableArray array ];

            if ( self.defaultVault )
                {
                NSSet* matchedItems = [ self.defaultVault
                    findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeServiceName : [ [ NSBundle mainBundle ] bundleIdentifier ] }
                                                       itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                           error: &error ];
                [ matchedItems enumerateObjectsUsingBlock:
                    ^( WSCPassphraseItem* _Item, BOOL* _Nonnull _Stop )
                        {

                        } ];
                }

            if ( error )
                NSLog( @"Error occured while constructing the OTP entries manager: %@", error );

            sSecretManager = self;
            }
        }

    return sSecretManager;
    }

#pragma mark - Dynamic Properties

@dynamic defaultVaultsManager;
@dynamic defaultVault;

- ( ATCOTPVaultsManager* ) defaultVaultsManager
    {
    ATCOTPVaultsManager* defaultManager = [ ATCOTPVaultsManager defaultManager ];
    if ( self != defaultManager.delegate )
        defaultManager.delegate = self;

    return defaultManager;
    }

- ( WSCKeychain* ) defaultVault
    {
    if ( defaultVault_ )
        return defaultVault_;

    NSError* error = nil;

    NSURL* defaultVaultURL = [ ATCDefaultVaultsDirURL() URLByAppendingPathComponent: @"default.optvault" ];
    BOOL isDir = NO;

    if ( [ [ NSFileManager defaultManager ] fileExistsAtPath: defaultVaultURL.path
                                                 isDirectory: &isDir ]
            && !isDir )
        defaultVault_ = [ self.defaultVaultsManager openExistingKeychainAtURL: defaultVaultURL error: &error ];

    if ( !defaultVault_ )
        {
        #if __debug_Vault__
        NSLog( @"Failed to open exsisting default.optvault attempting to recreate one…: %@", error );
        #endif

        if ( [ defaultVaultURL checkResourceIsReachableAndReturnError: &error ] )
            {
            if ( ![ [ NSFileManager defaultManager ] removeItemAtURL: defaultVaultURL error: &error ] )
                {
                #if __debug_Vault__
                NSLog( @"Failed to remove the damaged vault: %@", error );
                #elif ;
                #endif

                return defaultVault_;
                }
            }

        if ( !( defaultVault_ = [ self.defaultVaultsManager createKeychainWithURL: defaultVaultURL
                                                                       passphrase: @"fuckyou"
                                                                   becomesDefault: NO
                                                                            error: &error ] ) )
            {
            #if __debug_Vault__
            NSLog( @"Failed to create a new default.optvault: %@", error );
            #endif
            }
        }

    if ( defaultVault_ )
        [ self.defaultVaultsManager unlockKeychain: defaultVault_ withPassphrase: @"fuckyou" error: nil ];

    return defaultVault_;
    }

@end // ATCOTPEntriesManager class