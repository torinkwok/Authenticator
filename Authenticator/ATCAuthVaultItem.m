//
//  ATCAuthVaultItem.m
//  Authenticator
//
//  Created by Tong G. on 2/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultItem.h"
#import "ATCAuthVaultConstants.h"

#import "ATCAuthVaultItem+ATCFriends_.h"
#import "ATCExtensions_.h"

#define __ATC_CHECK_FIELD__( _Key ) \
    [ NSString stringWithFormat: template, _Key, _BackingStore[ _Key ] ?: [ NSNull null ] ]

inline static NSString* kCheckSumOfAuthVaultItemBackingStore_( NSDictionary* _BackingStore )
    {
    NSString* template = @"%@=%@";
    NSMutableArray* checkFields = [ NSMutableArray arrayWithObjects:
          __ATC_CHECK_FIELD__( kUUIDKey )
        , __ATC_CHECK_FIELD__( kAccountNameKey )
        , __ATC_CHECK_FIELD__( kCreatedDateKey )
        , __ATC_CHECK_FIELD__( kDigitsKey )
        , __ATC_CHECK_FIELD__( kTimeStepKey )
        , __ATC_CHECK_FIELD__( kAlgorithmKey )
        , __ATC_CHECK_FIELD__( kIssuerKey )
        , __ATC_CHECK_FIELD__( kSecretKeyKey )
        , nil
        ];

    NSData* base64edCheckFields = [ [ checkFields componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ].base64EncodedDataForAuthVault;
    return base64edCheckFields.HMAC_SHA512DigestStringForAuthVault;
    }

// ATCAuthVaultItem class
@implementation ATCAuthVaultItem

#pragma mark - Properties

@dynamic accountName;
@dynamic digits;
@dynamic timeStep;
@dynamic algorithm;
@dynamic issuer;

- ( void ) setAccountName: ( NSString* )_New
    {
    backingStore_[ kAccountNameKey ] = _New;
    }

- ( NSString* ) accountName
    {
    return backingStore_[ kAccountNameKey ];
    }

- ( void ) setDigits: ( NSUInteger )_New
    {
    backingStore_[ kDigitsKey ] = [ NSNumber numberWithLong: _New ];
    }

- ( NSUInteger ) digits
    {
    return [ backingStore_[ kDigitsKey ] unsignedLongValue ];
    }

- ( void ) setTimeStep: ( NSUInteger )_New
    {
    backingStore_[ kTimeStepKey ] = [ NSNumber numberWithLong: _New ];
    }

- ( NSUInteger ) timeStep
    {
    return [ backingStore_[ kTimeStepKey ] unsignedLongValue ];
    }

- ( void ) setAlgorithm: ( CCHmacAlgorithm )_New
    {
    NSString* alg = nil;

    switch ( _New )
        {
        case kCCHmacAlgSHA1:    alg = @"sha1";      break;
        case kCCHmacAlgMD5:     alg = @"md5";       break;
        case kCCHmacAlgSHA256:  alg = @"sha256";    break;
        case kCCHmacAlgSHA384:  alg = @"sha384";    break;
        case kCCHmacAlgSHA512:  alg = @"sha512";    break;
        case kCCHmacAlgSHA224:  alg = @"sha224";    break;

        default:
            alg = @"unknown";
        }

    backingStore_[ kAlgorithmKey ] = alg;
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

- ( void ) setIssuer: ( NSString* )_New
    {
    backingStore_[ kIssuerKey ] = _New;
    }

- ( NSString* ) issuer
    {
    return backingStore_[ kIssuerKey ];
    }

#pragma mark - Meta Data

@dynamic UUID;
@dynamic createdDate;
@dynamic secretKey;

@dynamic checkSum;

- ( NSString* ) UUID
    {
    return backingStore_[ kUUIDKey ];
    }

- ( NSDate* ) createdDate
    {
    return [ NSDate dateWithTimeIntervalSince1970: [ backingStore_[ kCreatedDateKey ] doubleValue ] ];
    }

- ( NSString* ) secretKey
    {
    return backingStore_[ kSecretKeyKey ];
    }

- ( NSString* ) checkSum
    {
    return backingStore_[ kCheckSumKey ];
    }

#pragma mark - Initializations

- ( instancetype ) initWithIssuer: ( NSString* )_IssuerName
                      accountName: ( NSString* )_AccountName
                        secretKey: ( NSString* )_SecretKey
    {
    if ( self = [ super init ] )
        {
        backingStore_ = [ [ NSMutableDictionary alloc ] initWithObjectsAndKeys:
              _AccountName, kAccountNameKey
            , _IssuerName, kIssuerKey
            , _SecretKey, kSecretKeyKey
            , @( 6 ), kDigitsKey
            , @( 30 ), kTimeStepKey
            , @"sha1", kAlgorithmKey
            , TKNonce(), kUUIDKey
            , @( [ NSDate date ].timeIntervalSince1970 ), kCreatedDateKey
            , nil ];

        NSString* checksum = kCheckSumOfAuthVaultItemBackingStore_( backingStore_ );
        backingStore_[ kCheckSumKey ] = checksum;
        }

    return self;
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
                backingStore_ = [ tmpPlist mutableCopy ];
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