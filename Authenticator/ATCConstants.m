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
NSString* const ATCTotpBadgeViewShouldUpdateNotif = @"TotpBadgeView.Should.Update.Notif";
NSString* const ATCHintFieldShouldUpdateNotif = @"HintField.Should.Update.Notif";
NSString* const ATCShouldShowWarningsNotif = @"Should.ShowWarnings.Notif";

// User Info Key
NSString* const kTotpEntry = @"kTotpEntry";

// Constants
uint64_t const ATCFixedTimeStep = 30;
uint64_t const ATCWarningTimeStep = 5;

// Shared Hex HTML Color
NSString* const ATCHexNormalPINColor = @"52AAEE";
NSString* const ATCHexWarningPINColor = @"C85044";

inline NSColor* ATCNormalPINColor()
    {
    return [ NSColor colorWithHTMLColor: ATCHexNormalPINColor ];
    }

inline NSColor* ATCWarningPINColor()
    {
    return [ NSColor colorWithHTMLColor: ATCHexWarningPINColor ];
    }

inline NSColor* ATCAlternativeWarningPINColor()
    {
    return [ ATCWarningPINColor() colorWithAlphaComponent: .5f ];
    }

inline NSColor* ATCControlColor()
    {
    return [ [ NSColor colorWithHTMLColor: @"494B48" ] colorWithAlphaComponent: .85f ];
    }