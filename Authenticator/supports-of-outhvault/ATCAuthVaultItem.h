//
//  ATCAuthVaultItem.h
//  Authenticator
//
//  Created by Tong G. on 2/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//`

// ATCAuthVaultItem class
@interface ATCAuthVaultItem : NSObject
    {
@protected
    NSDictionary __strong* backingStore_;
    }

#pragma mark - Properties

@property ( strong, readonly ) NSString* UUID;
@property ( strong, readonly ) NSString* accountName;
@property ( strong, readonly ) NSDate* createdDate;
@property ( assign, readonly ) NSUInteger digits;
@property ( assign, readonly ) NSUInteger timeStep;
@property ( assign, readonly ) CCHmacAlgorithm algorithm;
@property ( strong, readonly ) NSString* issuer;
@property ( strong, readonly ) NSString* secretKey;

@property ( strong, readonly ) NSString* checkSum;

@end // ATCAuthVaultItem class