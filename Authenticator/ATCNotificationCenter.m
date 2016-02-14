//
//  ATCNotificationCenter.m
//  Authenticator
//
//  Created by Tong G. on 2/10/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCNotificationCenter.h"

// Private Interfaces
@interface ATCNotificationCenter ()

// Timer Selector
- ( void ) timerFire_: ( NSTimer* )_Timer;

@end // Private Interfaces

// ATCNotificationCenter class
@implementation ATCNotificationCenter

#pragma mark - Initializations

ATCNotificationCenter static* sTimer;
+ ( instancetype ) sharedTimer
    {
    return [ [ self alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( !sTimer )
        {
        if ( self = [ super init ] )
            {
            currentRunLoop_ = [ NSRunLoop currentRunLoop ];
            sTimer = self;
            }
        }

    return sTimer;
    }

- ( void ) awakeFromNib
    {
    [ self startTiming ];
    }

#pragma mark - Timing

- ( void ) startTiming
    {
    if ( !timer_ )
        {
        timer_ = [ NSTimer timerWithTimeInterval: 1.f target: self selector: @selector( timerFire_: ) userInfo: nil repeats: YES ];
        [ currentRunLoop_ addTimer: timer_ forMode: NSRunLoopCommonModes ];
        }
    }

- ( void ) stopTiming
    {
    [ timer_ invalidate ];
    timer_ = nil;
    }

#pragma mark - Private

// Timer Selector
- ( void ) timerFire_: ( NSTimer* )_Timer
    {
    #if DEBUG
    NSLog( @"Timer Fired: %@ ~ remaining seconds for recalculation: %llu"
         , _Timer
         , [ AGClock remainingSecondsForRecalculation ]
         );
    #endif

    uint64_t remainingSec = [ AGClock remainingSecondsForRecalculation ];

    if ( ( YES ) )
        [ self postNotificationOnBehalfOfMeWithName: ATCHintFieldShouldUpdateNotif ];

    if ( remainingSec == ATCWarningTimeStep )
        [ self postNotificationOnBehalfOfMeWithName: ATCShouldShowWarningsNotif ];

    if ( remainingSec == ATCFixedTimeStep )
        [ self postNotificationOnBehalfOfMeWithName: ATCTotpBadgeViewShouldUpdateNotif ];
    }

@end // ATCNotificationCenter class
