//
//  ATCAuthVault.m
//  Authenticator
//
//  Created by Tong G. on 2/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVault.h"
#import "ATCAuthVaultConstants.h"

#import "NSData+AuthVaultExtensions_.h"

// Private Interfaces
@interface ATCAuthVault ()

- ( BOOL ) hasValidWatermarkFlags_: ( NSData* )_Data;

@end // Private Interfaces

uint32_t kWatermarkFlags[ 16 ] = { 0x28019719, 0xABF4A5AF, 0x975A4C4F, 0x516C46D6
                                 , 0x00000344, 0x435BD34D, 0x61636374, 0x7E7369F7
                                 , 0xAAAAFC3D, 0x696F6E54, 0x4B657953, 0xABF78FB0
                                 , 0x64BACA19, 0x41646454, 0x9AAF297A, 0xC5BFBC29
                                 };

inline static uint32_t kExchangeEndianness_( uint32_t _Value )
    {
    #if !TARGET_RT_BIG_ENDIAN // On Intel Mac, the following code fragment will be executed
    uint32_t result = 0;

    result |= ( _Value & 0x000000FF ) << 24;
    result |= ( _Value & 0x0000FF00 ) << 8;
    result |= ( _Value & 0x00FF0000 ) >> 8;
    result |= ( _Value & 0xFF000000 ) >> 24;

    return result;
    #else
    return _Value;
    #endif
    }

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
    return base64edCheckFields.checkSumForAuthVault;
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

    NSMutableDictionary* internalPlist =[ NSMutableDictionary dictionaryWithObjectsAndKeys:
           TKNonce(), kUUIDKey
         , @( createdDate ), kCreatedDateKey
         , @( modifiedDate ), kModifiedDateKey
         , @[], kOtpEntriesKey
         , nil ];

    [ internalPlist addEntriesFromDictionary: @{ kCheckSumKey : kCheckSumOfAuthVaultInternalPlist_( internalPlist ) } ];

    NSData* binInternalPlist = [ NSPropertyListSerialization dataWithPropertyList: internalPlist format: NSPropertyListBinaryFormat_v1_0 options: 0 error: &error ];
    if ( binInternalPlist )
        {
        /* 
        .------------------.-----------------------------.
        | BinInternalPlist | CheckSumOf_BinInternalPlist |
        .------------------.-----------------------------. 
        */
        NSMutableData* data = [ NSMutableData dataWithData: binInternalPlist ];
        [ data appendData: binInternalPlist.sha512DigestForAuthVault ];

       /*       
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
        .------------.-----------------------------.-------------.
        | Watermark  |  EncryptedBinInternalPlist  |  Checksum   |
        .------------.-----------------------------.-------------.
               ▽                   ▽                     ▲
               │                    │                     │       
               │                    ├──────checksum───────┘       
               └────────────────────┘
        */
        NSData* encryptedData = [ RNEncryptor encryptData: data withSettings: kRNCryptorAES256Settings password: _Password error: &error ];
        if ( encryptedData )
            {
            if ( self = [ super init ] )
                {
                NSMutableData* finalData = [ NSMutableData dataWithBytes: kWatermarkFlags length: sizeof( kWatermarkFlags ) ];
                [ finalData appendData: encryptedData ];
                [ finalData appendData: finalData.sha512DigestForAuthVault ];

                backingStore_ = [ finalData copy ];
                }

            return self;
            }
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return nil;
    }

- ( BOOL ) isValidAuthVaultData_: ( NSData* )_AuthVaultData
    {
    BOOL isValid = NO;

    if ( [ self hasValidWatermarkFlags_: _AuthVaultData ] )
        {
        NSData* subData = [ _AuthVaultData subdataWithRange: NSMakeRange( 0, _AuthVaultData.length - CC_SHA512_DIGEST_LENGTH ) ];
        NSData* sha512Digest = subData.sha512DigestForAuthVault;

        if ( [ [ _AuthVaultData subdataWithRange: NSMakeRange( _AuthVaultData.length - CC_SHA512_DIGEST_LENGTH, CC_SHA512_DIGEST_LENGTH ) ]
                isEqualToData: sha512Digest ] )
            isValid = YES;
        }

    return isValid;
    }

- ( instancetype ) initWithData: ( NSData* )_Data
                 masterPassword: ( NSString* )_Password
                          error: ( NSError** )_Error
    {
    NSError* error = nil;

    if ( [ self isValidAuthVaultData_: _Data ] )
        {
        NSRange cipherRange = NSMakeRange( sizeof( kWatermarkFlags ), _Data.length - CC_SHA512_DIGEST_LENGTH - CC_SHA512_DIGEST_LENGTH );
        NSData* cipher = [ _Data subdataWithRange: cipherRange ];
        NSData* plainData = [ RNDecryptor decryptData: cipher withPassword: _Password error: &error ];
        if ( plainData )
            {
            NSData* binInternalPlist = [ plainData subdataWithRange: NSMakeRange( 0, plainData.length - CC_SHA512_DIGEST_LENGTH ) ];
            NSData* sha512Digest = [ plainData subdataWithRange: NSMakeRange( plainData.length - CC_SHA512_DIGEST_LENGTH, CC_SHA512_DIGEST_LENGTH ) ];

            if ( [ binInternalPlist.sha512DigestForAuthVault isEqualToData: sha512Digest ] )
                {
                if ( self = [ super init ] )
                    backingStore_ = _Data;

                return self;
                }
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
    return [ backingStore_ writeToFile: _Path atomically: _Atomically ];
    }

- ( BOOL ) writeToFile: ( NSString* )_Path options: ( NSDataWritingOptions )_Mask error: ( NSError** )_Error
    {
    return [ backingStore_ writeToFile: _Path options: _Mask error: _Error ];
    }

- ( BOOL ) writeToURL: ( NSURL* )_URL atomically: ( BOOL )_Atomically
    {
    return [ backingStore_ writeToURL: _URL atomically: _Atomically ];
    }

- ( BOOL ) writeToURL: ( NSURL* )_URL options: ( NSDataWritingOptions )_Mask error: ( NSError** )_Error
    {
    return [ backingStore_ writeToURL: _URL options: _Mask error: _Error ];
    }

#pragma mark - Private Interfaces

- ( BOOL ) hasValidWatermarkFlags_: ( NSData* )_Data
    {
    if ( _Data.length < sizeof( kWatermarkFlags ) )
        return NO;

    BOOL hasValidFlags = YES;

    NSData* flagsSubData = [ _Data subdataWithRange: NSMakeRange( 0, sizeof( kWatermarkFlags ) ) ];
    for ( int _Index = 0; _Index < sizeof( kWatermarkFlags ); _Index += sizeof( int ) )
        {
        uint32_t flag = 0U;
        [ flagsSubData getBytes: &flag range: NSMakeRange( _Index, sizeof( int ) ) ];

        if ( flag != kWatermarkFlags[ ( _Index / sizeof( int ) ) ] )
            {
            hasValidFlags = NO;
            break;
            }
        }

    return hasValidFlags;
    }

@end // ATCAuthVault class