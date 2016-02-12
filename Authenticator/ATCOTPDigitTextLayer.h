//
//  ATCOTPDigitTextLayer.h
//  Authenticator
//
//  Created by Tong G. on 2/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import QuartzCore;

// ATCOTPDigitTextLayer class
@interface ATCOTPDigitTextLayer : CATextLayer

#pragma mark - Initializations

- ( instancetype ) initWithTextString: ( NSString* )_TextString delegate: ( id )_Delegate;
- ( instancetype ) initWithTextString: ( NSString* )_TextString;

@end // ATCOTPDigitTextLayer class
