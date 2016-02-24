//
//  ATCMainContentViewController.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class ATCNormalPresentationViewController;
@class ATCPasswordCollectionViewController;
@class ATCPasswordPromptViewController;

// ATCMainContentViewController class
@interface ATCMainContentViewController : NSViewController
    {
@private
    ATCNormalPresentationViewController __strong*   normalPresentationViewController_;
    ATCPasswordCollectionViewController __strong*   passwordSettingViewController_;
    ATCPasswordPromptViewController __strong*       passwordPromptViewController_;
    }

@end // ATCMainContentViewController class