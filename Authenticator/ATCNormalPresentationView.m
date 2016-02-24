//
//  ATCNormalPresentationView.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCNormalPresentationView.h"

// ATCNormalPresentationView class
@implementation ATCNormalPresentationView

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        [ self configureForAutoLayout ];
        [ self setWantsLayer: YES ];
        }

    return self;
    }

- ( void ) drawRect:(NSRect)dirtyRect
    {
    [ super drawRect: dirtyRect ];
    [ [ NSColor orangeColor ] set ];

    NSLog( @"%@", NSStringFromRect( self.frame ) );
    NSRectFill( self.bounds );
    }

@end // ATCNormalPresentationView class