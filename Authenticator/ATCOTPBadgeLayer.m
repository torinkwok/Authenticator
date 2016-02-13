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
CGFloat const kDigitGroupsGap = 15.f;
CGFloat const kDashWidth = kDigitGroupsGap - kDigitsGap;

- ( void ) layoutSublayers
    {
    [ super layoutSublayers ];

    if ( !digitLayers_ )
        {
        digitLayers_ = [ NSMutableOrderedSet orderedSet ];

        self.layoutManager = [ CAConstraintLayoutManager layoutManager ];

        for ( int _Index = 0; _Index < 6; _Index++ )
            [ digitLayers_ addObject: [ [ ATCOTPDigitLayer alloc ] initWithTextString: @"0" ] ];

        NSView* del = self.delegate;
        CGFloat digitWidth = ( NSWidth( del.frame ) - kDigitsGap * 4 - kDigitGroupsGap ) / 6;
        CGFloat digitHeight = NSHeight( del.frame ) - 6.f;

        [ digitLayers_ enumerateObjectsUsingBlock:
            ^( ATCOTPDigitLayer* _Nonnull _DigitLayer, NSUInteger _Index, BOOL* _Nonnull _Stop )
                {
                _DigitLayer.name = [ NSString stringWithFormat: @"digit-layer-%lu", _Index ];

                [ _DigitLayer setBounds: NSMakeRect( 0, 0, digitWidth, digitHeight ) ];

                if ( _Index == 0 )
                    {
                    [ _DigitLayer addConstraint:
                        [ CAConstraint constraintWithAttribute: kCAConstraintMinX relativeTo: @"superlayer" attribute: kCAConstraintMinX ] ];
                    }
                else
                    {
                    NSString* sibling = [ NSString stringWithFormat: @"digit-layer-%lu", _Index - 1 ];

//                    if ( _Index == 3 )
//                        {
//                        if ( !dashLayer_ )
//                            {
//                            dashLayer_ = [ [ CALayer alloc ] init ];
//                            dashLayer_.backgroundColor = [ NSColor grayColor ].CGColor;
//                            dashLayer_.bounds = NSMakeRect( 0, 0, kDashWidth, 2 );
//                            }
//
//                        [ dashLayer_ addConstraint:
//                            [ CAConstraint constraintWithAttribute: kCAConstraintMinX relativeTo: sibling attribute: kCAConstraintMaxX offset: kDigitsGap ] ];
//
//                        [ dashLayer_ addConstraint:
//                            [ CAConstraint constraintWithAttribute: kCAConstraintMidY relativeTo: @"superlayer" attribute: kCAConstraintMidY ] ];
//
//                        [ self addSublayer: dashLayer_ ];
//                        }

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