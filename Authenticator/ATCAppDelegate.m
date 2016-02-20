//
//  ATCAppDelegate.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAppDelegate.h"
#import "ATCAuthVaultItem.h"

// Private Interfaces
@interface ATCAppDelegate ()

@end // Private Interfaces

// ATCAppDelegate class
@implementation ATCAppDelegate

#pragma mark - Conforms to <NSApplicationDelegate>

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notif
    {
    NSError* error = nil;

    NSString* path = [ NSHomeDirectory() stringByAppendingPathComponent: @"test.authvault" ];
    NSURL* url = [ NSURL URLWithString: [ NSString stringWithFormat: @"file://%@", path ] ];
    NSString* password = @"isgtforever";

    #if __debug_AuthVault_Generator__
    ATCAuthVault* authVault = [ [ ATCAuthVault alloc ] initWithMasterPassword: password error: &error ];
    if ( authVault )
        {
        BOOL isSuccess = NO;
        [ authVault writeToURL: url atomically: YES ];

        ATCAuthVaultItem* item0 = [ [ ATCAuthVaultItem alloc ] initWithIssuer: @"Google" accountName: @"contact@tong-kuo.me" secretKey: @"uqgrz4nub4tz5zwn" ];
        ATCAuthVaultItem* item1 = [ [ ATCAuthVaultItem alloc ] initWithIssuer: @"Google" accountName: @"contact@tong-kuo.me" secretKey: @"3v7ptpbjedv3ivof" ];
        ATCAuthVaultItem* item2 = [ [ ATCAuthVaultItem alloc ] initWithIssuer: @"Evernote" accountName: @"contact@tong-kuo.me" secretKey: @"dznyivy5pcf5si64" ];

        isSuccess = [ authVault addAuthVaultItem: item0 withMasterPassword: password error: &error ];
        isSuccess = [ authVault addAuthVaultItem: item1 withMasterPassword: password error: &error ];
        isSuccess = [ authVault addAuthVaultItem: item2 withMasterPassword: password error: &error ];
        isSuccess = [ authVault addAuthVaultItem: item0 withMasterPassword: password error: &error ];

        [ authVault writeToURL: url atomically: YES ];
        }

    if ( error )
        NSLog( @"%@", error );
    #endif

    #if __debug_AuthVault_Parser__
    NSData* authVaultDat = [ NSData dataWithContentsOfURL: url ];
    ATCAuthVault* authVault = [ [ ATCAuthVault alloc ] initWithData: authVaultDat masterPassword: @"isgtforever" error: &error ];
    [ authVault

    if ( !authVault )
        NSLog( @"%@", error );
    #endif
    }

#pragma mark - Conforms to <ATCAuthVaultPasswordSource>

- ( NSString* ) authVaultNeedsPasswordToUnlock: ( ATCAuthVault* )_AuthVault
    {
    return @"isgtforever";
    }

@end // ATCAppDelegate class