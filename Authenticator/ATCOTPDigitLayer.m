//
//  ATCOTPDigitLayer.m
//  Authenticator
//
//  Created by Tong G. on 2/12/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPDigitLayer.h"
#import "ATCOTPDigitTextLayer.h"

// Private Interfaces
@interface ATCOTPDigitLayer ()

// Notification Selectors
- ( void ) shouldRedraw_: ( NSNotification* )_Notif;

@end // Private Interfaces

// ATCOTPDigitLayer class
@implementation ATCOTPDigitLayer

#pragma mark - Initializations

- ( instancetype ) initWithTextString: ( NSString* )_TextString
    {
    if ( self = [ super init ] )
        {
        self.isInWarning = [ AGClock remainingSecondsForRecalculation ] < ATCWarningTimeStep;

        self.layoutManager = [ CAConstraintLayoutManager layoutManager ];
        self.cornerRadius = 6.f;

        digitTextLayer_ = [ [ ATCOTPDigitTextLayer alloc ] initWithTextString: _TextString ];

        NSString* superlayer = @"superlayer";

        [ digitTextLayer_ addConstraint:
            [ CAConstraint constraintWithAttribute: kCAConstraintMidY relativeTo: superlayer attribute: kCAConstraintMidY offset: 2.f ] ];

        [ digitTextLayer_ addConstraint:
            [ CAConstraint constraintWithAttribute: kCAConstraintMidX relativeTo: superlayer attribute: kCAConstraintMidX ] ];

        [ self addSublayer: digitTextLayer_ ];

        self.contentsScale = 2.0f;

        [ [ NSNotificationCenter defaultCenter ]
            addObserver: self selector: @selector( shouldRedraw_: ) name: ATCTotpBadgeViewShouldUpdateNotif object: nil ];

        [ [ NSNotificationCenter defaultCenter ]
            addObserver: self selector: @selector( shouldRedraw_: ) name: ATCShouldShowWarningsNotif object: nil ];
        }

    return self;
    }

#pragma mark - Dynamic Properties

@dynamic digitString;
@dynamic isInWarning;

- ( void ) setDigitString: ( NSString* )_DigitString
    {
    digitTextLayer_.string = _DigitString;
    }

- ( NSString* ) digitString
    {
    return digitTextLayer_.string;
    }

- ( void ) setIsInWarning: ( BOOL )_Flag
    {
    isInWarning_ = _Flag;
    self.backgroundColor = ( isInWarning_ ? ATCWarningPINColor() : ATCNormalPINColor() ).CGColor;
    }

- ( BOOL ) isInWarning
    {
    return isInWarning_;
    }

#pragma mark - Private Interfaces

// Notification Selectors
- ( void ) shouldRedraw_: ( NSNotification* )_Notif
    {
    if ( [ _Notif.name isEqualToString: ATCShouldShowWarningsNotif ] )
        self.isInWarning = YES;

    if ( [ AGClock remainingSecondsForRecalculation ] > ATCWarningTimeStep )
        self.isInWarning = NO;
    }

@end // ATCOTPDigitLayer class