//
//  ATCPasswordCollectionViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCPasswordCollectionViewController.h"
#import "ATCAuthVault.h"

// ATCPasswordCollectionViewController class
@implementation ATCPasswordCollectionViewController

#pragma mark - IBActions

- ( IBAction ) setUpAction: ( id )_Sender
    {
    NSError* error = nil;

    NSString* userInput = self.repeatSecureField.stringValue;

    NSURL* defaultVaultURL = [ ATCDefaultVaultsDirURL() URLByAppendingPathComponent: @"default.authvault" isDirectory: NO ];
    ATCAuthVault* defaultVault = [ [ ATCAuthVault alloc ] initWithMasterPassword: userInput error: &error ];
    if ( defaultVault )
        {
        [ defaultVault writeToURL: defaultVaultURL atomically: YES ];
        [ ATCAuthVaultManager setMasterPassword: userInput ];
        }

    if ( error )
        NSLog( @"%@", error );
    }

#pragma mark - Conforms to <NSTextFieldDelegate>

- ( void ) controlTextDidChange: ( NSNotification* )_Notif
    {
    self.setUpButton.enabled =
        ( self.passwordSecureField.stringValue.length > 6 )
            && ( self.repeatSecureField.stringValue.length > 6 )
            && [ self.passwordSecureField.stringValue isEqualToString: self.repeatSecureField.stringValue ];
    }

@end // ATCPasswordCollectionViewController class