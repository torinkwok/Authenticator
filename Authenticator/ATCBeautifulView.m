//
//  ATCBeautifulView.m
//  Authenticator
//
//  Created by Tong G. on 2/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCBeautifulView.h"

// ATCBeautifulView class
@implementation ATCBeautifulView

#pragma mark - Initializations

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self.state = NSVisualEffectStateActive;

        self.wantsLayer = YES;
        self.layer.backgroundColor = [ NSColor whiteColor ].CGColor;
        }

    return self;
    }

@end // ATCBeautifulView class
