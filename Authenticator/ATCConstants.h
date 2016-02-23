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
NSString extern* const ATCWillScanQRCodeOnScreenNotif;
NSString extern* const ATCDidScanQRCodeOnScreenNotif;

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
NSURL* ATCImportedVaultsDirURL();
NSURL* ATCTemporaryDirURL();

NSString extern* const ATCTotpAuthURLTemplate;

NSString extern* const ATCUnitedTypeIdentifier;