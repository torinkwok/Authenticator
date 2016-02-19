//
//  ATCAuthVaultItem.m
//  Authenticator
//
//  Created by Tong G. on 2/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultItem.h"

#import "ATCAuthVaultItem+ATCFriends_.h"
#import "NSData+AuthVaultExtensions_.h"

NSString* const kUUIDKey = @"uuid";
NSString* const kAccountNameKey = @"account-name";
NSString* const kCreatedDateKey = @"created-date";
NSString* const kDigitsKey = @"digits";
NSString* const kTimeStepKey = @"time-step";
NSString* const kAlgorithmKey = @"algorithm";
NSString* const kIssuerKey = @"issuer";
NSString* const kSecretKeyKey = @"secret-key";
NSString* const kCheckSumKey = @"check-sum";

inline static NSString* kCheckSumOfAuthVaultItemBackingStore_( NSDictionary* _BackingStore )
    {
    NSString* template = @"%@=%@";
    NSMutableArray* checkFields = [ NSMutableArray arrayWithObjects:
          [ NSString stringWithFormat: template, kUUIDKey, _BackingStore[ kUUIDKey ] ?: [ NSNull null ] ]
        , [ NSString stringWithFormat: template, kAccountNameKey, _BackingStore[ kAccountNameKey ] ?: [ NSNull null ] ]
        , [ NSString stringWithFormat: template, kCreatedDateKey, _BackingStore[ kCreatedDateKey ] ?: [ NSNull null ] ]
        , [ NSString stringWithFormat: template, kDigitsKey, _BackingStore[ kDigitsKey ] ?: [ NSNull null ] ]
        , [ NSString stringWithFormat: template, kTimeStepKey, _BackingStore[ kTimeStepKey ] ?: [ NSNull null ] ]
        , [ NSString stringWithFormat: template, kAlgorithmKey, _BackingStore[ kAlgorithmKey ] ?: [ NSNull null ] ]
        , [ NSString stringWithFormat: template, kIssuerKey, _BackingStore[ kIssuerKey ] ?: [ NSNull null ] ]
        , [ NSString stringWithFormat: template, kSecretKeyKey, _BackingStore[ kSecretKeyKey ] ?: [ NSNull null ] ]
        , nil
        ];

    NSData* base64edCheckFields = [ [ checkFields componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ].base64EncodedDataForAuthVault;
    return base64edCheckFields.checkSumForAuthVault;
    }

// ATCAuthVaultItem class
@implementation ATCAuthVaultItem

#pragma mark - Properties

@dynamic UUID;
@dynamic accountName;
@dynamic createdDate;
@dynamic digits;
@dynamic timeStep;
@dynamic algorithm;
@dynamic issuer;
@dynamic secretKey;

@dynamic checkSum;

- ( NSString* ) UUID
    {
    return backingStore_[ kUUIDKey ];
    }

- ( NSString* ) accountName
    {
    return backingStore_[ kAccountNameKey ];
    }

- ( NSDate* ) createdDate
    {
    return [ NSDate dateWithTimeIntervalSince1970: [ backingStore_[ kCreatedDateKey ] doubleValue ] ];
    }

- ( NSUInteger ) digits
    {
    return [ backingStore_[ kDigitsKey ] unsignedLongValue ];
    }

- ( NSUInteger ) timeStep
    {
    return [ backingStore_[ kTimeStepKey ] unsignedLongValue ];
    }

- ( CCHmacAlgorithm ) algorithm
    {
    NSString* algString = backingStore_[ kAlgorithmKey ];
    CCHmacAlgorithm alg = -1;

    if ( [ algString isEqualToString: @"sha1" ] )
        alg = kCCHmacAlgSHA1;
    else if ( [ algString isEqualToString: @"md5" ] )
        alg = kCCHmacAlgMD5;
    else if ( [ algString isEqualToString: @"sha256" ] )
        alg = kCCHmacAlgSHA256;
    else if ( [ algString isEqualToString: @"sha384" ] )
        alg = kCCHmacAlgSHA384;
    else if ( [ algString isEqualToString: @"sha512" ] )
        alg = kCCHmacAlgSHA512;
    else if ( [ algString isEqualToString: @"sha224" ] )
        alg = kCCHmacAlgSHA224;

    return alg;
    }

- ( NSString* ) issuer
    {
    return backingStore_[ kIssuerKey ];
    }

- ( NSString* ) secretKey
    {
    return backingStore_[ kSecretKeyKey ];
    }

- ( NSString* ) checkSum
    {
    return backingStore_[ kCheckSumKey ];
    }

@end // ATCAuthVaultItem class

// ATCAuthVaultItem + ATCFriends_
@implementation ATCAuthVaultItem ( ATCFriends_ )

#pragma mark - Initializations

- ( instancetype ) initWithPlistData: ( NSData* )_PlistData
                               error: ( NSError** )_Error
    {
    if ( self = [ super init ] )
        {
        NSError* error = nil;

        NSDictionary* tmpPlist = [ NSPropertyListSerialization
            propertyListWithData: _PlistData options: 0 format: nil error: &error ];

        if ( tmpPlist )
            {
            NSString* lhsCheckSum = kCheckSumOfAuthVaultItemBackingStore_( tmpPlist );
            NSString* rhsCheckSum = tmpPlist[ kCheckSumKey ];

            if ( [ lhsCheckSum isEqualToString: rhsCheckSum ] )
                backingStore_ = tmpPlist;
            else
                ; // TODO: To construct an error object that contains the information about this failure
            }

        if ( error )
            if ( _Error )
                *_Error = error;
        }

    return self;
    }

@end // ATCAuthVaultItem + ATCFriends_