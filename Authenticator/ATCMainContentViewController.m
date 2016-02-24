//
//  ATCMainContentViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainContentViewController.h"

#import "ATCNormalPresentationViewController.h"
#import "ATCPasswordCollectionViewController.h"
#import "ATCPasswordPromptViewController.h"

// Private Interfaces
@interface ATCMainContentViewController ()

@property ( strong, readonly ) NSViewController* candidate_;

@property ( strong, readonly ) ATCNormalPresentationViewController* normalPresentationViewController_;
@property ( strong, readonly ) ATCPasswordCollectionViewController* passwordSettingViewController_;
@property ( strong, readonly ) ATCPasswordPromptViewController* passwordPromptViewController_;

@end // Private Interfaces

// ATCMainContentViewController class
@implementation ATCMainContentViewController

#pragma mark - Initializations

- ( void ) installCandidate_
    {
    [ self.view removeAllConstraints ];
    [ self.view setSubviews: @[ self.candidate_.view ] ];
    [ self.candidate_.view autoPinEdgesToSuperviewEdges ];
    }

- ( void ) masterPasswordDidChange_: ( NSNotification* )_Notif
    {
    [ self installCandidate_ ];
    }

- ( void ) viewDidLoad
    {
    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( masterPasswordDidChange_: ) name: ATCMasterPasswordDidChangeNotif object: nil ];

    [ self installCandidate_ ];
    }

#pragma mark - Private Interfaces

@dynamic candidate_;

@dynamic normalPresentationViewController_;
@dynamic passwordSettingViewController_;
@dynamic passwordPromptViewController_;

- ( NSViewController* ) candidate_
    {
    NSViewController* candidate = nil;

    NSURL* defaultVaultURL = [ ATCDefaultVaultsDirURL() URLByAppendingPathComponent: @"default.vault" isDirectory: NO ];
    if ( [ defaultVaultURL checkResourceIsReachableAndReturnError: nil ] )
        {
        if ( [ ATCPasswordManager masterPassword ] )
            candidate = self.normalPresentationViewController_;
        else
            candidate = self.passwordPromptViewController_;
        }
    else
        candidate = self.passwordSettingViewController_;

    return candidate;
    }

- ( ATCNormalPresentationViewController* ) normalPresentationViewController_
    {
    if ( !normalPresentationViewController_ )
        {
        normalPresentationViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCNormalPresention" bundle: nil ] instantiateInitialController ];
        [ self addChildViewController: normalPresentationViewController_ ];
        }

    return normalPresentationViewController_;
    }

- ( ATCPasswordCollectionViewController* ) passwordSettingViewController_
    {
    if ( !passwordSettingViewController_ )
        {
        passwordSettingViewController_ = [ [ NSStoryboard storyboardWithName: @"ATCPasswordCollection" bundle: nil ] instantiateInitialController ];
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