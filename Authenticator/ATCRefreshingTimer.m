//
//  ATCRefreshingTimer.m
//  Authenticator
//
//  Created by Tong G. on 2/10/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCRefreshingTimer.h"

// Private Interfaces
@interface ATCRefreshingTimer ()

// Timer Selector
- ( void ) timerFire_: ( NSTimer* )_Timer;

@end // Private Interfaces

// ATCRefreshingTimer class
@implementation ATCRefreshingTimer

#pragma mark - Initializations

ATCRefreshingTimer static* sTimer;
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
        [ currentRunLoop_ addTimer: timer_ forMode: NSDefaultRunLoopMode ];
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
//    NSLog( @"Timer Fired: %@", _Timer );
    #endif

    [ [ NSNotificationCenter defaultCenter ]
        postNotificationName: ATCTotpEntryShouldUpdateNotif object: self ];
    }

@end // ATCRefreshingTimer class
