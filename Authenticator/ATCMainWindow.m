//
//  ATCMainWindow.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainWindow.h"

// ATCMainWindow class
@implementation ATCMainWindow

#pragma mark - Initializations

- ( void ) awakeFromNib
    {
    self.titleVisibility = NSWindowTitleHidden;
    self.titlebarAppearsTransparent = YES;
    self.styleMask |= NSFullSizeContentViewWindowMask;
    }

@end // ATCMainWindow class
