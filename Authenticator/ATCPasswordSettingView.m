//
//  ATCPasswordSettingView.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCPasswordSettingView.h"

// ATCPasswordSettingView class
@implementation ATCPasswordSettingView

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        [ self configureForAutoLayout ];
        [ self autoSetDimensionsToSize: self.frame.size ];
        }

    return self;
    }

@end // ATCPasswordSettingView class