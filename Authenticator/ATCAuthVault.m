//
//  ATCAuthVault.m
//  Authenticator
//
//  Created by Tong G. on 2/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVault.h"
#import "ATCAuthVaultItem.h"
#import "ATCAuthVaultConstants.h"

#import "ATCExtensions_.h"

// Private Interfaces
@interface ATCAuthVault ()

#pragma mark - Meta Data

@property ( strong, readwrite ) NSString* UUID;
@property ( strong, readwrite ) NSDate* createdDate;
@property ( strong, readwrite ) NSDate* modifiedDate;

@property ( assign, readwrite ) NSUInteger numberOfOtpEntries;

- ( NSData* ) cipherFromInternalPlist_: ( NSDictionary* )_InternalPlist
                         withPassword_: ( NSString* )_Password
                                error_: ( NSError** )_Error;

- ( NSDictionary* ) internalPlistFromCipher_: ( NSData* )_Cipher
                               withPassword_: ( NSString* )_Password
                                      error_: ( NSError** )_Error;

- ( void ) resetMetaDataWithInternalPlist: ( NSDictionary* )_InternalPlist;

@property ( assign, readonly ) NSData* assembledAuthVaultDoc_;

@end // Private Interfaces

// ATCAuthVaultWatermark_ class
@interface ATCAuthVaultWatermark_ : NSObject

+ ( NSData* ) watermark;
+ ( uint32_t const* ) bytes;
+ ( NSUInteger ) sizeInBytes;

@end

@implementation ATCAuthVaultWatermark_

uint32_t kWatermarkFlags[ 16 ] = { 0x28019719, 0xABF4A5AF, 0x975A4C4F, 0x516C46D6
                                 , 0x00000344, 0x435BD34D, 0x61636374, 0x7E7369F7
                                 , 0xAAAAFC3D, 0x696F6E54, 0x4B657953, 0xABF78FB0
                                 , 0x64BACA19, 0x41646454, 0x9AAF297A, 0xC5BFBC29
                                 };
+ ( NSData* ) watermark
    {
    return [ NSData dataWithBytes: kWatermarkFlags length: [ self sizeInBytes ] ];
    }

+ ( uint32_t const* ) bytes
    {
    return kWatermarkFlags;
    }

+ ( NSUInteger ) sizeInBytes
    {
    return sizeof( kWatermarkFlags );
    }

@end // ATCAuthVaultWatermark_ class

inline static NSString* kCheckSumOfAuthVaultInternalPlist_( NSDictionary* _InternalPlist )
    {
    NSString* template = @"%@=%@";
    NSMutableArray* checkFields = [ NSMutableArray array ];
    [ checkFields addObject: [ NSString stringWithFormat: template, kUUIDKey, _InternalPlist[ kUUIDKey ] ] ];
    [ checkFields addObject: [ NSString stringWithFormat: template, kCreatedDateKey, _InternalPlist[ kCreatedDateKey ] ] ];
    [ checkFields addObject: [ NSString stringWithFormat: template, kModifiedDateKey, _InternalPlist[ kModifiedDateKey ] ] ];

    NSArray <NSDictionary*>* entries = _InternalPlist[ kOtpEntriesKey ];
    NSMutableArray* entryCheckFields = [ NSMutableArray array ];
    for ( NSDictionary* _OtpEntry in entries )
        [ entryCheckFields addObject: _OtpEntry[ kCheckSumKey ] ?: @"" ];

    if ( entryCheckFields.count )
        [ checkFields addObject: [ NSString stringWithFormat: template, kCheckSumKey, [ entryCheckFields componentsJoinedByString: @"&" ] ] ];

    NSData* base64edCheckFields = [ [ checkFields componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ].base64EncodedDataForAuthVault;
    return base64edCheckFields.HMAC_SHA512DigestStringForAuthVault;
    }

// ATCAuthVault class
@implementation ATCAuthVault

#pragma mark - Creating Auth Vault

- ( instancetype ) initWithMasterPassword: ( NSString* )_Password
                                    error: ( NSError** )_Error
    {
    NSError* error = nil;

    NSTimeInterval createdDate = [ NSDate date ].timeIntervalSince1970;
    NSTimeInterval modifiedDate = createdDate;

    // Constructing the internal plist
    NSMutableDictionary* internalPlist = [ NSMutableDictionary dictionaryWithObjectsAndKeys:
           TKNonce(), kUUIDKey
         , @( createdDate ), kCreatedDateKey
         , @( modifiedDate ), kModifiedDateKey
         , @[], kOtpEntriesKey
         , nil ];

    [ internalPlist addEntriesFromDictionary: @{ kCheckSumKey : kCheckSumOfAuthVaultInternalPlist_( internalPlist ) } ];

    // Cipher
    NSData* cipher = nil;
    if ( ( cipher = [ self cipherFromInternalPlist_: internalPlist withPassword_: _Password error_: &error ] ) )
        {
        if ( self  = [ super init ] )
            {
            backingStore_ = cipher;
            [ self resetMetaDataWithInternalPlist: internalPlist ];
            }

        return self;
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return nil;
    }

- ( instancetype ) initWithData: ( NSData* )_Data
                 masterPassword: ( NSString* )_Password
                          error: ( NSError** )_Error
    {
    NSError* error = nil;

    if ( _Data.isValidAuthVaultData )
        {
        NSUInteger watermarkLength = [ ATCAuthVaultWatermark_ sizeInBytes ];
        NSUInteger length = _Data.length;
        
        NSRange cipherRange = NSMakeRange( watermarkLength, length - ( watermarkLength + CC_SHA512_DIGEST_LENGTH ) );
        NSData* cipher = [ _Data subdataWithRange: cipherRange ];
        NSDictionary* internalPlist = [ self internalPlistFromCipher_: cipher withPassword_: _Password error_: &error ];
        if ( internalPlist )
            {
            if ( self = [ super init ] )
                {
                backingStore_ = cipher;
                [ self resetMetaDataWithInternalPlist: internalPlist ];
                }

            return self;
            }
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return nil;
    }

#pragma mark - Persistent

- ( BOOL ) writeToFile: ( NSString* )_Path atomically: ( BOOL )_Atomically
    {
    return [ self.assembledAuthVaultDoc_ writeToFile: _Path atomically: _Atomically ];
    }

- ( BOOL ) writeToFile: ( NSString* )_Path options: ( NSDataWritingOptions )_Mask error: ( NSError** )_Error
    {
    return [ self.assembledAuthVaultDoc_ writeToFile: _Path options: _Mask error: _Error ];
    }

- ( BOOL ) writeToURL: ( NSURL* )_URL atomically: ( BOOL )_Atomically
    {
    return [ self.assembledAuthVaultDoc_ writeToURL: _URL atomically: _Atomically ];
    }

- ( BOOL ) writeToURL: ( NSURL* )_URL options: ( NSDataWritingOptions )_Mask error: ( NSError** )_Error
    {
    return [ self.assembledAuthVaultDoc_ writeToURL: _URL options: _Mask error: _Error ];
    }

#pragma mark - Managing Otp Entries

- ( BOOL ) addAuthVaultItem: ( ATCAuthVaultItem* )_NewItem
         withMasterPassword: ( NSString* )_Password
                      error: ( NSError** )_Error
    {
    NSError* error = nil;

    BOOL isSuccess = NO;

    NSDictionary* plistRep = [ _NewItem plistRep ];
    NSMutableDictionary* internalPlist = [ [ self internalPlistFromCipher_: backingStore_ withPassword_: _Password error_: &error ] mutableCopy ];
    if ( internalPlist )
        {
        BOOL noDumplicate = YES;
        NSMutableArray* modifiedOptEntries = [ internalPlist[ kOtpEntriesKey ] mutableCopy ];

        for ( NSDictionary* _OptPlist in modifiedOptEntries )
            {
            if ( [ _OptPlist[ kUUIDKey ] isEqualToString: plistRep[ kUUIDKey ]] )
                {
                noDumplicate = NO;
                break;
                }
            }

        if ( noDumplicate )
            {
            [ modifiedOptEntries insertObject: plistRep atIndex: 0 ];
            internalPlist[ kOtpEntriesKey ] = modifiedOptEntries;
            internalPlist[ kModifiedDateKey ] = @( [ NSDate date ].timeIntervalSince1970 );

            backingStore_ = [ self cipherFromInternalPlist_: internalPlist withPassword_: _Password error_: &error ];
            isSuccess = YES;
            }
        else
            ; // TODO: To construct an error object that contains the information about this failure
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return isSuccess;
    }

- ( BOOL ) deleteAuthVaultItem: ( ATCAuthVaultItem* )_NewItem
            withMasterPassword: ( NSString* )_Password
                         error: ( NSError** )_Error
    {
    NSError* error = nil;

    BOOL isSuccess = NO;

    NSDictionary* plistRep = [ _NewItem plistRep ];
    NSMutableDictionary* internalPlist = [ [ self internalPlistFromCipher_: backingStore_ withPassword_: _Password error_: &error ] mutableCopy ];
    if ( internalPlist )
        {
        NSMutableArray* modifiedOptEntries = [ internalPlist[ kOtpEntriesKey ] mutableCopy ];
        NSDictionary* optPlistToBeRemvoed = nil;

        for ( NSDictionary* _OptPlist in modifiedOptEntries )
            {
            if ( [ _OptPlist[ kUUIDKey ] isEqualToString: plistRep[ kUUIDKey ]] )
                {
                optPlistToBeRemvoed = _OptPlist;
                break;
                }
            }

        if ( optPlistToBeRemvoed )
            {
            [ modifiedOptEntries removeObject: optPlistToBeRemvoed ];
            internalPlist[ kOtpEntriesKey ] = modifiedOptEntries;
            internalPlist[ kModifiedDateKey ] = @( [ NSDate date ].timeIntervalSince1970 );

            backingStore_ = [ self cipherFromInternalPlist_: internalPlist withPassword_: _Password error_: &error ];
            isSuccess = YES;
            }
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return isSuccess;
    }

//- ( NSArray <ATCAuthVaultItem*>* ) authVaultItems;
//    {
//    NSMutableArray* authVaultItems = [ NSMutableArray array ];
//
//    NSDictionary* internalPlist = [ backingStore_
//    for ( NS
//    }
//
//- ( BOOL ) setAuthVaultItems: ( NSArray <ATCAuthVaultItem*>* )_Items error: ( NSError** )_Error
//    {
//
//    }

#pragma mark - Private Interfaces

- ( NSData* ) cipherFromInternalPlist_: ( NSDictionary* )_InternalPlist
                         withPassword_: ( NSString* )_Password
                                error_: ( NSError** )_Error
    {
    NSError* error = nil;

    NSData* cipher = nil;

    NSData* binInternalPlist = [ NSPropertyListSerialization
        dataWithPropertyList: _InternalPlist format: NSPropertyListBinaryFormat_v1_0 options: 0 error: &error ];
    if ( binInternalPlist )
        {
        /* Encrypt internal plist
        .------------------.-----------------------------.
        | BinInternalPlist | CheckSumOf_BinInternalPlist |
        .------------------.-----------------------------.
              ▽                              ▽
              │                               │               
              │                               │               
              └─────────────────┬─────────────┘
                                │
                              AES256                          
                                │                             
                                ▼                             
                 .-----------------------------.
                 |           Cipher            |
                 .-----------------------------.
        */
        NSData* checkSumOfBinInternalPlist = binInternalPlist.HMAC_SHA512DigestDataForAuthVault;

        NSMutableData* plainDatBlock = [ NSMutableData data ];
        [ plainDatBlock appendData: binInternalPlist ];
        [ plainDatBlock appendData: checkSumOfBinInternalPlist ];

        cipher = [ RNEncryptor encryptData: plainDatBlock
                              withSettings: kRNCryptorAES256Settings
                                  password: _Password.HMAC_SHA512DigestStringForAuthVault
                                     error: &error ];
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return cipher;
    }

- ( NSDictionary* ) internalPlistFromCipher_: ( NSData* )_Cipher
                               withPassword_: ( NSString* )_Password
                                      error_: ( NSError** )_Error
    {
    NSError* error = nil;

    NSDictionary* internalPlist = nil;

    NSData* plainData = [ RNDecryptor decryptData: _Cipher
                                     withPassword: _Password.HMAC_SHA512DigestStringForAuthVault
                                            error: &error ];
    if ( plainData )
        {
        NSData* binInternalPlist = [ plainData subdataWithRange: NSMakeRange( 0, plainData.length - CC_SHA512_DIGEST_LENGTH ) ];
        NSData* checkSumOfBinInternalPlist = [ plainData subdataWithRange: NSMakeRange( plainData.length - CC_SHA512_DIGEST_LENGTH, CC_SHA512_DIGEST_LENGTH ) ];

        if ( [ binInternalPlist.HMAC_SHA512DigestDataForAuthVault isEqualToData: checkSumOfBinInternalPlist ] )
            {
            NSPropertyListFormat format = 0;
            NSDictionary* plist = [ NSPropertyListSerialization propertyListWithData: binInternalPlist options: 0 format: &format error: &error ];

            if ( plist && format == NSPropertyListBinaryFormat_v1_0 )
                internalPlist = plist;
            else
                ; // TODO: To construct an error object that contains the information about this failure
            }
        }

    return internalPlist;
    }

- ( void ) resetMetaDataWithInternalPlist: ( NSDictionary* )_InternalPlist
    {
    self.UUID = _InternalPlist[ kUUIDKey ];
    self.createdDate = [ NSDate dateWithTimeIntervalSince1970: [ _InternalPlist[ kCreatedDateKey ] doubleValue ] ];
    self.modifiedDate = [ NSDate dateWithTimeIntervalSince1970: [ _InternalPlist[ kModifiedDateKey ] doubleValue ] ];
    self.numberOfOtpEntries = [ _InternalPlist[ kOtpEntriesKey ] count ];
    }

@dynamic assembledAuthVaultDoc_;

- ( NSData* ) assembledAuthVaultDoc_
    {
    /* Auth Vault Doc:
    .------------.-----------------------------.-------------.
    | Watermark  |           Cipher            |  Checksum   |
    .------------.-----------------------------.-------------.
           ▽                   ▽                     ▲
           │                    │                     │       
           │                    ├──────checksum───────┘       
           └────────────────────┘
    */
    NSMutableData* assembledData = [ NSMutableData dataWithData: [ ATCAuthVaultWatermark_ watermark ] ];
    [ assembledData appendData: backingStore_ ];
    [ assembledData appendData: assembledData.HMAC_SHA512DigestDataForAuthVault ];

    return assembledData;
    }

@end // ATCAuthVault class

// NSData + AuthVaultExtensions_
@implementation NSData ( AuthVaultExtensions_ )

@dynamic base64EncodedDataForAuthVault;
@dynamic HMAC_SHA512DigestDataForAuthVault;
@dynamic HMAC_SHA512DigestStringForAuthVault;

@dynamic hasValidWatermarkFlags;
@dynamic isValidAuthVaultData;

- ( NSData* ) base64EncodedDataForAuthVault
    {
    return [ self base64EncodedDataWithOptions:
                NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ];
    }

- ( NSData* ) HMAC_SHA512DigestDataForAuthVault
    {
    unsigned char buffer[ CC_SHA512_DIGEST_LENGTH ];
    CCHmac( kCCHmacAlgSHA512, ATCUnitedTypeIdentifier.UTF8String, ATCUnitedTypeIdentifier.length, self.bytes, self.length, buffer );

    NSData* macOutData = [ NSData dataWithBytes: buffer length: CC_SHA512_DIGEST_LENGTH ];
    return macOutData;
    }

- ( NSString* ) HMAC_SHA512DigestStringForAuthVault
    {
    NSData* macOutData = [ self HMAC_SHA512DigestDataForAuthVault ];
    NSString* checkSum =
        [ [ macOutData base64EncodedStringWithOptions: 0 ]
            stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet alphanumericCharacterSet ] ];

    return checkSum;
    }

- ( BOOL ) hasValidWatermarkFlags
    {
    if ( self.length < [ ATCAuthVaultWatermark_ sizeInBytes ] )
        return NO;

    BOOL hasValidFlags = YES;

    NSData* flagsSubData = [ self subdataWithRange: NSMakeRange( 0, [ ATCAuthVaultWatermark_ sizeInBytes ] ) ];
    for ( int _Index = 0; _Index < [ ATCAuthVaultWatermark_ sizeInBytes ]; _Index += sizeof( int ) )
        {
        uint32_t flag = 0U;
        [ flagsSubData getBytes: &flag range: NSMakeRange( _Index, sizeof( int ) ) ];

        if ( flag != [ ATCAuthVaultWatermark_ bytes ][ ( _Index / sizeof( int ) ) ] )
            {
            hasValidFlags = NO;
            break;
            }
        }

    return hasValidFlags;
    }

- ( BOOL ) isValidAuthVaultData
    {
    BOOL isValid = NO;

    if ( self.hasValidWatermarkFlags )
        {
        NSData* subData = [ self subdataWithRange: NSMakeRange( 0, self.length - CC_SHA512_DIGEST_LENGTH ) ];
        NSData* sha512Digest = subData.HMAC_SHA512DigestDataForAuthVault;

        if ( [ [ self subdataWithRange: NSMakeRange( self.length - CC_SHA512_DIGEST_LENGTH, CC_SHA512_DIGEST_LENGTH ) ]
                isEqualToData: sha512Digest ] )
            isValid = YES;
        }

    return isValid;
    }

@end // NSData + AuthVaultExtensions_

// NSString + AuthVaultExtensions_
@implementation NSString ( AuthVaultExtensions_ )

@dynamic HMAC_SHA512DigestDataForAuthVault;
@dynamic HMAC_SHA512DigestStringForAuthVault;

- ( NSData* ) HMAC_SHA512DigestDataForAuthVault
    {
    return [ [ self dataUsingEncoding: NSUTF8StringEncoding ] HMAC_SHA512DigestDataForAuthVault ];
    }

- ( NSString* ) HMAC_SHA512DigestStringForAuthVault
    {
    return [ [ self dataUsingEncoding: NSUTF8StringEncoding ] HMAC_SHA512DigestStringForAuthVault ];
    }

@end // NSString + AuthVaultExtensions_