//
//  ATCMainContentViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainContentViewController.h"

#import "ATCMainViewController.h"
#import "ATCPasswordSettingViewController.h"
#import "ATCPasswordPromptViewController.h"

// Private Interfaces
@interface ATCMainContentViewController ()

@end // Private Interfaces

// ATCMainContentViewController class
@implementation ATCMainContentViewController

- ( void ) viewDidLoad
    {
    if ( !mainViewController_ )
        {
        mainViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCMainView" bundle: nil ] instantiateInitialController ];
        [ self addChildViewController: mainViewController_ ];
        }

    if ( !passwordSettingViewController_ )
        {
        passwordSettingViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCPasswordSettingView" bundle: nil ] instantiateInitialController ];
        [ self addChildViewController: passwordSettingViewController_ ];
        }

    if ( !passwordPromptViewController_ )
        {
        passwordPromptViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCPasswordPrompt" bundle: nil ] instantiateInitialController ];
        [ self addChildViewController: passwordPromptViewController_ ];
        }

    [ self.view addSubview: passwordPromptViewController_.view ];
    [ passwordPromptViewController_.view autoPinEdgesToSuperviewEdges ];
    }

@end // ATCMainContentViewController class