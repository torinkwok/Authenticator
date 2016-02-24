//
//  ATCMainContentViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainContentViewController.h"

#import "ATCNormalPresentationViewController.h"
#import "ATCPasswordSettingViewController.h"
#import "ATCPasswordPromptViewController.h"

// Private Interfaces
@interface ATCMainContentViewController ()

@end // Private Interfaces

// ATCMainContentViewController class
@implementation ATCMainContentViewController

- ( void ) viewDidLoad
    {
    if ( !normalPresentationViewController_ )
        {
        normalPresentationViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCNormalPresention" bundle: nil ] instantiateInitialController ];
        [ self addChildViewController: normalPresentationViewController_ ];
        }

    if ( !passwordSettingViewController_ )
        {
        passwordSettingViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCPasswordSetting" bundle: nil ] instantiateInitialController ];
        [ self addChildViewController: passwordSettingViewController_ ];
        }

    if ( !passwordPromptViewController_ )
        {
        passwordPromptViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCPasswordPrompt" bundle: nil ] instantiateInitialController ];
        [ self addChildViewController: passwordPromptViewController_ ];
        }

    [ self.view addSubview: normalPresentationViewController_.view ];
    [ normalPresentationViewController_.view autoPinEdgesToSuperviewEdges ];
    }

@end // ATCMainContentViewController class