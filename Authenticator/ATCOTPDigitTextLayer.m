//
//  ATCOTPDigitTextLayer.m
//  Authenticator
//
//  Created by Tong G. on 2/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPDigitTextLayer.h"

// ATCOTPDigitTextLayer class
@implementation ATCOTPDigitTextLayer

#pragma mark - Initializations

- ( instancetype ) initWithTextString: ( NSString* )_TextString
    {
    if ( self = [ super init ] )
        {
        self.string = _TextString;

        self.fontSize = 40.f;
        self.foregroundColor = [ NSColor whiteColor ].CGColor;
        self.alignmentMode = kCAAlignmentCenter;

        self.contentsScale = 2.0f;
        }

    return self;
    }

@end // ATCOTPDigitTextLayer class
