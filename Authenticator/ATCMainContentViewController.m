//
//  ATCMainContentViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainContentViewController.h"
#import "ATCOTPEntry.h"
#import "ATCOTPEntryTableCellView.h"

// ATCMainContentViewController class
@implementation ATCMainContentViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    optEntries_ = [ NSMutableOrderedSet orderedSetWithObjects:
          [ [ ATCOTPEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"fdafjkjkga" ]
        , [ [ ATCOTPEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"fda843kq" ]
        , [ [ ATCOTPEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"quJJJLIKgjJf" ]
        , [ [ ATCOTPEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"OIKjfanKUTHfa" ]
        , nil ];

    // Do any additional setup after loading the view.
    }

- ( void ) setRepresentedObject: ( id )_RepresentedObject
    {
    [ super setRepresentedObject: _RepresentedObject ];

    // Update the view, if already loaded.
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
    return 89.f;
    }

- ( NSView* )tableView: ( NSTableView* )_TableView
    viewForTableColumn: ( NSTableColumn* )_TableColumn
                   row: ( NSInteger )_Row
    {
    ATCOTPEntryTableCellView* result = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];

    ATCOTPEntry* optEntry = [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ];

    NSDateFormatter* dateFormatter = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter setDateStyle: NSDateFormatterMediumStyle ];
    result.createdDateField.stringValue = optEntry.createdDate ? [ dateFormatter stringFromDate: optEntry.createdDate ] : @"";
    result.serviceNameField.stringValue = optEntry.serviceName.description ?: @"";
    result.userNameField.stringValue = optEntry.userName.description ?: @"";

    return result;
    }

@end // ATCMainContentViewController class