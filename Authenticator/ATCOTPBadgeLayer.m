//
//  ATCOTPBadgeLayer.m
//  Authenticator
//
//  Created by Tong G. on 2/12/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPBadgeLayer.h"
#import "ATCOTPDigitLayer.h"

// ATCOTPBadgeLayer class
@implementation ATCOTPBadgeLayer

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
//        self.backgroundColor = [ NSColor blueColor ].CGColor;

        for ( int _Index = 0; _Index < 6; _Index++ )
            [ digitLayers_ addObject: [ [ ATCOTPDigitLayer alloc ] initWithTextString: @"0" delegate: self ] ];

        [ self addSublayer: digitLayers_.firstObject ];
        }

    return self;
    }

@end // ATCOTPBadgeLayer class