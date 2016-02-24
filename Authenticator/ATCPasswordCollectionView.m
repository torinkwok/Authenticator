//
//  ATCPasswordCollectionView.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCPasswordCollectionView.h"

// ATCPasswordCollectionView class
@implementation ATCPasswordCollectionView

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        [ self configureForAutoLayout ];
        [ self autoSetDimensionsToSize: self.frame.size ];

        [ self setWantsLayer: YES ];
        }

    return self;
    }

@end // ATCPasswordCollectionView class