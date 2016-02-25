//
//  ATCAuthVaultManager.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultManager.h"
#import "ATCAuthVault.h"
#import "ATCAuthVaultItem.h"

// ATCDefaultAuthVaultPassWordSource_
@interface ATCDefaultAuthVaultPassWordSource_ : NSObject <ATCAuthVaultPasswordSource>
@property ( strong, readwrite ) NSString* tmpPassword;
@end

@implementation ATCDefaultAuthVaultPassWordSource_
@synthesize tmpPassword;

#pragma mark - Conforms to <ATCAuthVaultPasswordSource>

- ( NSString* ) authVaultNeedsPasswordToUnlock: ( ATCAuthVault* )_AuthVault
    {
    return tmpPassword;
    }

@end // ATCDefaultAuthVaultPassWordSource_

// ATCAuthVaultManager class
@implementation ATCAuthVaultManager

ATCDefaultAuthVaultPassWordSource_ static* sSource;

ATCAuthVault static*    sAuthVault;
NSURL static*           sDefaultVaultURL;

+ ( void ) initialize
    {
    sSource = [ [ ATCDefaultAuthVaultPassWordSource_ alloc ] init ];
    }

+ ( NSURL* ) defaultAuthVaultLocation
    {
    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ( dispatch_block_t )
    ^( void )
        {
        sDefaultVaultURL = [ ATCDefaultVaultsDirURL() URLByAppendingPathComponent: @"default.authvault" isDirectory: NO ];
        } );

    BOOL isDir = NO;
    BOOL exists = [ [ NSFileManager defaultManager ] fileExistsAtPath: sDefaultVaultURL.path isDirectory: &isDir ];
    if ( exists && isDir )
        [ [ NSFileManager defaultManager ] removeItemAtURL: sDefaultVaultURL error: nil ];

    return sDefaultVaultURL;
    }

+ ( BOOL ) defaultAuthVaultExists
    {
    return [ [ self defaultAuthVaultLocation ] checkResourceIsReachableAndReturnError: nil ];
    }

+ ( BOOL ) generateDefaultAuthVaultWithMasterPassword: ( NSString* )_Password
                                                error: ( NSError** )_Error
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    sAuthVault = [ [ ATCAuthVault alloc ] initWithMasterPassword: _Password error: &error ];
    if ( sAuthVault )
        {
        sAuthVault.passwordSource = sSource;
        sSource.tmpPassword = [ _Password copy ];

        if ( [ self writeAuthVaultBackIntoDefaultAuthVault: sAuthVault error: &error ] )
            {
            isSuccess = YES;

            [ [ NSNotificationCenter defaultCenter ]
                postNotificationName: ATCMasterPasswordDidChangeNotif object: self ];
            }
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return isSuccess;
    }

+ ( BOOL ) writeAuthVaultBackIntoDefaultAuthVault: ( ATCAuthVault* )_ModifiedAuthVault
                                            error: ( NSError** )_Error
    {
    return [ _ModifiedAuthVault writeToURL: [ self defaultAuthVaultLocation ] options: NSDataWritingAtomic error: _Error ];
    }

+ ( NSArray <ATCAuthVaultItem*>* ) allItemsOfDefaultAuthVaultWithError: ( NSError** )_Error
    {
    return [ sAuthVault authVaultItemsWithError: _Error ];
    }

+ ( BOOL ) addItemIntoDefaultAuthVault: ( ATCAuthVaultItem* )_Item error: ( NSError** )_Error
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    if ( [ sAuthVault addAuthVaultItem: _Item
                    withMasterPassword: [ self tmpMasterPassword ]
                                 error: &error ] )
        isSuccess = [ sAuthVault writeToURL: [ self defaultAuthVaultLocation ]
                                    options: NSDataWritingAtomic
                                      error: &error ];
    return isSuccess;
    }

+ ( BOOL ) deleteItemFromDefaultAuthVault: ( ATCAuthVaultItem* )_Item error: ( NSError** )_Error
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    if ( [ sAuthVault deleteAuthVaultItem: _Item
                       withMasterPassword: [ self tmpMasterPassword ]
                                    error: &error ] )
        isSuccess = [ sAuthVault writeToURL: [ self defaultAuthVaultLocation ]
                                    options: NSDataWritingAtomic
                                      error: &error ];
    return isSuccess;
    }

+ ( BOOL ) defaultAuthVaultInDefaultLocationWithPassword: ( NSString* )_Password
                                                   error: ( NSError** )_Error
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    if ( [ self defaultAuthVaultExists ] )
        {
        NSData* data = [ NSData dataWithContentsOfURL: [ self defaultAuthVaultLocation ] options: 0 error: &error ];
        if ( data )
            {
            sAuthVault = [ [ ATCAuthVault alloc ] initWithData: data masterPassword: _Password error: &error ];

            if ( sAuthVault && !error )
                {
                sAuthVault.passwordSource = sSource;
                sSource.tmpPassword = [ _Password copy ];

                [ [ NSNotificationCenter defaultCenter ]
                    postNotificationName: ATCMasterPasswordDidChangeNotif object: self ];
                }
            }
        }
    else
        ; // TODO: To construct an error object that contains the information about this failure

    return isSuccess;
    }

+ ( NSString* ) tmpMasterPassword;
    {
    return sSource.tmpPassword ;
    }

@end // ATCAuthVaultManager class