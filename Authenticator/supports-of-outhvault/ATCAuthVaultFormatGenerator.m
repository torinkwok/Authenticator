//
//  ATCAuthVaultFormatGenerator.m
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultFormatGenerator.h"

// ATCAuthVaultFormatGenerator class
@implementation ATCAuthVaultFormatGenerator

+ ( NSData* ) dataOfEmptyAuthVaultWithMasterPassphrase: ( NSString* )_MasterPassphrase
                                                 error: ( NSError** )_Error
    {
    NSParameterAssert( ( _MasterPassphrase.length ) >= 6 );

    NSError* error = nil;
    NSData* plistData = nil;

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
            NSTimeInterval motifiedDate = createdDate;
            NSData* motifiedDateDat = [ NSData dataWithBytes: &motifiedDate length: sizeof( motifiedDate ) ];
            [ plistDict addEntriesFromDictionary: @{ @"modified-date" : @( motifiedDate ) } ];

            // BLOB key
            NSData* tmpKeychainDat = [ [ NSData dataWithContentsOfURL: tmpKeychainURL ]
                base64EncodedDataWithOptions: NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ];
            [ plistDict addEntriesFromDictionary: @{ @"BLOB" : tmpKeychainDat } ];

            // digest key
            NSMutableArray* subCheckSums = [ NSMutableArray arrayWithCapacity: 3 ];
            [ subCheckSums addObject: [ self checkSumOfData_: versionDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: uuidDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: createdDateDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: motifiedDateDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: tmpKeychainDat ] ];

            NSData* subCheckSumsDat = [ [ subCheckSums componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ];
            [ plistDict addEntriesFromDictionary: @{ @"check-sum" : [ self checkSumOfData_: subCheckSumsDat ] } ];

            plistData = [ NSPropertyListSerialization dataWithPropertyList: plistDict
                                                                    format: NSPropertyListXMLFormat_v1_0
                                                                   options: 0 error: &error ];
            }
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return plistData;
    }

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

@end // ATCAuthVaultFormatGenerator class