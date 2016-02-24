//
//  ATCMainContentViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainContentViewController.h"
#import "ATCMainViewController.h"

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

    [ self.view addSubview: mainViewController_.view ];
    [ mainViewController_.view autoPinEdgesToSuperviewEdges ];
    }

@end // ATCMainContentViewController class