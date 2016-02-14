//
//  ATCOTPDigitLayer.h
//  Authenticator
//
//  Created by Tong G. on 2/12/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class ATCOTPDigitTextLayer;

// ATCOTPDigitLayer class
@interface ATCOTPDigitLayer : CALayer
    {
@protected
    ATCOTPDigitTextLayer __strong* digitTextLayer_;
    BOOL isInWarning_;
    }

@property ( strong, readwrite ) NSString* digitString;
@property ( assign, readwrite ) BOOL isInWarning;
@property ( assign, readonly ) BOOL shouldBecomeWarningState;

#pragma mark - Initializations

- ( instancetype ) initWithTextString: ( NSString* )_TextString;

@end // ATCOTPDigitLayer class