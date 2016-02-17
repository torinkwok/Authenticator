//
//  ATCAuthVaultSerialization.m
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultSerialization.h"

#import "ATCAuthVault.h"

// ATCAuthVault + ATCFriends
@interface ATCAuthVault ( ATCFriends )

#pragma mark - Initializations

- ( instancetype ) initWithPropertyList_: ( NSDictionary* )_PlistDict;

@end // ATCAuthVault + ATCFriends

// Private Interfaces
@interface ATCAuthVaultSerialization ()

// Utilities

+ ( NSString* ) checkSumOfData_: ( NSData* )_Data;
+ ( BOOL ) hasValidWatermarkFlags_: ( NSData* )_Data;
+ ( BOOL ) verifyPrivateBLOB_: ( NSData* )_PrivateBLOB;
+ ( NSString* ) calculateCheckSumOfInternalPropertyListDict_: ( NSDictionary* )_PlistDict;

+ ( BOOL ) matchBytes_: ( uint32_t const [] )_Bytes
               length_: ( size_t )_Length
               inData_: ( NSData* )_Data
              options_: ( NSDataSearchOptions )_SearchOptions;

// Serializing an Auth Vault

+ ( NSString* ) generateCheckSumOfInternalPropertyListDict_: ( NSDictionary* )_PlistDict;
+ ( NSData* ) generateBase64edInternalPropertyListWithPrivateRawBLOB_: ( NSData* )_PrivateBLOB error_: ( NSError** )_Error;

// Deserializing a Property List

+ ( NSDictionary* ) extractInternalPropertyList_: ( NSData* )_ContentsOfUnverifiedFile error_: ( NSError** )_Error;
+ ( BOOL ) verifyInternalPropertyList_: ( NSDictionary* )_PlistDict;

@end // Private Interfaces

uint32_t kWatermarkFlags[ 16 ] = { 0x28019719, 0xABF4A5AF, 0x975A4C4F, 0x516C46D6
                                 , 0x00000344, 0x435BD34D, 0x61636374, 0x7E7369F7
                                 , 0xAAAAFC3D, 0x696F6E54, 0x4B657953, 0xABF78FB0
                                 , 0x64BACA19, 0x41646454, 0x9AAF297A, 0xC5BFBC29
                                 };

NSString* const kUnitedTypeIdentifier = @"home.bedroom.TongKuo.Authenticator.AuthVault";

NSString* const kVersionKey = @"auth-vault-version";
NSString* const kUUIDKey = @"uuid";
NSString* const kCreatedDateKey = @"created-date";
NSString* const kModifiedDateKey = @"modified-date";
NSString* const kPrivateBLOBKey = @"private-blob";
NSString* const kCheckSumKey = @"check-sum";

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

uint32_t* kPrivateBLOBFeatureLibrary[] =
    // 4353534D 5F444C5F 44425F53 4348454D 415F494E 464F
    { ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F53, 0x4348454D, 0x415F494E, 0x464F0000, ( uint32_t )NULL }

    // 4353534D 5F444C5F 44425F53 4348454D 415F4154 54524942 55544553
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F53, 0x4348454D, 0x415F4154, 0x54524942, 0x55544553, ( uint32_t )NULL }

    // 4353534D 5F444C5F 44425F53 4348454D 415F494E 44455845 53
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F53, 0x4348454D, 0x415F494E, 0x44455845, 0x53000000, ( uint32_t )NULL }

    // 4353534D 5F444C5F 44425F53 4348454D 415F5041 5253494E 475F4D4F 44554C45
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F53, 0x4348454D, 0x415F5041, 0x5253494E, 0x475F4D4F, 0x44554C45, ( uint32_t )NULL }

    // 4442426C 6F62
    , ( uint32_t[] ){ 0x4442426C, 0x6F620000, ( uint32_t )NULL }

    // 4353534D 5F444C5F 44425F52 45434F52 445F5055 424C4943 5F4B4559
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F52, 0x45434F52, 0x445F5055, 0x424C4943, 0x5F4B4559, ( uint32_t )NULL }

    // 4353534D 5F444C5F 44425F52 45434F52 445F5052 49564154 455F4B45 59
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F52, 0x45434F52, 0x445F5052, 0x49564154, 0x455F4B45, 0x59000000, ( uint32_t )NULL }

    // 4353534D 5F444C5F 44425F52 45434F52 445F5359 4D4D4554 5249435F 4B4559
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F52, 0x45434F52, 0x445F5359, 0x4D4D4554, 0x5249435F, 0x4B455900, ( uint32_t )NULL }
    };

// ATCAuthVaultSerialization class
@implementation ATCAuthVaultSerialization

#pragma mark - Serializing an Auth Vault

+ ( NSData* ) dataWithEmptyAuthVaultWithMasterPassphrase: ( NSString* )_MasterPassphrase
                                                   error: ( NSError** )_Error
    {
    NSParameterAssert( ( _MasterPassphrase.length ) >= 6 );

    NSError* error = nil;
    NSData* vaultData = nil;

    NSURL* cachesDirURL = nil;
    if ( ( cachesDirURL = [ [ NSFileManager defaultManager ]
                                URLForDirectory: NSCachesDirectory
                                       inDomain: NSUserDomainMask
                              appropriateForURL: nil
                                         create: YES
                                          error: &error ] ) )
        {
        NSURL* tmpKeychainURL = [ cachesDirURL URLByAppendingPathComponent: [ NSString stringWithFormat: @"%@.dat", TKNonce() ] ];

        WSCKeychain* tmpKeychain =
            [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: tmpKeychainURL
                                                               passphrase: _MasterPassphrase
                                                           becomesDefault: NO
                                                                    error: &error ];
        if ( tmpKeychain )
            {
            NSData* rawDataOfTmpKeychain = [ NSData dataWithContentsOfURL: tmpKeychainURL ];
            NSData* internalPlistData = [ self generateBase64edInternalPropertyListWithPrivateRawBLOB_: rawDataOfTmpKeychain error_: &error ];
            if ( internalPlistData )
                {
                NSMutableData* tmpVaultData = [ NSMutableData dataWithBytes: kWatermarkFlags length: sizeof kWatermarkFlags ];

                [ tmpVaultData appendData: [ internalPlistData base64EncodedDataWithOptions:
                    NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ] ];

                vaultData = [ tmpVaultData copy ];
                }
            }
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return vaultData;
    }

#pragma mark - Deserializing a Property List

+ ( ATCAuthVault* ) authVaultWithContentsOfURL: ( NSURL* )_URL
                                         error: ( NSError** )_Error
    {
    if ( ![ _URL.scheme isEqualToString: @"file" ] )
        return NO;

    NSError* error = nil;
    ATCAuthVault* authVault = nil;

    NSData* data = [ NSData dataWithContentsOfURL: _URL options: 0 error: &error ];
    if ( data )
        authVault = [ self authVaultWithData: data error: &error ];

    if ( error )
        *_Error = error;

    return authVault;
    }

+ ( ATCAuthVault* ) authVaultWithData: ( NSData* )_Data
                                error: ( NSError** )_Error
    {
    NSError* error = nil;
    ATCAuthVault* authVault = nil;

    NSData* contentsOfURL = _Data;
    if ( contentsOfURL )
        {
        if ( [ self hasValidWatermarkFlags_: contentsOfURL ] )
            {
            NSDictionary* internalPlist = [ self extractInternalPropertyList_: _Data error_: &error ];

            if ( internalPlist )
                authVault = [ [ ATCAuthVault alloc ] initWithPropertyList_: internalPlist ];
            }
        else
            ; // TODO: To construct an error object that contains the information about this failure
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return authVault;
    }

#pragma mark - Private Interfaces

// Utilities

+ ( NSString* ) checkSumOfData_: ( NSData* )_Data
    {
    unsigned char buffer[ CC_SHA512_DIGEST_LENGTH ];
    CCHmac( kCCHmacAlgSHA512, kUnitedTypeIdentifier.UTF8String, kUnitedTypeIdentifier.length, _Data.bytes, _Data.length, buffer );

    NSData* macData = [ NSData dataWithBytes: buffer length: CC_SHA512_DIGEST_LENGTH ];
    NSString* digest =
        [ [ macData base64EncodedStringWithOptions: 0 ]
            stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet alphanumericCharacterSet ] ];

    return digest;
    }

+ ( BOOL ) hasValidWatermarkFlags_: ( NSData* )_Data
    {
    if ( _Data.length < sizeof kWatermarkFlags )
        return NO;

    BOOL hasValidFlags = YES;

    NSData* flagsSubData = [ _Data subdataWithRange: NSMakeRange( 0, sizeof kWatermarkFlags ) ];
    for ( int _Index = 0; _Index < sizeof kWatermarkFlags; _Index += sizeof( int ) )
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

+ ( BOOL ) verifyPrivateBLOB_: ( NSData* )_PrivateBLOB
    {
    // first veri flags
    uint32_t headFlagsBuffer;
    [ _PrivateBLOB getBytes: &headFlagsBuffer range: NSMakeRange( 0, 4 ) ];

    BOOL allMatches = YES;
    for ( int _Index = 0; _Index < ( sizeof( kPrivateBLOBFeatureLibrary ) / sizeof( uint32_t* ) ); _Index++ )
        {
        uint32_t* features = kPrivateBLOBFeatureLibrary[ _Index ];
        size_t length = 0;

        for ( int _Index = 0; ; _Index++ )
            {
            if ( features[ _Index ] != ( uint32_t )NULL )
                length++;
            else
                break;
            }

        if ( ![ self matchBytes_: kPrivateBLOBFeatureLibrary[ _Index ] length_: length inData_: _PrivateBLOB options_: 0 ] )
            {
            allMatches = NO;
            break;
            }
        }

    BOOL isValid = ( headFlagsBuffer == kExchangeEndianness_( 0x6B796368 ) ) && allMatches;

    return isValid;
    }

+ ( NSString* ) calculateCheckSumOfInternalPropertyListDict_: ( NSDictionary* )_PlistDict
    {
    ATCAuthVaultVersion version = ( ATCAuthVaultVersion )[ _PlistDict[ kVersionKey ] intValue ];
    NSString* uuid = _PlistDict[ kUUIDKey ];
    NSTimeInterval createdDate = [ _PlistDict[ kCreatedDateKey ] doubleValue ];
    NSTimeInterval modifiedDate = [ _PlistDict[ kModifiedDateKey ] doubleValue ];
    NSData* privateBLOB = _PlistDict[ kPrivateBLOBKey ];

    NSMutableArray* checkBucket = [ NSMutableArray arrayWithObjects:
          [ NSData dataWithBytes: &version length: sizeof version ]
        , [ uuid dataUsingEncoding: NSUTF8StringEncoding ]
        , [ NSData dataWithBytes: &createdDate length: sizeof( createdDate ) ]
        , [ NSData dataWithBytes: &modifiedDate length: sizeof( modifiedDate ) ]
        , privateBLOB
        , nil
        ];

    for ( int _Index = 0; _Index < checkBucket.count; _Index++ )
        {
        NSString* checkSum = [ self checkSumOfData_: checkBucket[ _Index ] ];
        [ checkBucket replaceObjectAtIndex: _Index withObject: checkSum ];
        }

    NSData* subCheckSumsDat = [ [ checkBucket componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ];
    return [ self checkSumOfData_: subCheckSumsDat ];
    }

+ ( BOOL ) matchBytes_: ( uint32_t const [] )_Bytes
               length_: ( size_t )_Length
               inData_: ( NSData* )_Data
              options_: ( NSDataSearchOptions )_SearchOptions
    {
    uint32_t processedBytes[ _Length ];
    for ( int _Index = 0; _Index < _Length; _Index++ )
        processedBytes[ _Index ] = kExchangeEndianness_( _Bytes[ _Index ] );

    NSRange searchRange = NSMakeRange( 0, _Data.length );
    NSData* data = [ NSData dataWithBytes: processedBytes length: _Length * sizeof( uint32_t ) ];
    NSRange resultRange = [ _Data rangeOfData: data options: _SearchOptions range: searchRange ];

    return resultRange.location != NSNotFound;
    }

// Serializing an Auth Vault

+ ( NSString* ) generateCheckSumOfInternalPropertyListDict_: ( NSDictionary* )_PlistDict
    {
    return [ self calculateCheckSumOfInternalPropertyListDict_: _PlistDict ];
    }

+ ( NSData* ) generateBase64edInternalPropertyListWithPrivateRawBLOB_: ( NSData* )_PrivateBLOB
                                                               error_: ( NSError** )_Error
    {
    NSError* error = nil;
    NSData* internalPlistData = nil;

    // auth-vault-version key
    ATCAuthVaultVersion version = ATCAuthVault_v1_0;
    // uuid key
    NSString* uuid = TKNonce();
    // created-date key
    NSTimeInterval createdDate = [ [ NSDate date ] timeIntervalSince1970 ];
    // modified-date key
    NSTimeInterval modifiedDate = createdDate;
    // BLOB key
    NSData* tmpKeychainDat = [ _PrivateBLOB base64EncodedDataWithOptions:
        NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ];

    NSMutableDictionary* plistDict = [ NSMutableDictionary dictionaryWithObjectsAndKeys:
          @( version ).stringValue, kVersionKey
        , uuid, kUUIDKey
        , @( createdDate ), kCreatedDateKey
        , @( modifiedDate ), kModifiedDateKey
        , tmpKeychainDat, kPrivateBLOBKey
        , nil
        ];

    // digest key
    [ plistDict addEntriesFromDictionary:
        @{ kCheckSumKey : [ self generateCheckSumOfInternalPropertyListDict_: plistDict ] } ];

    internalPlistData = [ NSPropertyListSerialization dataWithPropertyList: plistDict
                                                                    format: NSPropertyListBinaryFormat_v1_0
                                                                   options: 0
                                                                     error: &error ];
    if ( error )
        if ( _Error )
            *_Error = error;

    return internalPlistData;
    }

+ ( BOOL ) verifyInternalPropertyList_: ( NSDictionary* )_PlistDict
    {
    return [ [ self calculateCheckSumOfInternalPropertyListDict_: _PlistDict ]
                isEqualToString: _PlistDict[ kCheckSumKey ] ];
    }

// Deserializing a Property List

+ ( NSDictionary* ) extractInternalPropertyList_: ( NSData* )_ContentsOfUnverifiedFile
                                          error_: ( NSError** )_Error
    {
    NSError* error = nil;
    NSDictionary* plistDict = nil;

    NSData* base64DecodedData = [ [ NSData alloc ]
        initWithBase64EncodedData: [ _ContentsOfUnverifiedFile subdataWithRange: NSMakeRange( sizeof kWatermarkFlags, _ContentsOfUnverifiedFile.length - sizeof kWatermarkFlags ) ]
                          options: NSDataBase64DecodingIgnoreUnknownCharacters ];
    if ( base64DecodedData )
        {
        NSPropertyListFormat propertyListFormat = 0;

        NSDictionary* tmpPlistDict =
            [ NSPropertyListSerialization propertyListWithData: base64DecodedData
                                                       options: 0
                                                        format: &propertyListFormat
                                                         error: &error ];
        if ( tmpPlistDict )
            {
            if ( propertyListFormat == NSPropertyListBinaryFormat_v1_0 )
                {
                NSData* base64DecodedPrivateBLOB = [ [ NSData alloc ] initWithBase64EncodedData: tmpPlistDict[ kPrivateBLOBKey ] options: NSDataBase64DecodingIgnoreUnknownCharacters ];
                if ( [ self verifyInternalPropertyList_: tmpPlistDict ] && [ self verifyPrivateBLOB_: base64DecodedPrivateBLOB ] )
                    plistDict = tmpPlistDict;
                }
            }
        else
            ; // TODO: To construct an error object that contains the information about the format is invalid
        }
    else
        ; // TODO: To construct an error object that contains the information about this failure

    if ( error )
        if ( _Error )
            *_Error = error;

    return plistDict;
    }

@end // ATCAuthVaultSerialization class

// ATCAuthVault + ATCFriends
@implementation ATCAuthVault ( ATCFriends )

#pragma mark - Initializations

- ( instancetype ) initWithPropertyList_: ( NSDictionary* )_PlistDict
    {
    if ( self = [ super init ] )
        ;

    return self;
    }

@end // ATCAuthVault + ATCFriends