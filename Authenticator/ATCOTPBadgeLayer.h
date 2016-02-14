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
    NSIndexSet __strong* digitsIndexes_;
    NSIndexSet __strong* dashIndex_;

    NSMutableOrderedSet <CALayer*> __strong* digitLayers_;

    CALayer __strong* dashLayer_;

    NSString __strong* pinCode_;
    BOOL isInWarning_;
    }

@property ( strong, readwrite ) NSString* pinCode;
@property ( assign, readwrite ) BOOL isInWarning;

@end // ATCOTPBadgeLayer class