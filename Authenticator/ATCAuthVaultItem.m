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

// Private Interfaces
@interface ATCAuthVaultItem ()
- ( void ) resetCheckSum_;
@end // Private Interfaces

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

#define ATC_ALG_SHA1    @"sha1"
#define ATC_ALG_MD5     @"md5"
#define ATC_ALG_SHA256  @"sha256"
#define ATC_ALG_SHA384  @"sha384"
#define ATC_ALG_SHA512  @"sha512"
#define ATC_ALG_SHA224  @"sha224"

#define ATC_DEFAULT_DIGTIS      6
#define ATC_DEFAULT_TIME_STEP   30

// ATCAuthVaultItem class
@implementation ATCAuthVaultItem

#pragma mark - Conforms to <NSCopying>

- ( instancetype ) copyWithZone: ( NSZone* )_Zone
    {
    ATCAuthVaultItem* copy = [ [ [ self class ] alloc ] initWithIssuer: self.issuer accountName: self.accountName secretKey: self.secretKey ];
    copy.digits = self.digits;
    copy.timeStep = self.timeStep;
    copy.algorithm = self.algorithm;

    // createdDate, UUID should not be copied

    return copy;
    }

#pragma mark - Properties

@dynamic accountName;
@dynamic digits;
@dynamic timeStep;
@dynamic algorithm;
@dynamic issuer;

@dynamic plistRep;

@dynamic pinCodeRightNow;

- ( void ) setAccountName: ( NSString* )_New
    {
    backingStore_[ kAccountNameKey ] = _New;
    [ self resetCheckSum_ ];
    }

- ( NSString* ) accountName
    {
    return backingStore_[ kAccountNameKey ];
    }

- ( void ) setDigits: ( NSUInteger )_New
    {
    backingStore_[ kDigitsKey ] = [ NSNumber numberWithLong: _New ];
    [ self resetCheckSum_ ];
    }

- ( NSUInteger ) digits
    {
    return [ backingStore_[ kDigitsKey ] unsignedLongValue ];
    }

- ( void ) setTimeStep: ( NSUInteger )_New
    {
    backingStore_[ kTimeStepKey ] = [ NSNumber numberWithLong: _New ];
    [ self resetCheckSum_ ];
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
        case kCCHmacAlgSHA1:    alg = ATC_ALG_SHA1;     break;
        case kCCHmacAlgMD5:     alg = ATC_ALG_MD5;      break;
        case kCCHmacAlgSHA256:  alg = ATC_ALG_SHA256;   break;
        case kCCHmacAlgSHA384:  alg = ATC_ALG_SHA384;   break;
        case kCCHmacAlgSHA512:  alg = ATC_ALG_SHA512;   break;
        case kCCHmacAlgSHA224:  alg = ATC_ALG_SHA224;   break;

        default:
            alg = @"unknown";
        }

    backingStore_[ kAlgorithmKey ] = alg;
    [ self resetCheckSum_ ];
    }

- ( CCHmacAlgorithm ) algorithm
    {
    NSString* algString = backingStore_[ kAlgorithmKey ];
    CCHmacAlgorithm alg = -1;

    if ( [ algString isEqualToString: ATC_ALG_SHA1 ] )          alg = kCCHmacAlgSHA1;
    else if ( [ algString isEqualToString: ATC_ALG_MD5 ] )      alg = kCCHmacAlgMD5;
    else if ( [ algString isEqualToString: ATC_ALG_SHA256 ] )   alg = kCCHmacAlgSHA256;
    else if ( [ algString isEqualToString: ATC_ALG_SHA384 ] )   alg = kCCHmacAlgSHA384;
    else if ( [ algString isEqualToString: ATC_ALG_SHA512 ] )   alg = kCCHmacAlgSHA512;
    else if ( [ algString isEqualToString: ATC_ALG_SHA224 ] )   alg = kCCHmacAlgSHA224;

    return alg;
    }

- ( void ) setIssuer: ( NSString* )_New
    {
    backingStore_[ kIssuerKey ] = _New;
    [ self resetCheckSum_ ];
    }

- ( NSString* ) issuer
    {
    return backingStore_[ kIssuerKey ];
    }

- ( NSDictionary* ) plistRep
    {
    return [ backingStore_ copy ];
    }

- ( NSString* ) pinCodeRightNow
    {
    NSString* pin = [ agTotp_ now ];
    return pin;
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
            , @( ATC_DEFAULT_DIGTIS ), kDigitsKey
            , @( ATC_DEFAULT_TIME_STEP ), kTimeStepKey
            , ATC_ALG_SHA1, kAlgorithmKey
            , TKNonce(), kUUIDKey
            , @( [ NSDate date ].timeIntervalSince1970 ), kCreatedDateKey
            , nil ];

        [ self resetCheckSum_ ];

        agTotp_ = [ [ AGTotp alloc ] initWithDigits: 6 andSecret: [ AGBase32 base32Decode: self.secretKey ] ];
        }

    return self;
    }

#pragma mark - Pasteboard Support

- ( BOOL ) writeToPasteboard: ( NSPasteboard* )_Pboard
    {
    [ _Pboard clearContents ];
    return [ _Pboard writeObjects: @[ self ] ];
    }

#pragma mark - Private Interfaces

- ( void ) resetCheckSum_
    {
    NSString* checksum = kCheckSumOfAuthVaultItemBackingStore_( backingStore_ );
    backingStore_[ kCheckSumKey ] = checksum;
    }

@end // ATCAuthVaultItem class

// ATCAuthVaultItem + ATCFriends_
@implementation ATCAuthVaultItem ( ATCFriends_ )

#pragma mark - Initializations

- ( instancetype ) initWithPlistDict_: ( NSDictionary* )_PlistDict
                               error_: ( NSError** )_Error
    {
    NSError* error = nil;

    NSString* checksum = kCheckSumOfAuthVaultItemBackingStore_( _PlistDict );
    if ( [ checksum isEqualToString: _PlistDict[ kCheckSumKey ] ] )
        {
        if ( self = [ super init ] )
            {
            backingStore_ = [ _PlistDict mutableCopy ];

            agTotp_ = [ [ AGTotp alloc ] initWithDigits: 6 andSecret: [ AGBase32 base32Decode: self.secretKey ] ];
            }

        return self;
        }
    else
        ; // TODO: To construct an error object that contains the information about this failure

    if ( error )
        if ( _Error )
            *_Error = error;

    return nil;
    }

@end // ATCAuthVaultItem + ATCFriends_

// ATCAuthVaultItem + ATCPasteboardSupport
@implementation ATCAuthVaultItem ( ATCPasteboardSupport )

#define kIssuerKey @"kIssuerKey"
#define kAccountNameKey @"kAccountNameKey"
#define kSecretKeyKey @"kSecretKeyKey"

#define kDigitsKey @"kDigitsKey"
#define kTimeStepKey @"kTimeStepKey"
#define kAlgorithmKey @"kAlgorithmKey"

- ( id ) initWithCoder: ( NSCoder* )_Coder
    {
    ATCAuthVaultItem* decoded =
        [ self initWithIssuer: [ _Coder decodeObjectForKey: kIssuerKey ]
                  accountName: [ _Coder decodeObjectForKey: kAccountNameKey ]
                    secretKey: [ _Coder decodeObjectForKey: kSecretKeyKey ] ];

    [ self setDigits: ( NSUInteger )[ _Coder decodeIntegerForKey: kDigitsKey ] ];
    [ self setTimeStep: ( NSUInteger )[ _Coder decodeIntegerForKey: kTimeStepKey ] ];
    [ self setAlgorithm: ( uint32_t )[ _Coder decodeInt32ForKey: kAlgorithmKey ] ];

    return decoded;
    }

- ( void ) encodeWithCoder: ( NSCoder* )_Coder
    {
    [ _Coder encodeObject: [ self issuer ] forKey: kIssuerKey ];
    [ _Coder encodeObject: [ self accountName ] forKey: kAccountNameKey ];
    [ _Coder encodeObject: [ self secretKey ] forKey: kSecretKeyKey ];

    [ _Coder encodeInteger: ( NSInteger )[ self digits ] forKey: kDigitsKey ];
    [ _Coder encodeInteger: ( NSInteger )[ self timeStep ] forKey: kTimeStepKey ];
    [ _Coder encodeInt32: ( int32_t )[ self algorithm ] forKey: kAlgorithmKey ];
    }

// Conforms <NSPasteboardWriting> protocol

- ( NSArray* ) writableTypesForPasteboard: ( NSPasteboard* )_Pboard
    {
    NSArray static* writableTypes = nil;

    if ( !writableTypes )
        writableTypes = @[ ATCPinCodePboardType, NSPasteboardTypeString ];

    return writableTypes;
    }

- ( id ) pasteboardPropertyListForType: ( NSString* )_Type
    {
    id propertyListObject = nil;

    if ( [ _Type isEqualToString: ATCPinCodePboardType ] )
        propertyListObject = [ NSKeyedArchiver archivedDataWithRootObject: self ];

    else if ( [ _Type isEqualToString: NSPasteboardTypeString ] )
        propertyListObject = [ self.pinCodeRightNow pasteboardPropertyListForType: NSPasteboardTypeString ];

    return propertyListObject;
    }

- ( BOOL ) writeToPasteboard: ( NSPasteboard* )_Pboard
    {
    [ _Pboard clearContents ];
    return [ _Pboard writeObjects: @[ self ] ];
    }

@end // ATCAuthVaultItem + ATCPasteboardSupport
