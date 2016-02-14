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
        self.contentsScale = 2.0f;

        // self->digitsIndexes_
        NSMutableIndexSet* tmpMutableIndexSet = [ NSMutableIndexSet indexSet ];
        [ tmpMutableIndexSet addIndexesInRange: NSMakeRange( 0, 3 ) ];
        [ tmpMutableIndexSet addIndexesInRange: NSMakeRange( 4, 3 ) ];

        digitsIndexes_ = [ tmpMutableIndexSet copy ];

        // self->dashIndex_
        dashIndex_ = [ NSIndexSet indexSetWithIndex: 3 ];

        // self->digitLayers_
        digitLayers_ = [ NSMutableOrderedSet orderedSet ];

        for ( int _Index = 0; _Index < 6; _Index++ )
            [ digitLayers_ addObject: [ [ ATCOTPDigitLayer alloc ] initWithTextString: @"-" ] ];

        dashLayer_ = [ [ CALayer alloc ] init ];
        dashLayer_.backgroundColor = [ NSColor lightGrayColor ].CGColor;
        dashLayer_.bounds = NSMakeRect( 0, 0, kDashWidth, 2 );

        [ digitLayers_ insertObjects: @[ dashLayer_ ] atIndexes: dashIndex_ ];

        // self->pinCode_
        pinCode_ = @"--- ---";
        }

    return self;
    }

CGFloat const kDigitsGap = 4.f;
CGFloat const kDashWidth = 8.f;

NSString* const kSuperLayerName = @"superlayer";
NSString* const kDigitLayerNameTemplate = @"digit-layer-%lu";

- ( void ) layoutSublayers
    {
    [ super layoutSublayers ];

    self.layoutManager = [ CAConstraintLayoutManager layoutManager ];

    NSView* del = self.delegate;
    CGFloat digitWidth = ( NSWidth( del.frame ) - kDigitsGap * 6 - kDashWidth * 2 ) / 6;
    CGFloat digitHeight = NSHeight( del.frame ) - 10.f;

    [ digitLayers_ enumerateObjectsUsingBlock:
        ^( CALayer* _Nonnull _DigitLayer, NSUInteger _Index, BOOL* _Nonnull _Stop )
            {
            _DigitLayer.name = [ NSString stringWithFormat: kDigitLayerNameTemplate, _Index ];

            NSSize size = NSZeroSize;
            if ( _Index != dashIndex_.firstIndex )
                size = NSMakeSize( digitWidth, digitHeight );
            else
                size = NSMakeSize( kDashWidth, 2.f );

            [ _DigitLayer setBounds: NSMakeRect( 0, 0, size.width, size.height ) ];

            if ( _Index == 0 )
                [ _DigitLayer addConstraint:
                    [ CAConstraint constraintWithAttribute: kCAConstraintMinX
                                                relativeTo: kSuperLayerName
                                                 attribute: kCAConstraintMinX ] ];
            else
                [ _DigitLayer addConstraint:
                    [ CAConstraint constraintWithAttribute: kCAConstraintMinX
                                                relativeTo: [ NSString stringWithFormat: kDigitLayerNameTemplate, _Index - 1 ]
                                                 attribute: kCAConstraintMaxX
                                                    offset: kDigitsGap ] ];

            [ _DigitLayer addConstraint:
                [ CAConstraint constraintWithAttribute: kCAConstraintMidY relativeTo: kSuperLayerName attribute: kCAConstraintMidY ] ];

            [ self addSublayer: _DigitLayer ];
            } ];
    }

#pragma mark - Dynamic Properties

- ( void ) setPinCode: ( NSString* )_PinCode
    {
    NSMutableString* tmpMutablePIN = [ _PinCode mutableCopy ];
    [ tmpMutablePIN insertString: @" " atIndex: dashIndex_.firstIndex ];
    pinCode_ = [ tmpMutablePIN copy ];

    [ digitLayers_ enumerateObjectsAtIndexes: digitsIndexes_
                                     options: NSEnumerationConcurrent
                                  usingBlock:
        ^( CALayer* _Nonnull _Layer, NSUInteger _Index, BOOL* _Nonnull _Stop )
            {
            [ ( ATCOTPDigitLayer* )_Layer setDigitString:
                [ pinCode_ substringWithRange: NSMakeRange( _Index, 1 ) ] ];
            } ];
    }

- ( NSString* ) pinCode
    {
    return pinCode_;
    }

@end // ATCOTPBadgeLayer class