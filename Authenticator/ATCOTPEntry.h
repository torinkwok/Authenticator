//
//  ATCOTPEntry.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Foundation;

// ATCOTPEntry class
@interface ATCOTPEntry : NSObject

@property ( strong, readonly ) NSDate* createdDate;
@property ( strong, readonly ) NSString* serviceName;
@property ( strong, readonly ) NSString* userName;

@property ( strong, readonly ) NSString* secretString;

#pragma mark - Initializations

- ( instancetype ) initWithServiceName: ( NSString* )_ServiceName
                              userName: ( NSString* )_UserName
                                secret: ( NSString* )_Secret;

@end // ATCOTPEntry class
