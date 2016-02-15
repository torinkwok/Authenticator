//
//  ATCConstants.h
//  Authenticator
//
//  Created by Tong G. on 2/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// Notification Names
NSString extern* const ATCNewTotpEntryDidAddNotif;
NSString extern* const ATCTotpBadgeViewShouldUpdateNotif;
NSString extern* const ATCHintFieldShouldUpdateNotif;
NSString extern* const ATCShouldShowWarningsNotif;

// User Info Key
NSString extern* const kTotpEntry;

// Constants
uint64_t extern const ATCFixedTimeStep;
uint64_t extern const ATCWarningTimeStep;

// Shared Hex HTML Colorn
NSString extern* const ATCHexNormalPINColor;
NSString extern* const ATCHexWarningPINColor;

NSColor* ATCNormalPINColor();
NSColor* ATCWarningPINColor();
NSColor* ATCAlternativeWarningPINColor();
NSColor* ATCControlColor();

NSURL* ATCVaultsDirURL();
NSURL* ATCDefaultVaultsDirURL();
NSURL* ATCImportedVaultsURL();

NSString extern* const ATCTotpAuthURLTemplate;