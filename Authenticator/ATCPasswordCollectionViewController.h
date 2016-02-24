//
//  ATCPasswordCollectionViewController.h
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// ATCPasswordCollectionViewController class
@interface ATCPasswordCollectionViewController : NSViewController <NSTextFieldDelegate>

#pragma mark - Outlets

@property ( weak ) IBOutlet NSSecureTextField* passwordSecureField;
@property ( weak ) IBOutlet NSSecureTextField* repeatSecureField;

@property ( weak ) IBOutlet NSButton* quitButton;
@property ( weak ) IBOutlet NSButton* setUpButton;

#pragma mark - IBActions

- ( IBAction ) setUpAction: ( id )_Sender;

@end // ATCPasswordCollectionViewController class