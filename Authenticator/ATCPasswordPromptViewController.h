//
//  ATCPasswordPromptViewController.h
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// ATCPasswordPromptViewController class
@interface ATCPasswordPromptViewController : NSViewController <NSTextFieldDelegate>

#pragma mark - Outlets

@property ( weak ) IBOutlet NSSecureTextField* passwordSecureField;
@property ( weak ) IBOutlet NSButton* unlockButton;

#pragma mark - IBActions

- ( IBAction ) unlockAction: ( id )_Sender;

@end // ATCPasswordPromptViewController class