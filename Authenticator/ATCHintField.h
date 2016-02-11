//
//  ATCHintField.h
//  Authenticator
//
//  Created by Tong G. on 2/11/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Cocoa;

// ATCHintField class
@interface ATCHintField : NSTextField
    {
@protected
    NSAttributedString __strong* leadingHalf_;
    NSAttributedString __strong* middleHalf_;
    NSAttributedString __strong* trailingHalf_;
    }

@end // ATCHintField class
