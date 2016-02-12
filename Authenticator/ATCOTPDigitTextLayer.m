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
                             delegate: ( id )_Delegate
    {
    if ( self = [ super initWithTextString: _TextString delegate: _Delegate ] )
        {
        self.string = _TextString;

        self.fontSize = 30.f;
        self.font = ( __bridge CFTypeRef _Nullable )( [ NSFont fontWithName: @"Courier New Regular" size: self.fontSize ] );
        self.foregroundColor = [ NSColor whiteColor ].CGColor;
        self.alignmentMode = kCAAlignmentCenter;
        }

    return self;
    }

#pragma mark - Drawing

- ( void ) drawInContext: ( CGContextRef )_Ctx
    {
    // TODO:
    }

@end // ATCOTPDigitTextLayer class
