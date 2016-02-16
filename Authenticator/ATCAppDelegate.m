//
//  ATCAppDelegate.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAppDelegate.h"
#import "ATCAuthVaultFormatGenerator.h"
#import "ATCAuthVaultFormatValidator.h"

// Private Interfaces
@interface ATCAppDelegate ()

@end // Private Interfaces

// ATCAppDelegate class
@implementation ATCAppDelegate

#pragma mark - Conforms to <NSApplicationDelegate>

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notif
    {
    NSString* path = [ NSHomeDirectory() stringByAppendingPathComponent: @"test.authvault" ];
    NSURL* url = [ NSURL URLWithString: [ NSString stringWithFormat: @"file://%@", path ] ];

    #if __debug_AuthVault_Generator__
    NSData* newAuthVault = [ ATCAuthVaultFormatGenerator dataOfEmptyAuthVaultWithMasterPassphrase: @"authenticator" error: nil ];
    [ newAuthVault writeToFile: path atomically: YES ];
    #endif

    #if __debug_AuthVault_Validator__
    BOOL isValid = [ ATCAuthVaultFormatValidator isContentsOfURLValidAuthVault: url ];
    #endif

    // Encoding
//    NSData* keychainData = [ NSData dataWithContentsOfFile: [ NSHomeDirectory() stringByAppendingPathComponent: @"lab.keychain" ] ];
//
//
//    NSData* base64edData = [ keychainData base64EncodedDataWithOptions:
//        NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ];
//
//    NSString* base64edString = [ [ NSString alloc ] initWithData: base64edData encoding: NSUTF8StringEncoding ];
//
//    // Decoding
//    NSData* decodedKeychainData = [ [ NSData alloc ] initWithBase64EncodedString: base64edString options: 0 ];
//    [ decodedKeychainData writeToFile: [ NSHomeDirectory() stringByAppendingPathComponent: @"test.authvault" ] atomically: YES ];
    }

@end // ATCAppDelegate class