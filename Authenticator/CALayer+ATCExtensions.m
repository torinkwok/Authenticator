//
//  CALayer+ATCExtensions.m
//  Authenticator
//
//  Created by Tong G. on 2/12/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "CALayer+ATCExtensions.h"

// CALayer + ATCExtensions
@implementation CALayer ( ATCExtensions )

#pragma mark - Initializations

- ( instancetype ) initWithTextString: ( NSString* )_TextString delegate: ( id )_Delegate
    {
    if ( self = [ super init ] )
        {
        if ( [ self isKindOfClass: [ CATextLayer class ] ] )
            [ ( CATextLayer* )self setString: _TextString ];

        self.delegate = _Delegate;
        }

    return self;
    }

- ( instancetype ) initWithTextString: ( NSString* )_TextString
    {
    return [ [ [ self class ] alloc ] initWithTextString: _TextString delegate: nil ];
    }

@end // CALayer + ATCExtensions