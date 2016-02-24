//
//  ATCAuthVaultItem.h
//  Authenticator
//
//  Created by Tong G. on 2/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class AGTotp;

// ATCAuthVaultItem class
@interface ATCAuthVaultItem : NSObject
    {
@protected
    NSMutableDictionary __strong* backingStore_;

    AGTotp __strong* agTotp_;
    }

#pragma mark - Properties

@property ( strong, readwrite ) NSString* accountName;
@property ( assign, readwrite ) NSUInteger digits;
@property ( assign, readwrite ) NSUInteger timeStep;
@property ( assign, readwrite ) CCHmacAlgorithm algorithm;
@property ( strong, readwrite ) NSString* issuer;

@property ( strong, readonly ) NSDictionary* plistRep;

@property ( strong, readonly ) NSString* pinCodeRightNow;

#pragma mark - Meta Data

@property ( strong, readonly ) NSString* UUID;
@property ( strong, readonly ) NSDate* createdDate;
@property ( strong, readonly ) NSString* secretKey;

@property ( strong, readonly ) NSString* checkSum;

#pragma mark - Creating Auth Vault Item

- ( instancetype ) initWithIssuer: ( NSString* )_IssuerName accountName: ( NSString* )_AccountName secretKey: ( NSString* )_SecretKey;

@end // ATCAuthVaultItem class