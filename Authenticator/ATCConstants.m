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
NSString* const ATCBeginScanningQRCodeOnScreenNotif = @"Begin.ScanningQRCodeOnScreen.Notif";
NSString* const ATCFinishScanningQRCodeOnScreenNotif = @"Finish.ScanningQRCodeOnScreen.Notif";

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

NSFileManager static* sFileManager;
inline NSURL* ATCVaultsDirURL()
    {
    dispatch_once_t static onceToken;

    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    sFileManager = [ [ NSFileManager alloc ] init ];
                    } );

    NSError* error = nil;
    NSURL* vaultsDirURL = nil;

    NSURL* sandboxedLibDirURL = [ sFileManager
        URLForDirectory: NSLibraryDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: YES error: &error ];

    if ( sandboxedLibDirURL )
        {
        vaultsDirURL = [ sandboxedLibDirURL URLByAppendingPathComponent:
            [ NSString stringWithFormat: @"Application Support/%@/Vaults", @"Authenticator" ] ];

        [ sFileManager createDirectoryAtURL: vaultsDirURL withIntermediateDirectories: YES attributes: nil error: &error ];
        }

    if ( error )
        NSLog( @"Failed to created general Vaults dir in %s: %@", __PRETTY_FUNCTION__, error );

    return vaultsDirURL;
    }

NSURL* ATCDefaultVaultsDirURL()
    {
    NSError* error = nil;
    NSURL* defaultVaultsDir = [ ATCVaultsDirURL() URLByAppendingPathComponent: @"Defaults" ];
    [ sFileManager createDirectoryAtURL: defaultVaultsDir withIntermediateDirectories: YES attributes: nil error: &error ];

    if ( error )
        NSLog( @"Failed to created default Vaults dir in %s: %@", __PRETTY_FUNCTION__, error );

    return defaultVaultsDir;
    }

NSURL* ATCImportedVaultsDirURL()
    {
    NSError* error = nil;
    NSURL* importedVaultsDir = [ ATCVaultsDirURL() URLByAppendingPathComponent: @"Imported" ];
    [ sFileManager createDirectoryAtURL: importedVaultsDir withIntermediateDirectories: YES attributes: nil error: nil ];

    if ( error )
        NSLog( @"Failed to created imported Vaults dir in %s: %@", __PRETTY_FUNCTION__, error );

    return importedVaultsDir;
    }

NSURL* ATCTemporaryDirURL()
    {
    NSError* error = nil;
    NSURL* tmpURL = [ [ NSFileManager defaultManager ] URLForDirectory: NSCachesDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: YES error: &error ];

    if ( error )
        NSLog( @"Failed to created tmp dir in %s: %@", __PRETTY_FUNCTION__, error );

    return tmpURL;
    }

NSString* const ATCTotpAuthURLTemplate = @"otpauth://totp/%@%@?secret=%@&issuer=%@";

NSString* const ATCUnitedTypeIdentifier = @"home.bedroom.TongKuo.Authenticator.AuthVault";