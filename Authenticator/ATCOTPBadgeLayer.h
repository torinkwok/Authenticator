//
//  ATCOTPBadgeLayer.h
//  Authenticator
//
//  Created by Tong G. on 2/12/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class ATCOTPDigitLayer;

// ATCOTPBadgeLayer class
@interface ATCOTPBadgeLayer : CALayer
    {
@protected
    NSMutableOrderedSet <ATCOTPDigitLayer*> __strong* digitLayers_;
    }

@end // ATCOTPBadgeLayer class