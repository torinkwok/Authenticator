//
//  ATCBeautifulWindow.m
//  Authenticator
//
//  Created by Tong G. on 2/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCBeautifulWindow.h"

// ATCBeautifulWindow class
@implementation ATCBeautifulWindow

#pragma mark - Initializations

- ( void ) awakeFromNib
    {
    self.titleVisibility = NSWindowTitleHidden;
    self.titlebarAppearsTransparent = YES;
    self.styleMask |= NSFullSizeContentViewWindowMask;
    }

@end // ATCBeautifulWindow class
