//
//  ATCAuthVaultFormatValidator.m
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultFormatValidator.h"

// ATCAuthVaultFormatValidator class
@implementation ATCAuthVaultFormatValidator

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

@end // ATCAuthVaultFormatValidator class