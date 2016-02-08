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

// ATCMainContentViewController class
@implementation ATCMainContentViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    optEntries_ = [ NSMutableOrderedSet orderedSetWithObjects:
          [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"fdafjkjkga" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"fd2NNNkMa843kq" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"quJJJLIKgjJf" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"OIKjfanKUTHfa" ]
        , nil ];

    [ self.optEntriesTableView reloadData ];

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
//    NSLog( @"%ld", _Row );
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
    NSLog( @"%@", optEntry.secretString );
    [ result setOptEntry: optEntry ];

    NSDateFormatter* dateFormatter = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter setDateStyle: NSDateFormatterMediumStyle ];
    result.createdDateField.stringValue = optEntry.createdDate ? [ dateFormatter stringFromDate: optEntry.createdDate ] : @"";
    result.serviceNameField.stringValue = optEntry.serviceName.description ?: @"";
    result.userNameField.stringValue = optEntry.userName.description ?: @"";

    return result;
    }

@end // ATCMainContentViewController class