//
//  ATCPasswordSettingViewController.h
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// ATCPasswordSettingViewController class
@interface ATCPasswordSettingViewController : NSViewController

@property ( weak ) IBOutlet NSSecureTextField* passwordSecureField;
@property ( weak ) IBOutlet NSSecureTextField* repeatSecureField;

@property ( weak ) IBOutlet NSButton* quitButton;
@property ( weak ) IBOutlet NSButton* setUpButton;

@end // ATCPasswordSettingViewController class