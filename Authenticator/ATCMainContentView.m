//
//  ATCMainContentView.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainContentView.h"

// ATCMainContentView class
@implementation ATCMainContentView

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        [ self configureForAutoLayout ];
        [ self setWantsLayer: YES ];
        }

    return self;
    }

#pragma mark - Drawing

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    
    // Drawing code here.
    }

@end // ATCMainContentView class
