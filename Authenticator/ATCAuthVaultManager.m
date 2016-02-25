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

// ATCAuthVaultManager class
@implementation ATCAuthVaultManager

ATCAuthVault static*    sAuthVault;
NSString static*        sTmpMasterPassword;
NSURL static*           sDefaultVaultURL;

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
        if ( [ self writeAuthVaultBackIntoDefaultAuthVault: sAuthVault error: &error ] )
            {
            sTmpMasterPassword = [ _Password copy ];
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
                sTmpMasterPassword = [ _Password copy ];

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
    return sTmpMasterPassword;
    }

@end // ATCAuthVaultManager class