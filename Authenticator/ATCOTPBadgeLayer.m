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
        self.contentsScale = 2.0f;

    return self;
    }

CGFloat const kDigitsGap = 4.f;
CGFloat const kDashWidth = 8.f;

NSUInteger const kDashIndex = 3;

NSString* const kDigitLayerNameTemplate = @"digit-layer-%lu";

- ( void ) layoutSublayers
    {
    [ super layoutSublayers ];

    if ( !digitLayers_ )
        {
        digitLayers_ = [ NSMutableOrderedSet orderedSet ];

        self.layoutManager = [ CAConstraintLayoutManager layoutManager ];

        for ( int _Index = 0; _Index < 6; _Index++ )
            [ digitLayers_ addObject: [ [ ATCOTPDigitLayer alloc ] initWithTextString: @"0" ] ];

        dashLayer_ = [ [ CALayer alloc ] init ];
        dashLayer_.backgroundColor = [ NSColor grayColor ].CGColor;
        dashLayer_.bounds = NSMakeRect( 0, 0, kDashWidth, 2 );

        [ digitLayers_ insertObject: dashLayer_ atIndex: kDashIndex ];

        NSView* del = self.delegate;
        CGFloat digitWidth = ( NSWidth( del.frame ) - kDigitsGap * 6 - kDashWidth * 2 ) / 6;
        CGFloat digitHeight = NSHeight( del.frame ) - 6.f;

        [ digitLayers_ enumerateObjectsUsingBlock:
            ^( CALayer* _Nonnull _DigitLayer, NSUInteger _Index, BOOL* _Nonnull _Stop )
                {
                _DigitLayer.name = [ NSString stringWithFormat: kDigitLayerNameTemplate, _Index ];

                if ( _Index != kDashIndex )
                    [ _DigitLayer setBounds: NSMakeRect( 0, 0, digitWidth, digitHeight ) ];
                else
                    [ _DigitLayer setBounds: NSMakeRect( 0, 0, kDashWidth, 2.f ) ];

                if ( _Index == 0 )
                    {
                    [ _DigitLayer addConstraint:
                        [ CAConstraint constraintWithAttribute: kCAConstraintMinX relativeTo: @"superlayer" attribute: kCAConstraintMinX ] ];
                    }
                else
                    {
                    NSString* sibling = [ NSString stringWithFormat: kDigitLayerNameTemplate, _Index - 1 ];

                    [ _DigitLayer addConstraint:
                        [ CAConstraint constraintWithAttribute: kCAConstraintMinX relativeTo: sibling attribute: kCAConstraintMaxX offset: kDigitsGap ] ];
                    }

                [ _DigitLayer addConstraint:
                    [ CAConstraint constraintWithAttribute: kCAConstraintMidY relativeTo: @"superlayer" attribute: kCAConstraintMidY ] ];

                [ self addSublayer: _DigitLayer ];
                } ];
        }
    }

@end // ATCOTPBadgeLayer class