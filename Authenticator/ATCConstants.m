//
//  ATCConstants.m
//  Authenticator
//
//  Created by Tong G. on 2/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCConstants.h"

// Notification Names
NSString* const ATCNewTotpEntryDidAddNotif = @"NewTotpEntry.DidAdd.Notif";
NSString* const ATCTotpEntryShouldUpdateNotif = @"TotpEntry.Should.Update.Notif";

// User Info Key
NSString* const kTotpEntry = @"kTotpEntry";

// Constants
uint64_t const ATCFixedTimeStep = 30;