//
//  NSData+AuthVaultExtensions_.h
//  Authenticator
//
//  Created by Tong G. on 2/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// NSData + AuthVaultExtensions_
@interface NSData ( AuthVaultExtensions_ )

@property ( strong, readonly ) NSData* base64EncodedDataForAuthVault;
@property ( strong, readonly ) NSData* HMAC_SHA512DigestDataForAuthVault;
@property ( strong, readonly ) NSString* HMAC_SHA512DigestStringForAuthVault;

@end // NSData + AuthVaultExtensions_