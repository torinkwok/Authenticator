//
//  ATCOTPDigitLayer.m
//  Authenticator
//
//  Created by Tong G. on 2/12/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPDigitLayer.h"
#import "ATCOTPDigitTextLayer.h"

// ATCOTPDigitLayer class
@implementation ATCOTPDigitLayer

#pragma mark - Initializations

- ( instancetype ) initWithTextString: ( NSString* )_TextString
    {
    if ( self = [ super init ] )
        {
        self.layoutManager = [ CAConstraintLayoutManager layoutManager ];

        self.cornerRadius = 6.f;
        self.backgroundColor = ATCNormalPINColor().CGColor;

        digitTextLayer_ = [ [ ATCOTPDigitTextLayer alloc ] initWithTextString: _TextString ];

        NSString* superlayer = @"superlayer";

        [ digitTextLayer_ addConstraint:
            [ CAConstraint constraintWithAttribute: kCAConstraintMidY relativeTo: superlayer attribute: kCAConstraintMidY offset: 2.f ] ];

        [ digitTextLayer_ addConstraint:
            [ CAConstraint constraintWithAttribute: kCAConstraintMidX relativeTo: superlayer attribute: kCAConstraintMidX ] ];

        [ self addSublayer: digitTextLayer_ ];

        self.contentsScale = 2.0f;
        }

    return self;
    }

@end // ATCOTPDigitLayer class