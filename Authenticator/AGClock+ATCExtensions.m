//
//  AGCClock+ATCExtensions.m
//  Authenticator
//
//  Created by Tong G. on 2/11/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "AGClock+ATCExtensions.h"

// AGClock + ATCExtensions
@implementation AGClock ( ATCExtensions )

#pragma mark - Countdown

+ ( uint64_t ) remainingSecondsForRecalculation
    {
    return ( ATCFixedTimeStep - ( ( uint64_t )[ [ NSDate date ] timeIntervalSince1970 ] % ATCFixedTimeStep ) );
    }

@end // AGClock + ATCExtensions
