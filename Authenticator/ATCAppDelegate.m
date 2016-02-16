//
//  ATCAppDelegate.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAppDelegate.h"

// Private Interfaces
@interface ATCAppDelegate ()

@end // Private Interfaces

// ATCAppDelegate class
@implementation ATCAppDelegate

#pragma mark - Conforms to <NSApplicationDelegate>

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notif
    {
    // Encoding
//    NSLog( @"%@", [ NSHomeDirectory() stringByAppendingPathComponent: @"login.keychain" ] );
//    NSData* keychainData = [ NSData dataWithContentsOfFile: [ NSHomeDirectory() stringByAppendingPathComponent: @"lab.keychain" ] ];
//    NSData* base64edData = [ keychainData base64EncodedDataWithOptions:
//        NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ];
//
//    NSString* base64edString = [ [ NSString alloc ] initWithData: base64edData encoding: NSUTF8StringEncoding ];
//
//    // Decoding
//    NSData* decodedKeychainData = [ [ NSData alloc ] initWithBase64EncodedString: base64edString options: 0 ];
////    [ decodedKeychainData writeToFile: [ NSHomeDirectory() stringByAppendingPathComponent: @"copy.keychain" ] atomically: YES ];
//    NSLog( @"%@", decodedKeychainData );
    }

//- ( void ) applicationWillResignActive: ( NSNotification* )_Notif
//    {
//    [ [ ATCNotificationCenter sharedTimer ] stopTiming ];
//    }

//- ( void ) applicationWillBecomeActive: ( NSNotification* )_Notif
//    {
//    [ [ ATCNotificationCenter sharedTimer ] startTiming ];
//    }

@end // ATCAppDelegate class