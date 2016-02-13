//
//  ATCHintField.m
//  Authenticator
//
//  Created by Tong G. on 2/11/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCHintField.h"

// Private Interfaces
@interface ATCHintField ()
    {
    uint64_t remainingSeconds_;
    }

@property ( assign, readwrite ) uint64_t remainingSeconds_;

- ( void ) hintFieldShouldUpdate_: ( NSNotification* )_Notif;
- ( void ) calculateCurrentRemainingSeconds_;

@end // Private Interfaces

// ATCHintField class
@implementation ATCHintField

#pragma mark - Initializations;

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self.editable = NO;
        self.selectable = NO;
        self.bordered = NO;
        self.drawsBackground = NO;
        self.font = [ NSFont fontWithName: @"Helvetica Neue Light" size: 20.f ];
        self.textColor = ATCControlColor();

        leadingHalf_ = [ [ NSAttributedString alloc ] initWithString: @"Your tokens expire in " ];
        middleHalf_ = [ [ NSAttributedString alloc ] initWithString: @"-1" ];
        trailingHalf_ = [ [ NSAttributedString alloc ] initWithString: @" seconds" ];

        [ self calculateCurrentRemainingSeconds_ ];

        [ [ NSNotificationCenter defaultCenter ]
            addObserver: self selector: @selector( hintFieldShouldUpdate_: ) name: ATCHintFieldShouldUpdateNotif object: nil ];
        }

    return self;
    }

#pragma mark - Private Interfaces

@dynamic remainingSeconds_;

- ( uint64_t ) remainingSeconds_
    {
    return remainingSeconds_;
    }

- ( void ) setRemainingSeconds_: ( uint64_t )_New
    {
    NSMutableAttributedString* attributedString = [ [ NSMutableAttributedString alloc ] initWithString: @"" ];

    middleHalf_ = [ [ NSAttributedString alloc ]
        initWithString: ( _New < 10 ) ? [ NSString stringWithFormat: @"0%llu", _New ] : @( _New ).stringValue
            attributes: @{ NSForegroundColorAttributeName
                            : ( _New > ATCWarningTimeStep ) ? ATCNormalPINColor() : ATCWarningPINColor() } ];

    [ attributedString appendAttributedString: leadingHalf_ ];
    [ attributedString appendAttributedString: middleHalf_ ];
    [ attributedString appendAttributedString: trailingHalf_ ];

    [ attributedString setAlignment: NSCenterTextAlignment range: NSMakeRange( 0, attributedString.length ) ];

    self.attributedStringValue = attributedString;
    }

- ( void ) hintFieldShouldUpdate_: ( NSNotification* )_Notif
    {
    [ self calculateCurrentRemainingSeconds_ ];
    }

- ( void ) calculateCurrentRemainingSeconds_
    {
    [ self setRemainingSeconds_: [ AGClock remainingSecondsForRecalculation ] ];
    }

@end
