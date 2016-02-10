//
//  ATCTimer.m
//  Authenticator
//
//  Created by Tong G. on 2/10/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCTimer.h"

// Private Interfaces
@interface ATCTimer ()

// Timer Selector
- ( void ) timerFire_: ( NSTimer* )_Timer;

@end // Private Interfaces

// ATCTimer class
@implementation ATCTimer

#pragma mark - Initializations

ATCTimer static* sTimer;
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
            timer_ = [ NSTimer timerWithTimeInterval: 1.f target: self selector: @selector( timerFire_: ) userInfo: nil repeats: YES ];
            sTimer = self;
            }
        }

    return sTimer;
    }

- ( void ) awakeFromNib
    {
    NSRunLoop* runLoop = [ NSRunLoop currentRunLoop ];
    [ runLoop addTimer: timer_ forMode: NSDefaultRunLoopMode ];
    }

#pragma mark - Private

// Timer Selector
- ( void ) timerFire_: ( NSTimer* )_Timer
    {
    #if DEBUG
    NSLog( @"Timer Fired: %@", _Timer );
    #endif

    [ [ NSNotificationCenter defaultCenter ]
        postNotificationName: ATCTotpEntryShouldUpdateNotif object: self ];
    }

@end // ATCTimer class
