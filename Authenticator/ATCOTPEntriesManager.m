//
//  ATCOTPEntriesManager.m
//  Authenticator
//
//  Created by Tong G. on 2/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPEntriesManager.h"

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
            NSLog( @"%@", ATCVaultsDirURL() );

            totpEntries_ = [ NSMutableArray array ];

            NSError* error = nil;

            WSCKeychain* defaultKeychain = [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ];
            if ( defaultKeychain )
                {
                NSSet* matchedItems = [ defaultKeychain
                    findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeServiceName : @"com.google.otp.authentication" }
                                                       itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                           error: &error ];
                [ matchedItems enumerateObjectsUsingBlock:
                    ^( WSCPassphraseItem* _Item, BOOL* _Nonnull _Stop )
                        {
                        // TODO: To apply a regular expression to determine whether the _Item.passphrase is valid

                        if ( !_Item.userDefinedData )
                            {
                            NSData* data = [ NSJSONSerialization dataWithJSONObject: @{ @"os" : @"OS X"
                                                                                      , @"version" : @"10.11"
                                                                                      }
                                                                            options: NSJSONWritingPrettyPrinted error: nil ];
                            [ _Item setUserDefinedData: data ];
                            }
                        else
                            {
                            NSLog( @"%@", [ NSJSONSerialization JSONObjectWithData: _Item.userDefinedData options: 0 error: nil ] );
                            }
                        } ];
                }

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