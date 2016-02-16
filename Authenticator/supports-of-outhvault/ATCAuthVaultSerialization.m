//
//  ATCAuthVaultSerialization.m
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultSerialization.h"

// Private Interfaces
@interface ATCAuthVaultSerialization ()
+ ( NSString* ) checkSumOfData_: ( NSData* )_Data;
@end // Private Interfaces

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
            NSMutableDictionary* plistDict = [ NSMutableDictionary dictionary ];

            // auth-vault-version key
            NSString* version = @"1.0";
            NSData* versionDat = [ version dataUsingEncoding: NSUTF8StringEncoding ];
            [ plistDict addEntriesFromDictionary: @{ @"auth-vault-version" : version } ];

            // uuid key
            NSString* uuid = TKNonce();
            NSData* uuidDat = [ uuid dataUsingEncoding: NSUTF8StringEncoding ];
            [ plistDict addEntriesFromDictionary: @{ @"uuid" : uuid } ];

            // created-date key
            NSTimeInterval createdDate = [ [ NSDate date ] timeIntervalSince1970 ];
            NSData* createdDateDat = [ NSData dataWithBytes: &createdDate length: sizeof( createdDate ) ];
            [ plistDict addEntriesFromDictionary: @{ @"created-date" : @( createdDate ) } ];

            // modified-date key
            NSTimeInterval modifiedDate = createdDate;
            NSData* modifiedDateDat = [ NSData dataWithBytes: &modifiedDate length: sizeof( modifiedDate ) ];
            [ plistDict addEntriesFromDictionary: @{ @"modified-date" : @( modifiedDate ) } ];

            // BLOB key
            NSData* tmpKeychainDat = [ [ NSData dataWithContentsOfURL: tmpKeychainURL ]
                base64EncodedDataWithOptions: NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ];
            [ plistDict addEntriesFromDictionary: @{ @"BLOB" : tmpKeychainDat } ];

            // digest key
            NSMutableArray* subCheckSums = [ NSMutableArray arrayWithCapacity: 5 ];
            [ subCheckSums addObject: [ self checkSumOfData_: versionDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: uuidDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: createdDateDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: modifiedDateDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: tmpKeychainDat ] ];

            NSData* subCheckSumsDat = [ [ subCheckSums componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ];
            [ plistDict addEntriesFromDictionary: @{ @"check-sum" : [ self checkSumOfData_: subCheckSumsDat ] } ];

            NSData* plistData = [ NSPropertyListSerialization dataWithPropertyList: plistDict
                                                                            format: NSPropertyListXMLFormat_v1_0
                                                                           options: 0
                                                                             error: &error ];

            vaultData = [ plistData base64EncodedDataWithOptions:
                NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ];
            }
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return vaultData;
    }

#pragma mark - Deserializing a Property List

+ ( ATCAuthVault* ) authVaultWithData: ( NSData* )_Data
    {
    ATCAuthVault* authVault = nil;



    return authVault;
    }

+ ( BOOL ) isContentsOfURLValidAuthVault: ( NSURL* )_URL
    {
    if ( ![ _URL.scheme isEqualToString: @"file" ] )
        return NO;

    BOOL isValid = NO;
    NSError* error = nil;

    NSData* contentsOfURL = [ NSData dataWithContentsOfURL: _URL options: 0 error: &error ];
    if ( contentsOfURL )
        {
        NSData* base64DecodedData =
            [ [ NSData alloc ] initWithBase64EncodedData: contentsOfURL
                                                 options: NSDataBase64DecodingIgnoreUnknownCharacters ];
        if ( base64DecodedData )
            {
            NSPropertyListFormat propertyListFormat = 0;
            NSDictionary* plistDict = [ NSPropertyListSerialization propertyListWithData: base64DecodedData
                                                                                 options: 0
                                                                                  format: &propertyListFormat
                                                                                   error: &error ];
            if ( plistDict )
                {
                if ( propertyListFormat == NSPropertyListXMLFormat_v1_0 )
                    {
                    NSString* version = plistDict[ @"auth-vault-version" ];
                    NSData* versionDat = [ version dataUsingEncoding: NSUTF8StringEncoding ];

                    NSString* uuid = plistDict[ @"uuid" ];
                    NSData* uuidDat = [ uuid dataUsingEncoding: NSUTF8StringEncoding ];

                    NSTimeInterval createdDate = [ plistDict[ @"created-date" ] doubleValue ];
                    NSData* createdDateDat = [ NSData dataWithBytes: &createdDate length: sizeof( createdDate ) ];

                    NSTimeInterval modifiedDate = [ plistDict[ @"modified-date" ] doubleValue ];
                    NSData* modifiedDateDat = [ NSData dataWithBytes: &modifiedDate length: sizeof( modifiedDate ) ];

                    NSData* BLOB = plistDict[ @"BLOB" ];

                    NSMutableArray* subCheckSums = [ NSMutableArray arrayWithCapacity: 5 ];
                    [ subCheckSums addObject: [ self checkSumOfData_: versionDat ] ];
                    [ subCheckSums addObject: [ self checkSumOfData_: uuidDat ] ];
                    [ subCheckSums addObject: [ self checkSumOfData_: createdDateDat ] ];
                    [ subCheckSums addObject: [ self checkSumOfData_: modifiedDateDat ] ];
                    [ subCheckSums addObject: [ self checkSumOfData_: BLOB ] ];

                    NSData* subCheckSumsDat = [ [ subCheckSums componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ];
                    NSString* lhsCheckSum = [ self checkSumOfData_: subCheckSumsDat ];
                    NSString* rhsCheckSum = plistDict[ @"check-sum" ];

                    if ( [ lhsCheckSum isEqualToString: rhsCheckSum ] )
                        {
                        isValid = YES;
                        NSLog( @"YES! 🍉" );
                        }
                    }
                else
                    ;
                    // TODO: To construct an error object that contains the information about the format is invalid
                }
            }
        else
            // TODO: To construct an error object that contains the information about this failure
            ;
        }

    return isValid;
    }

#pragma mark - Private Interfaces

+ ( NSString* ) checkSumOfData_: ( NSData* )_Data
    {
    unsigned char buffer[ CC_SHA512_DIGEST_LENGTH ];
    NSString* secretKey = [ [ [ NSBundle mainBundle ] bundleIdentifier ] stringByAppendingString: @".AuthVault" ];
    CCHmac( kCCHmacAlgSHA512, secretKey.UTF8String, secretKey.length, _Data.bytes, _Data.length, buffer );

    NSData* macData = [ NSData dataWithBytes: buffer length: CC_SHA512_DIGEST_LENGTH ];
    NSString* digest =
        [ [ macData base64EncodedStringWithOptions: 0 ]
            stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet alphanumericCharacterSet ] ];

    return digest;
    }

@end // ATCAuthVaultSerialization class

#import "ATCAuthVault.h"

// ATCAuthVault + ATCFriends
@interface ATCAuthVault ( ATCFriends )

#pragma mark - Initializations

- ( instancetype ) initWithPropertyList: ( NSDictionary* )_PlistDict keychain: ( WSCKeychain* )_BackingStore;

@end

@implementation ATCAuthVault ( ATCFriends )

#pragma mark - Initializations

- ( instancetype ) initWithPropertyList: ( NSDictionary* )_PlistDict
                               keychain: ( WSCKeychain* )_BackingStore
    {
    if ( self = [ super init ] )
        backingStore_ = _BackingStore;

    return self;
    }

@end // ATCAuthVault + ATCFriends