//
//  CALayer+ATCExtensions.h
//  Authenticator
//
//  Created by Tong G. on 2/12/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// CALayer + ATCExtensions
@interface CALayer ( ATCExtensions )

#pragma mark - Initializations

- ( instancetype ) initWithTextString: ( NSString* )_TextString delegate: ( id )_Delegate;
- ( instancetype ) initWithTextString: ( NSString* )_TextString;

@end // CALayer + ATCExtensions