//
//  ATCAppDelegate.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAppDelegate.h"
#import "ATCAuthVaultSerialization.h"
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
    ATCAuthVault* newAuthVault = [ ATCAuthVaultSerialization emptyAuthVaultWithMasterPassphrase: @"authenticator" error: nil ];
    [ newAuthVault writeToFile: path atomically: YES ];
    #endif

    #if __debug_AuthVault_Parser__
    ATCAuthVault* authVault = [ ATCAuthVaultSerialization authVaultWithContentsOfURL: url error: &error ];
    if ( authVault )
        NSLog( @"🍉%@", authVault );
    else
        NSLog( @"%@", error );
    #endif

//    NSString* keychainPath = [ NSHomeDirectory() stringByAppendingPathComponent: @"test.keychain" ];
//    NSURL* keychainUrl = [ NSURL URLWithString: [ NSString stringWithFormat: @"file://%@", keychainPath ] ];
//    WSCKeychain* newKeychain = [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: keychainUrl passphrase: @"isgtforever" becomesDefault: NO error: nil ];
//
//    NSData* keychainData = nil;
//    unsigned char buffer[ CC_SHA512_DIGEST_LENGTH ];
//    NSData* bufferData = nil;
//
//    [ [ WSCKeychainManager defaultManager ] lockKeychain: newKeychain error: nil ];
//
//    //
//    keychainData = [ NSData dataWithContentsOfURL: keychainUrl ];
//    CCHmac( kCCHmacAlgMD5, @"fuckyou", @"fuckyou".length, keychainData.bytes, keychainData.length, &buffer );
//    bufferData = [ NSData dataWithBytes: buffer length: CC_SHA512_DIGEST_LENGTH ];
//    NSLog( @"%@", [ bufferData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength ] );
//    //
//
//    [ [ WSCKeychainManager defaultManager ] unlockKeychain: newKeychain withPassphrase: @"isgtforever" error: nil ];
//    [ newKeychain addApplicationPassphraseWithServiceName: @"test" accountName: @"tongkuo" passphrase: @"tongkuo" error: nil ];
//
//    //
//    keychainData = [ NSData dataWithContentsOfURL: keychainUrl ];
//    CCHmac( kCCHmacAlgMD5, @"fuckyou", @"fuckyou".length, keychainData.bytes, keychainData.length, &buffer );
//    bufferData = [ NSData dataWithBytes: buffer length: CC_SHA512_DIGEST_LENGTH ];
//    NSLog( @"%@", [ bufferData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength ] );
//    //
//
//    [ newKeychain addApplicationPassphraseWithServiceName: @"test" accountName: @"tongkuo1" passphrase: @"tongkuo" error: nil ];
//
//    //
//    keychainData = [ NSData dataWithContentsOfURL: keychainUrl ];
//    CCHmac( kCCHmacAlgMD5, @"fuckyou", @"fuckyou".length, keychainData.bytes, keychainData.length, &buffer );
//    bufferData = [ NSData dataWithBytes: buffer length: CC_SHA512_DIGEST_LENGTH ];
//    NSLog( @"%@", [ bufferData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength ] );
//    //

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