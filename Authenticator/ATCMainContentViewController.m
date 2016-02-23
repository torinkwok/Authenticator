//
//  ATCMainContentViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainContentViewController.h"
#import "ATCTotpEntry.h"
#import "ATCOTPEntryTableCellView.h"
#import "ATCQRCodeScannerWindowController.h"

// Private Interfaces
@interface ATCMainContentViewController ()

// Notification Selector
- ( void ) newTotpEntryDidAdd: ( NSNotification* )_Notif;

@end // Private Interfaces

// ATCMainContentViewController class
@implementation ATCMainContentViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    optEntries_ = [ NSMutableOrderedSet orderedSetWithObjects:
          [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"uqgrz4nub4tz5zwn" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"HackerNews" userName: @"TongKuo" secret: @"gshnvjezgtcbfagh" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Evernote" userName: @"TongKuo" secret: @"uzwyuhkjvsv2lnaj" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"6kxcnplgdk52y47m" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"dznyivy5pcf5si64" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"3v7ptpbjedv3ivof" ]

        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"uqgrz4nub4tz5zwn" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"HackerNews" userName: @"TongKuo" secret: @"gshnvjezgtcbfagh" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Evernote" userName: @"TongKuo" secret: @"uzwyuhkjvsv2lnaj" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"6kxcnplgdk52y47m" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"dznyivy5pcf5si64" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"3v7ptpbjedv3ivof" ]

        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"uqgrz4nub4tz5zwn" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"HackerNews" userName: @"TongKuo" secret: @"gshnvjezgtcbfagh" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Evernote" userName: @"TongKuo" secret: @"uzwyuhkjvsv2lnaj" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"6kxcnplgdk52y47m" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"dznyivy5pcf5si64" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"3v7ptpbjedv3ivof" ]

        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"uqgrz4nub4tz5zwn" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"HackerNews" userName: @"TongKuo" secret: @"gshnvjezgtcbfagh" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Evernote" userName: @"TongKuo" secret: @"uzwyuhkjvsv2lnaj" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"6kxcnplgdk52y47m" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"dznyivy5pcf5si64" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"3v7ptpbjedv3ivof" ]

        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"uqgrz4nub4tz5zwn" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"HackerNews" userName: @"TongKuo" secret: @"gshnvjezgtcbfagh" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Evernote" userName: @"TongKuo" secret: @"uzwyuhkjvsv2lnaj" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"6kxcnplgdk52y47m" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"dznyivy5pcf5si64" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"3v7ptpbjedv3ivof" ]

        , nil ];

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( newTotpEntryDidAdd: ) name: ATCNewTotpEntryDidAddNotif object: nil ];

    [ self.optEntriesTableView reloadData ];

    // Do any additional setup after loading the view.
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

    [ self.view.window orderOut: self ];
    [ QRCodeScannerWindow_.window makeKeyAndOrderFront: self ];
    }

#pragma mark - Conforms to <NSTableViewDataSource>

- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return optEntries_.count;
    }

- ( id )            tableView: ( NSTableView * )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    return [ optEntries_ objectAtIndex: _Row ];
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

    ATCTotpEntry* optEntry = [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ];
    [ result setOptEntry: optEntry ];

    NSDateFormatter* dateFormatter = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter setDateStyle: NSDateFormatterMediumStyle ];
    result.createdDateField.stringValue = optEntry.createdDate ? [ dateFormatter stringFromDate: optEntry.createdDate ] : @"";
    result.serviceNameField.stringValue = optEntry.serviceName.description ?: @"";
    result.userNameField.stringValue = optEntry.userName.description ?: @"";

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
    ATCTotpEntry* newTotpEntry = _Notif.userInfo[ kTotpEntry ];
    if ( newTotpEntry )
        {
        [ optEntries_ insertObject: newTotpEntry atIndex: 0 ];
        [ self.optEntriesTableView reloadData ];
        }
    }

@end // ATCMainContentViewController class