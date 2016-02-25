//
//  ATCNormalPresentationViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCNormalPresentationViewController.h"
#import "ATCOTPEntryTableCellView.h"
#import "ATCQRCodeScannerWindowController.h"

#import "ATCAuthVault.h"
#import "ATCAuthVaultItem.h"

// Private Interfaces
@interface ATCNormalPresentationViewController ()

// Notification Selector
- ( void ) newTotpEntryDidAdd: ( NSNotification* )_Notif;

@end // Private Interfaces

// ATCNormalPresentationViewController class
@implementation ATCNormalPresentationViewController

#pragma mark - Initializations

- ( NSString* ) authVaultNeedsPasswordToUnlock:(ATCAuthVault *)_AuthVault
    {
    return [ ATCAuthVaultManager tmpMasterPassword ];
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    NSError* error = nil;
    otpEntries_ = [ NSMutableOrderedSet orderedSet ];

    authVault_ = [ ATCAuthVaultManager defaultAuthVaultInDefaultLocationWithPassword: [ ATCAuthVaultManager tmpMasterPassword ] error: &error ];
    if ( authVault_ )
        {
        authVault_.passwordSource = self;
        [ otpEntries_ addObjectsFromArray: [ authVault_ authVaultItemsWithError: &error ] ];
        [ self.optEntriesTableView reloadData ];
        }

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( finishScanningQRCodeOnScreen_: ) name: ATCFinishScanningQRCodeOnScreenNotif object: nil ];

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( newTotpEntryDidAdd: ) name: ATCNewTotpEntryDidAddNotif object: nil ];
    }

- ( void ) finishScanningQRCodeOnScreen_: ( NSNotification* )_Notif
    {
    NSURL* otpAuthURL = _Notif.userInfo[ kQRCodeContents ];
    if ( otpAuthURL )
        {
        NSArray* queries = [ otpAuthURL.query componentsSeparatedByString: @"&" ];
        NSMutableDictionary* queryDict = [ NSMutableDictionary dictionaryWithCapacity: queries.count ];

        for ( NSString* _Parameter in queries )
            {
            NSArray* components = [ _Parameter componentsSeparatedByString: @"=" ];
            [ queryDict addEntriesFromDictionary: @{ components.firstObject : components.lastObject } ];
            }

        NSString* issuer = queryDict[ @"issuer" ];
        NSString* secret = queryDict[ @"secret" ];

        NSMutableArray* pathComponents = [ otpAuthURL.pathComponents mutableCopy ];
        if ( [ pathComponents.firstObject isEqualToString: @"/" ] )
            [ pathComponents removeObjectAtIndex: 0 ];

        NSMutableString* accountName = [ [ pathComponents componentsJoinedByString: @"/" ] mutableCopy ];
        [ accountName replaceOccurrencesOfString: @" " withString: @"" options: 0 range: NSMakeRange( 0, accountName.length ) ];
        [ accountName replaceOccurrencesOfString: [ NSString stringWithFormat: @"%@:", issuer ] withString: @"" options: 0 range: NSMakeRange( 0, accountName.length ) ];

        #if __debug_QRCode_Scanner__
        NSLog( @"%@", otpAuthURL );
        NSLog( @"%@", queryDict );
        NSLog( @"%@", otpAuthURL.pathComponents );
        NSLog( @"%@", accountName );
        #endif

        ATCAuthVaultItem* newEntry = [ [ ATCAuthVaultItem alloc ] initWithIssuer: issuer accountName: accountName secretKey: secret ];
        [ otpEntries_ insertObject: newEntry atIndex: 0 ];
        [ authVault_ addAuthVaultItem: newEntry withMasterPassword: [ ATCAuthVaultManager tmpMasterPassword ] error: nil ];
        [ authVault_ writeToURL: [ ATCDefaultVaultsDirURL() URLByAppendingPathComponent: @"default.authvault" ] atomically: YES ];

        [ self.optEntriesTableView reloadData ];
        }
    }

- ( void ) setRepresentedObject: ( id )_RepresentedObject
    {
    [ super setRepresentedObject: _RepresentedObject ];

    // Update the view, if already loaded.
    }

#pragma mark - IBActions

- ( IBAction ) scanQRCodeOnScreenAction_: ( id )_Sender
    {
    if ( !QRCodeScannerWindow_ )
        QRCodeScannerWindow_ = [ [ ATCQRCodeScannerWindowController alloc ] initWithWindowNibName: @"ATCQRCodeScannerWindowController" ];

    [ [ NSNotificationCenter defaultCenter ]
        postNotificationName: ATCBeginScanningQRCodeOnScreenNotif object: self ];
    }

#pragma mark - Conforms to <NSTableViewDataSource>

- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return otpEntries_.count;
    }

- ( id )            tableView: ( NSTableView * )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    return [ otpEntries_ objectAtIndex: _Row ];
    }

#pragma mark - Conforms to <NSTableViewDelegate>

- ( CGFloat ) tableView: ( NSTableView* )_TableView
            heightOfRow: ( NSInteger )_Row
    {
    return 81.f;
    }

- ( NSView* )tableView: ( NSTableView* )_TableView
    viewForTableColumn: ( NSTableColumn* )_TableColumn
                   row: ( NSInteger )_Row
    {
    ATCTotpEntryTableCellView* result = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];

    ATCAuthVaultItem* optEntry = [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ];
    [ result setOptEntry: optEntry ];

    NSDateFormatter* dateFormatter = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter setDateStyle: NSDateFormatterMediumStyle ];
    result.createdDateField.stringValue = optEntry.createdDate ? [ dateFormatter stringFromDate: optEntry.createdDate ] : @"";
    result.serviceNameField.stringValue = optEntry.issuer.description ?: @"";
    result.userNameField.stringValue = optEntry.accountName.description ?: @"";

    return result;
    }

- ( BOOL ) tableView: ( NSTableView* )_TableView
     shouldSelectRow: ( NSInteger )_Row
    {
    return NO;
    }

#pragma mark - Private Interfaces

// Notification Selector
- ( void ) newTotpEntryDidAdd: ( NSNotification* )_Notif
    {
    ATCAuthVaultItem* newTotpEntry = _Notif.userInfo[ kTotpEntry ];
    if ( newTotpEntry )
        {
        [ otpEntries_ insertObject: newTotpEntry atIndex: 0 ];
        [ authVault_ addAuthVaultItem: newTotpEntry withMasterPassword: [ ATCAuthVaultManager tmpMasterPassword ] error: nil ];
        [ authVault_ writeToURL: [ ATCDefaultVaultsDirURL() URLByAppendingPathComponent: @"default.authvault" ] atomically: YES ];
        [ self.optEntriesTableView reloadData ];
        }
    }

@end // ATCNormalPresentationViewController class