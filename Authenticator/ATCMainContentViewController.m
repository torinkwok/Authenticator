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

@property ( strong, readonly ) ATCNormalPresentationViewController* normalPresentationViewController_;
@property ( strong, readonly ) ATCPasswordSettingViewController* passwordSettingViewController_;
@property ( strong, readonly ) ATCPasswordPromptViewController* passwordPromptViewController_;

@end // Private Interfaces

// ATCMainContentViewController class
@implementation ATCMainContentViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ self.view addSubview: self.normalPresentationViewController_.view ];
    [ self.normalPresentationViewController_.view autoPinEdgesToSuperviewEdges ];
    }

#pragma mark - Private Interfaces

@dynamic normalPresentationViewController_;
@dynamic passwordSettingViewController_;
@dynamic passwordPromptViewController_;

- ( ATCNormalPresentationViewController* ) normalPresentationViewController_
    {
    if ( !normalPresentationViewController_ )
        {
        normalPresentationViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCNormalPresention" bundle: nil ] instantiateInitialController ];
        [ self addChildViewController: normalPresentationViewController_ ];
        }

    return normalPresentationViewController_;
    }

- ( ATCPasswordSettingViewController* ) passwordSettingViewController_
    {
    if ( !passwordSettingViewController_ )
        {
        passwordSettingViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCPasswordSetting" bundle: nil ] instantiateInitialController ];
        [ self addChildViewController: passwordSettingViewController_ ];
        }

    return passwordSettingViewController_;
    }

- ( ATCPasswordPromptViewController* ) passwordPromptViewController_
    {
    if ( !passwordPromptViewController_ )
        {
        passwordPromptViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCPasswordPrompt" bundle: nil ] instantiateInitialController ];
        [ self addChildViewController: passwordPromptViewController_ ];
        }

    return passwordPromptViewController_;
    }

@end // ATCMainContentViewController class