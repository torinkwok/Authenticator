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

@dynamic remainingSecondsForRecalculation;

- ( uint64_t ) remainingSecondsForRecalculation
    {
    return 30 - ( ( uint64_t )[ self.date timeIntervalSince1970 ] % 30 );
    }

@end // AGClock + ATCExtensions
