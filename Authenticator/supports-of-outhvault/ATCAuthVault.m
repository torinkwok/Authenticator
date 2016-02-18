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

// ATCAuthVault class
@implementation ATCAuthVault

#pragma mark - Initializations

+ ( ATCAuthVault* ) emptyAuthVaultWithMasterPassphrase: ( NSString* )_MasterPassphrase
                                                 error: ( NSError** )_Error
    {
    return [ [ self alloc ] initWithMasterPassphrase: _MasterPassphrase error: _Error ];
    }

- ( ATCAuthVault* ) initWithMasterPassphrase: ( NSString* )_MasterPassphrase
                                       error: ( NSError** )_Error
    {
    NSParameterAssert( ( _MasterPassphrase.length ) >= 6 );

    if ( self = [ super init ] )
        {
        NSError* error = nil;

        self.UUID = TKNonce();

        NSURL* tmpKeychainURL = [ ATCTemporaryDirURL() URLByAppendingPathComponent: [ NSString stringWithFormat: @"%@.dat", self.UUID ] ];

        backingStore_ = [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: tmpKeychainURL passphrase: _MasterPassphrase becomesDefault: NO error: &error ];
        if ( backingStore_ )
            [ [ WSCKeychainManager defaultManager ] unlockKeychain: backingStore_ withPassphrase: _MasterPassphrase error: &error ];

        self.createdDate = [ NSDate date ];
        self.modifiedDate = [ self.createdDate copy ];
        }

    return self;
    }

#pragma mark - Meta Data

@dynamic UUID;
@dynamic createdDate;
@dynamic modifiedDate;

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
    NSError* error = nil;

    NSString* serviceName = ATCUnitedTypeIdentifier;
    NSString* accountName = TKNonce();

    NSDictionary* plistDict = @{ @"created-date" : @( [ [ NSDate date ] timeIntervalSince1970 ] )
                               , @"issuer" : _IssuerName
                               , @"account-name" : _AccountName
                               , @"secret-key" : _Secret
                               };

    NSData* base64edPlist =
        [ NSPropertyListSerialization dataWithPropertyList: plistDict
                                                    format: NSPropertyListBinaryFormat_v1_0
                                                   options: 0
                                                     error: &error ].base64EncodedDataForAuthVault;

    NSString* comment = [ self checkSumOfDataBlocks_: @[ serviceName, accountName, base64edPlist ] ];

    WSCPassphraseItem* passphraseItem = [ backingStore_
        addApplicationPassphraseWithServiceName: @"home.bedroom.TongKuo.Authenticator.AuthVault" accountName: accountName passphrase: @"isgtforever" error: &error ];

    [ passphraseItem setComment: comment ];

    return [ [ ATCAuthVaultItem alloc ] initWithPassphraseItem_: passphraseItem ];
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