//
//  ATCAppDelegate.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAppDelegate.h"
#import "ATCAuthVault.h"

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

    #if __debug_AuthVault_Generator__
    ATCAuthVault* authVault = [ [ ATCAuthVault alloc ] initWithMasterPassword: @"isgtforever" error: &error ];
    [ authVault writeToURL: url atomically: YES ];

    if ( !authVault )
        NSLog( @"%@", error );
    #endif

    #if __debug_AuthVault_Parser__
    NSData* authVaultDat = [ NSData dataWithContentsOfURL: url ];
    ATCAuthVault* authVault = [ [ ATCAuthVault alloc ] initWithData: authVaultDat masterPassword: @"isgtforever" error: &error ];

    if ( !authVault )
        NSLog( @"%@", error );
    #endif
    }

@end // ATCAppDelegate class