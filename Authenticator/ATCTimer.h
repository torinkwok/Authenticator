//
//  ATCTimer.h
//  Authenticator
//
//  Created by Tong G. on 2/10/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Foundation;

// ATCTimer class
@interface ATCTimer : NSObject
    {
@private
    NSTimer __strong* timer_;
    }

#pragma mark - Initializations

+ ( instancetype ) sharedTimer;

@end // ATCTimer class
