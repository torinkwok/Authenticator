//
//  ATCSecretKeyManuallyInputViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCSecretKeyManuallyInputViewController.h"

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

@end // ATCSecretKeyManuallyInputViewController class
