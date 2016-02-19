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
    if ( self = [ super init ] )
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
            [ data appendData: [ binInternalPlist.checkSumForAuthVault dataUsingEncoding: NSUTF8StringEncoding ] ];

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
                NSMutableData* finalData = [ NSMutableData dataWithBytes: kWatermarkFlags length: sizeof( kWatermarkFlags ) ];
                [ finalData appendData: encryptedData ];
                [ finalData appendData: [ finalData.checkSumForAuthVault dataUsingEncoding: NSUTF8StringEncoding ] ];

                backingStore_ = [ finalData copy ];
                }
            }

        if ( error )
            if ( _Error )
                *_Error = error;
        }

    return self;
    }

- ( instancetype ) initWithData: ( NSData* )_Data
                 masterPassword: ( NSString* )_Password
                          error: ( NSError** )_Error
    {
    if ( self = [ super init ] )
        {
        NSError* error = nil;


        }

    return self;
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