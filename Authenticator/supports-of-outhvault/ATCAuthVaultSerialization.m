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

- ( instancetype ) initWithPropertyList_: ( NSDictionary* )_PlistDict error_: ( NSError** )_Error;

@end // ATCAuthVault + ATCFriends

// Private Interfaces
@interface ATCAuthVaultSerialization ()

// Utilities

+ ( BOOL ) hasValidWatermarkFlags_: ( NSData* )_Data;
+ ( BOOL ) verifyPrivateBLOB_: ( NSData* )_PrivateBLOB;
+ ( NSString* ) calculateCheckSumOfInternalPropertyListDict_: ( NSDictionary* )_PlistDict;

+ ( BOOL ) matchBytes_: ( uint32_t const [] )_Bytes
               length_: ( size_t )_Length
               inData_: ( NSData* )_Data
              options_: ( NSDataSearchOptions )_SearchOptions;

// Serializing an Auth Vault

+ ( NSString* ) generateCheckSumOfInternalPropertyListDict_: ( NSDictionary* )_PlistDict;
+ ( NSData* ) generateBase64edInternalPropertyListWithPrivateRawBLOB_: ( NSData* )_PrivateBLOB blobUUID_: ( NSString* )_BlobUUID error_: ( NSError** )_Error;

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
NSString* const kVaultUUIDKey = @"vault-uuid";
NSString* const kCreatedDateKey = @"created-date";
NSString* const kModifiedDateKey = @"modified-date";
NSString* const kPrivateBlobKey = @"private-blob";
NSString* const kPrivateBlobUUIDKey = @"private-blob-uuid";
NSString* const kPrivateBlobCheckSum = @"private-blob-check-sum";
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

// NSData + AuthVaultExtensions
@interface NSData ( AuthVaultExtensions )

@property ( strong, readonly ) NSData* base64EncodedDataForAuthVault;
@property ( strong, readonly ) NSString* checkSumForAuthVault;

@end // NSData + AuthVaultExtensions

#define ATC_GUARDIAN ( uint32_t )NULL

// The trouble with this solution is that the sub-arrays immediately decay to pointers,
// so where guardian values ATC_GUARDIAN come in handy to mark the end of sub array.
// However this solution can be problematic for arrays of numbers, as there may be no
// allowable "special value".
uint32_t* kPrivateBLOBFeatureLibrary[] =
    // 4353534D 5F444C5F 44425F53 4348454D 415F494E 464F
    { ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F53, 0x4348454D, 0x415F494E, 0x464F0000, ATC_GUARDIAN }

    // 4353534D 5F444C5F 44425F53 4348454D 415F4154 54524942 55544553
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F53, 0x4348454D, 0x415F4154, 0x54524942, 0x55544553, ATC_GUARDIAN }

    // 4353534D 5F444C5F 44425F53 4348454D 415F494E 44455845 53
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F53, 0x4348454D, 0x415F494E, 0x44455845, 0x53000000, ATC_GUARDIAN }

    // 4353534D 5F444C5F 44425F53 4348454D 415F5041 5253494E 475F4D4F 44554C45
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F53, 0x4348454D, 0x415F5041, 0x5253494E, 0x475F4D4F, 0x44554C45, ATC_GUARDIAN }

    // 4442426C 6F62
    , ( uint32_t[] ){ 0x4442426C, 0x6F620000, ATC_GUARDIAN }

    // 4353534D 5F444C5F 44425F52 45434F52 445F5055 424C4943 5F4B4559
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F52, 0x45434F52, 0x445F5055, 0x424C4943, 0x5F4B4559, ATC_GUARDIAN }

    // 4353534D 5F444C5F 44425F52 45434F52 445F5052 49564154 455F4B45 59
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F52, 0x45434F52, 0x445F5052, 0x49564154, 0x455F4B45, 0x59000000, ATC_GUARDIAN }

    // 4353534D 5F444C5F 44425F52 45434F52 445F5359 4D4D4554 5249435F 4B4559
    , ( uint32_t[] ){ 0x4353534D, 0x5F444C5F, 0x44425F52, 0x45434F52, 0x445F5359, 0x4D4D4554, 0x5249435F, 0x4B455900, ATC_GUARDIAN }
    };

// ATCAuthVaultSerialization class
@implementation ATCAuthVaultSerialization

#pragma mark - Serializing an Auth Vault

+ ( ATCAuthVault* ) emptyAuthVaultWithMasterPassphrase: ( NSString* )_MasterPassphrase
                                                 error: ( NSError** )_Error
    {
    NSParameterAssert( ( _MasterPassphrase.length ) >= 6 );

    NSError* error = nil;
    ATCAuthVault* emptyAuthVault = nil;

    NSString* UUID = TKNonce();
    NSURL* tmpKeychainURL = [ ATCTemporaryDirURL() URLByAppendingPathComponent: [ NSString stringWithFormat: @"%@.dat", UUID ] ];

    WSCKeychain* tmpKeychain =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: tmpKeychainURL
                                                           passphrase: _MasterPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    if ( tmpKeychain )
        {
        NSData* vaultData = nil;

        NSData* rawDataOfTmpKeychain = [ NSData dataWithContentsOfURL: tmpKeychainURL ];
        NSData* internalPlistData = [ self generateBase64edInternalPropertyListWithPrivateRawBLOB_: rawDataOfTmpKeychain blobUUID_: UUID error_: &error ];
        if ( internalPlistData )
            {
            NSMutableData* tmpVaultData = [ NSMutableData dataWithBytes: kWatermarkFlags length: sizeof( kWatermarkFlags ) ];
            [ tmpVaultData appendData: [ internalPlistData base64EncodedDataForAuthVault ] ];

            vaultData = [ tmpVaultData copy ];
            }

        emptyAuthVault = [ [ ATCAuthVault alloc ] initWithPropertyList_: internalPlist error_: &error ];
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return emptyAuthVault;
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

    if ( _Data )
        {
        if ( [ self hasValidWatermarkFlags_: _Data ] )
            {
            NSDictionary* internalPlist = [ self extractInternalPropertyList_: _Data error_: &error ];

            if ( internalPlist )
                authVault = [ [ ATCAuthVault alloc ] initWithPropertyList_: internalPlist error_: &error ];
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

+ ( BOOL ) hasValidWatermarkFlags_: ( NSData* )_Data
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

        // Since the sub-arrays have been decayed to pointers,
        // we have to iterate them with a guardian value: ATC_GUARDIAN
        for ( int _Index = 0; ; _Index++ )
            {
            if ( features[ _Index ] != ATC_GUARDIAN )
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
    NSString* uuid = _PlistDict[ kVaultUUIDKey ];
    NSTimeInterval createdDate = [ _PlistDict[ kCreatedDateKey ] doubleValue ];
    NSTimeInterval modifiedDate = [ _PlistDict[ kModifiedDateKey ] doubleValue ];
    NSData* privateBlob = _PlistDict[ kPrivateBlobKey ];
    NSString* privateBlobUUID = _PlistDict[ kPrivateBlobUUIDKey ];
    NSString* privateBlobCheckSum = _PlistDict[ kPrivateBlobCheckSum ];

    NSMutableArray* checkBucket = [ NSMutableArray arrayWithObjects:
          [ NSData dataWithBytes: &version length: sizeof( version ) ]
        , [ uuid dataUsingEncoding: NSUTF8StringEncoding ]
        , [ NSData dataWithBytes: &createdDate length: sizeof( createdDate ) ]
        , [ NSData dataWithBytes: &modifiedDate length: sizeof( modifiedDate ) ]
        , privateBlob
        , [ privateBlobUUID dataUsingEncoding: NSUTF8StringEncoding ]
        , [ privateBlobCheckSum dataUsingEncoding: NSUTF8StringEncoding ]
        , nil
        ];

    for ( int _Index = 0; _Index < checkBucket.count; _Index++ )
        {
        NSString* checkSum = [ checkBucket[ _Index ] checkSumForAuthVault ];
        [ checkBucket replaceObjectAtIndex: _Index withObject: checkSum ];
        }

    NSData* subCheckSumsDat = [ [ checkBucket componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ];
    return subCheckSumsDat.checkSumForAuthVault;
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
                                                            blobUUID_: ( NSString* )_BlobUUID
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
    // private-blob key
    NSData* base64edPrivateBlob = [ _PrivateBLOB base64EncodedDataForAuthVault ];
    // private-blob-uuid key
    NSString* privateBlobUUID = _BlobUUID;
    // private-blob-check-sum key
    NSString* privateBlobCheckSum = base64edPrivateBlob.checkSumForAuthVault;

    NSMutableDictionary* plistDict = [ NSMutableDictionary dictionaryWithObjectsAndKeys:
          @( version ).stringValue, kVersionKey
        , uuid, kVaultUUIDKey
        , @( createdDate ), kCreatedDateKey
        , @( modifiedDate ), kModifiedDateKey
        , base64edPrivateBlob, kPrivateBlobKey
        , privateBlobUUID, kPrivateBlobUUIDKey
        , privateBlobCheckSum, kPrivateBlobCheckSum
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
        initWithBase64EncodedData: [ _ContentsOfUnverifiedFile subdataWithRange: NSMakeRange( sizeof( kWatermarkFlags ), _ContentsOfUnverifiedFile.length - sizeof( kWatermarkFlags ) ) ]
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
                NSData* base64DecodedPrivateBLOB = [ [ NSData alloc ] initWithBase64EncodedData: tmpPlistDict[ kPrivateBlobKey ] options: NSDataBase64DecodingIgnoreUnknownCharacters ];
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
                                  error_: ( NSError** )_Error
    {
    if ( self = [ super init ] )
        {
        NSError* error = nil;

        // self->backingStore_
        NSData* awakenBase64edPrivateBLOB = _PlistDict[ kPrivateBlobKey ];
        NSString* awakenPrivateBlobCheckSum = _PlistDict[ kPrivateBlobCheckSum ];
        NSString* awakenPrivateBlobUUID = _PlistDict[ kPrivateBlobUUIDKey ];

        NSURL* blobCacheURL = [ ATCTemporaryDirURL() URLByAppendingPathComponent: [ NSString stringWithFormat: @"%@.dat", awakenPrivateBlobUUID ] ];

        BOOL needsReExtract = YES;

        BOOL isDir = NO;
        if ( [ [ NSFileManager defaultManager ] fileExistsAtPath: blobCacheURL.path isDirectory: &isDir ] && !isDir )
            {
            NSData* cachedPrivateBlob = [ NSData dataWithContentsOfURL: blobCacheURL ];
            NSString* checkSumOfCache = cachedPrivateBlob.base64EncodedDataForAuthVault.checkSumForAuthVault;

            if ( [ checkSumOfCache isEqualToString: awakenPrivateBlobCheckSum ] )
                needsReExtract = NO;
            }
        else if ( isDir )
            [ [ NSFileManager defaultManager ] removeItemAtURL: blobCacheURL error: nil ];

        if ( needsReExtract )
            {
            NSData* awakenPrivateBlob = [ [ NSData alloc ] initWithBase64EncodedData: awakenBase64edPrivateBLOB options: NSDataBase64DecodingIgnoreUnknownCharacters ];
            [ awakenPrivateBlob writeToURL: blobCacheURL atomically: YES ];
            }

        backingStore_ = [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: blobCacheURL error: &error ];

        // self->location_
//        location_ = [ 

        // self->createdDate_
        createdDate_ = [ NSDate dateWithTimeIntervalSince1970: [ _PlistDict[ kCreatedDateKey ] doubleValue ] ];

        // self->modifiedDate_
        modifiedDate_ = [ NSDate dateWithTimeIntervalSince1970: [ _PlistDict[ kModifiedDateKey ] doubleValue ] ];

        if ( error )
            if ( _Error )
                *_Error = error;
        }

    return self;
    }

@end // ATCAuthVault + ATCFriends

// NSData + AuthVaultExtensions
@implementation NSData ( AuthVaultExtensions )

@dynamic base64EncodedDataForAuthVault;
@dynamic checkSumForAuthVault;

- ( NSData* ) base64EncodedDataForAuthVault
    {
    return [ self base64EncodedDataWithOptions:
                NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ];
    }

- ( NSString* ) checkSumForAuthVault
    {
    unsigned char buffer[ CC_SHA512_DIGEST_LENGTH ];
    CCHmac( kCCHmacAlgSHA512, kUnitedTypeIdentifier.UTF8String, kUnitedTypeIdentifier.length, self.bytes, self.length, buffer );

    NSData* macData = [ NSData dataWithBytes: buffer length: CC_SHA512_DIGEST_LENGTH ];
    NSString* checkSum =
        [ [ macData base64EncodedStringWithOptions: 0 ]
            stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet alphanumericCharacterSet ] ];

    return checkSum;
    }

@end // NSData + AuthVaultExtensions