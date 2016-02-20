//
//  NSData+AuthVaultExtensions_.m
//  Authenticator
//
//  Created by Tong G. on 2/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "NSData+AuthVaultExtensions_.h"

// NSData + AuthVaultExtensions_
@implementation NSData ( AuthVaultExtensions_ )

@dynamic base64EncodedDataForAuthVault;
@dynamic HMAC_SHA512DigestDataForAuthVault;
@dynamic HMAC_SHA512DigestStringForAuthVault;

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

@end // NSData + AuthVaultExtensions_