//
//  AGCClock+ATCExtensions.h
//  Authenticator
//
//  Created by Tong G. on 2/11/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "AGClock.h"

// AGClock + ATCExtensions
@interface AGClock ( ATCExtensions )

#pragma mark - Countdown

@property ( assign, readonly ) uint64_t remainingSecondsForRecalculation;

@end // AGClock + ATCExtensions
