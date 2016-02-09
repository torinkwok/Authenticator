//
//  ATCSecretKeyManuallyInputViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCSecretKeyManuallyInputViewController.h"
#import "ATCTotpEntry.h"

// Private Interfaces
@interface ATCSecretKeyManuallyInputViewController ()

@end // Private Interfaces

// ATCSecretKeyManuallyInputViewController class
@implementation ATCSecretKeyManuallyInputViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ self.view configureForAutoLayout ];
    [ self.view autoSetDimensionsToSize: self.view.frame.size ];
    }

NSString* const kOKButton = @"ok-button";
NSString* const kCancelButton = @"cancel-button";

- ( void ) dismissController: ( id )_Sender
    {
    [ super dismissController: _Sender ];

    NSString* identifier = [ ( NSButton* )_Sender identifier ];
    if ( [ identifier isEqualToString: kOKButton ] )
        {
        ATCTotpEntry* newEntry =
            [ [ ATCTotpEntry alloc ] initWithServiceName: self.serviceNameField.stringValue
                                                userName: self.accountNameField.stringValue
                                                  secret: self.secretKeyField.stringValue ];
        [ [ NSNotificationCenter defaultCenter ]
            postNotificationName: ATCNewTotpEntryDidAddNotif object: self userInfo: @{ kTotpEntry : newEntry } ];
        }

    [ self.view.window close ];
    }

#pragma mark - Conforms to <NSTextFieldDelegate>

NSString* const kSecretKeyField = @"secret-key-field";
NSString* const kAccountNameField = @"account-name-field";
NSString* const kServiceNameField = @"service-name-field";

- ( void ) controlTextDidChange: ( NSNotification* )_Notif
    {
    NSText* fieldEditor = _Notif.userInfo[ @"NSFieldEditor" ];
    NSTextField* fieldEditorDel = ( NSTextField* )[ fieldEditor delegate ];
    NSString* identifier = [ fieldEditorDel identifier ];

    if ( [ identifier isEqualToString: kSecretKeyField ]
            || [ identifier isEqualToString: kAccountNameField ] )
        [ self.okButton setEnabled:
            ( self.secretKeyField.stringValue.length > 0 ) && ( self.accountNameField.stringValue.length > 0 ) ];
    }

@end // ATCSecretKeyManuallyInputViewController class
