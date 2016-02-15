//
//  ATCOTPEntriesManager.m
//  Authenticator
//
//  Created by Tong G. on 2/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPEntriesManager.h"
#import "ATCOTPVault.h"

// Private Interfaces
@interface ATCOTPEntriesManager ()

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

            WSCKeychain* defaultVault = [ [ WSCKeychainManager defaultManager ]
                createKeychainWithURL: [ ATCDefaultVaultsDirURL() URLByAppendingPathComponent: @"default.otpvault" ]
                           passphrase: @"fuckyou"
                       becomesDefault: NO error: &error ];

            if ( defaultVault )
                {
                NSSet* matchedItems = [ defaultVault
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

#pragma mark - Accessing Secret Keys

- ( BOOL ) presistentEntry: ( ATCTotpEntry* )_Entry
    {
    BOOL isSuccess = NO;

    NSArray* urlPathComponents = @[ [ @"Google:contact@tong-kuo.me" stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet URLPathAllowedCharacterSet ] ]
                                  , [ @"secret=jwslphwytg6oxjvgyufwqciayhoapusg" stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet URLPathAllowedCharacterSet ] ]
                                  , [ @"issuer=Google" stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet URLPathAllowedCharacterSet ] ]
                                  ];
    NSString* path = [ NSString pathWithComponents: urlPathComponents ];
    NSString* escapedPath = [ path stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet URLPathAllowedCharacterSet ] ];

    return isSuccess;
    }

@end // ATCOTPEntriesManager class