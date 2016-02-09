//
//  ATCSecretKeyManuallyInputViewController.h
//  Authenticator
//
//  Created by Tong G. on 2/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Cocoa;

// ATCSecretKeyManuallyInputViewController class
@interface ATCSecretKeyManuallyInputViewController : NSViewController <NSTextFieldDelegate>

@property ( weak ) IBOutlet NSSecureTextField* secretKeyField;
@property ( weak ) IBOutlet NSTextField* accountNameField;
@property ( weak ) IBOutlet NSTextField* serviceNameField;

@property ( weak ) IBOutlet NSButton* cancelButton;
@property ( weak ) IBOutlet NSButton* okButton;

@end // ATCSecretKeyManuallyInputViewController class
