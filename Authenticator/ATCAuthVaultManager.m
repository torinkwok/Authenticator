//
//  ATCAuthVaultManager.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultManager.h"
#import "ATCAuthVault.h"

// ATCAuthVaultManager class
@implementation ATCAuthVaultManager

NSString static* sTmpMasterPassword;
NSURL static* sDefaultVaultURL;

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

+ ( ATCAuthVault* ) generateDefaultAuthVaultWithMasterPassword: ( NSString* )_Password
                                                         error: ( NSError** )_Error
    {
    NSError* error = nil;

    ATCAuthVault* emptyAuthVault = [ [ ATCAuthVault alloc ] initWithMasterPassword: _Password error: &error ];
    if ( emptyAuthVault )
        {
        if ( [ self writeAuthVaultBackIntoDefaultAuthVault: emptyAuthVault error: &error ] )
            {
            sTmpMasterPassword = [ _Password copy ];

            [ [ NSNotificationCenter defaultCenter ]
                postNotificationName: ATCMasterPasswordDidChangeNotif object: self ];
            }
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return emptyAuthVault;
    }

+ ( BOOL ) writeAuthVaultBackIntoDefaultAuthVault: ( ATCAuthVault* )_ModifiedAuthVault
                                            error: ( NSError** )_Error
    {
    return [ _ModifiedAuthVault writeToURL: [ self defaultAuthVaultLocation ] options: NSDataWritingAtomic error: _Error ];
    }

+ ( ATCAuthVault* ) defaultAuthVaultInDefaultLocationWithPassword: ( NSString* )_Password
                                                            error: ( NSError** )_Error
    {
    NSError* error = nil;
    ATCAuthVault* defaultAuthVault = nil;

    if ( [ self defaultAuthVaultExists ] )
        {
        NSData* data = [ NSData dataWithContentsOfURL: [ self defaultAuthVaultLocation ] options: 0 error: &error ];
        if ( data )
            {
            defaultAuthVault = [ [ ATCAuthVault alloc ] initWithData: data masterPassword: _Password error: &error ];

            if ( defaultAuthVault && !error )
                {
                sTmpMasterPassword = [ _Password copy ];

                [ [ NSNotificationCenter defaultCenter ]
                    postNotificationName: ATCMasterPasswordDidChangeNotif object: self ];
                }
            }
        }
    else
        ; // TODO: To construct an error object that contains the information about this failure

    return defaultAuthVault;
    }

+ ( NSString* ) tmpMasterPassword;
    {
    return sTmpMasterPassword;
    }

@end // ATCAuthVaultManager class