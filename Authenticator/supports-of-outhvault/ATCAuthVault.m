//
//  ATCAuthVault.m
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVault.h"

#import "ATCAuthVault+ATCFriends_.h"
#import "NSData+AuthVaultExtensions_.h"
#import "ATCAuthVaultItem+ATCFriends_.h"

// Private Interfaces
@interface ATCAuthVault ()

@end // Private Interfaces

NSString* const kVersionKey = @"auth-vault-version";
NSString* const kVaultUUIDKey = @"vault-uuid";
NSString* const kCreatedDateKey = @"created-date";
NSString* const kModifiedDateKey = @"modified-date";
NSString* const kSecretsKey = @"secrets";
NSString* const kSecretsCheckSumKey = @"secrets-check-sum";
NSString* const kCheckSumKey = @"check-sum";

// ATCAuthVault class
@implementation ATCAuthVault

#pragma mark - Initializations

+ ( ATCAuthVault* ) emptyAuthVaultWithMasterPassphrase: ( NSString* )_MasterPassphrase
                                                 error: ( NSError** )_Error
    {
    return [ [ self alloc ] initWithMasterPassphrase: _MasterPassphrase error: _Error ];
    }

+ ( NSString* ) generateCheckSumOfInternalPropertyListDict_: ( NSDictionary* )_PlistDict
    {
    return [ self calculateCheckSumOfInternalPropertyListDict_: _PlistDict ];
    }

+ ( NSData* ) generateBase64edInternalPropertyListWithDictionary_: ( NSDictionary* )_PlistDict
                                                           error_: ( NSError** )_Error
    {
    NSError* error = nil;
    NSData* internalPlistData = nil;

    // auth-vault-version key
    ATCAuthVaultVersion version = [ _PlistDict[ kVersionKey ] int32Value ];
    // uuid key
    NSString* uuid = _PlistDict[ kVaultUUIDKey ];
    // created-date key
    NSTimeInterval createdDate = [ _PlistDict[ kCreatedDateKey ] timeIntervalSince1970 ];
    // modified-date key
    NSTimeInterval modifiedDate = [ _PlistDict[ kModifiedDateKey ] timeIntervalSince1970 ];
    // secrets key
    NSDictionary* secretsDict = @{};

    NSMutableDictionary* plistDict = [ NSMutableDictionary dictionaryWithObjectsAndKeys:
          @( version ).stringValue, kVersionKey
        , uuid, kVaultUUIDKey
        , @( createdDate ), kCreatedDateKey
        , @( modifiedDate ), kModifiedDateKey
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

- ( ATCAuthVault* ) initWithMasterPassphrase: ( NSString* )_MasterPassphrase
                                       error: ( NSError** )_Error
    {
    NSParameterAssert( ( _MasterPassphrase.length ) >= 6 );

    if ( self = [ super init ] )
        {

        self.UUID = TKNonce();

        self.createdDate = [ NSDate date ];
        self.modifiedDate = [ self.createdDate copy ];
        }

    return self;
    }

#pragma mark - Meta Data

@dynamic UUID;
@dynamic createdDate;
@dynamic modifiedDate;
@dynamic checkSum;

- ( NSString* ) UUID
    {
    return UUID_;
    }

- ( NSDate* ) createdDate
    {
    return createdDate_;
    }

- ( NSDate* ) modifiedDate
    {
    return modifiedDate_;
    }

#pragma mark - Creating and Managing Vault Items

- ( NSString* ) checkSumOfDataBlocks_: ( NSArray <NSData*>* )_DataBlocks
    {
    NSMutableArray* checkSumBucket = [ _DataBlocks mutableCopy ];

    for ( int _Index = 0; _Index < checkSumBucket.count; _Index++ )
        [ checkSumBucket replaceObjectAtIndex: _Index withObject: [ checkSumBucket[ _Index ] checkSumForAuthVault ] ];

    NSString* checkSum = [ [ checkSumBucket componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ].checkSumForAuthVault;
    return checkSum;
    }

- ( ATCAuthVaultItem* ) addVaultItemWithIssuerName: ( NSString* )_IssuerName
                                       accountName: ( NSString* )_AccountName
                                            secret: ( NSString* )_Secret
                                             error: ( NSError** )_Error
    {
    return nil;
    }

//- ( ATCAuthVaultItem* ) findVaultItemWithName: ( NSString* )_ItemName error: ( NSError** )_Error;
//- ( void ) deleteVaultItem: ( ATCAuthVaultItem* )_VaultItem error: ( NSError** )_Error;

@end // ATCAuthVault class

// ATCAuthVault + ATCFriends_
@implementation ATCAuthVault ( ATCFriends_ )

#pragma mark - Meta Data

@dynamic UUID;
@dynamic createdDate;
@dynamic modifiedDate;

- ( void ) setUUID: ( NSString* )_NewUUID
    {
    UUID_ = _NewUUID;
    }

- ( void ) setCreatedDate: ( NSDate* )_Date
    {
    createdDate_ = _Date;
    }

- ( void ) setModifiedDate: ( NSDate* )_Date
    {
    modifiedDate_ = _Date;
    }

#pragma mark - Real Private Interfaces

@dynamic backingStoreData_;

- ( NSData* ) backingStoreData_
    {
    NSData* data = [ NSData dataWithContentsOfURL: backingStore_.URL ];
    return data;
    }

@end // ATCAuthVault + ATCFriends_

// NSData + AuthVaultExtensions_
@implementation NSData ( AuthVaultExtensions_ )

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
    CCHmac( kCCHmacAlgSHA512, ATCUnitedTypeIdentifier.UTF8String, ATCUnitedTypeIdentifier.length, self.bytes, self.length, buffer );

    NSData* macData = [ NSData dataWithBytes: buffer length: CC_SHA512_DIGEST_LENGTH ];
    NSString* checkSum =
        [ [ macData base64EncodedStringWithOptions: 0 ]
            stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet alphanumericCharacterSet ] ];

    return checkSum;
    }

@end // NSData + AuthVaultExtensions_