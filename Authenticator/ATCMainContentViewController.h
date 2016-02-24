//
//  ATCMainContentViewController.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class ATCNormalPresentationViewController;
@class ATCPasswordSettingViewController;
@class ATCPasswordPromptViewController;

// ATCMainContentViewController class
@interface ATCMainContentViewController : NSViewController
    {
@private
    ATCNormalPresentationViewController __strong*   normalPresentationViewController_;
    ATCPasswordSettingViewController __strong*      passwordSettingViewController_;
    ATCPasswordPromptViewController __strong*       passwordPromptViewController_;
    }

@end // ATCMainContentViewController class