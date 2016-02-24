//
//  ATCPasswordPromptViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCPasswordPromptViewController.h"

// ATCPasswordPromptViewController class
@implementation ATCPasswordPromptViewController

#pragma mark - IBActions

- ( IBAction ) unlockAction: ( id )_Sender
    {
    NSError* error = nil;
    NSString* userInput = self.passwordSecureField.stringValue;

    NSURL* defaultVaultURL = [ ATCDefaultVaultsDirURL() URLByAppendingPathComponent: @"default.authvault" isDirectory: NO ];
    NSData* defaultVaultDat = [ NSData dataWithContentsOfURL: defaultVaultURL ];
    NSData* decryptedData = [ RNDecryptor decryptData: defaultVaultDat withPassword: userInput error: &error ];
    if ( decryptedData)
        [ ATCPasswordManager setMasterPassword: userInput ];

    if ( error )
        NSLog( @"%@", error );
    }

#pragma mark - Conforms to <NSTextFieldDelegate>

- ( void ) controlTextDidChange: ( NSNotification* )_Notif
    {
    NSString* userInput = [ _Notif.userInfo[ @"NSFieldEditor" ] string ];
    self.unlockButton.enabled = ( userInput.length > 0 );
    }

@end // ATCPasswordPromptViewController class