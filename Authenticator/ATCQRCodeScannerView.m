//
//  ATCQRCodeScannerView.m
//  ScreenshotLab
//
//  Created by Tong G. on 2/22/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCQRCodeScannerView.h"
#import "ZXingObjC.h"

typedef struct
    {
    CGPoint currentCursorLocation;

    CGPoint upperLeftCorner;
    CGPoint upperRightCorner;
    CGPoint bottomLeftCorner;
    CGPoint bottomRightCorner;
    } ATCLocationsStruct_;

// Private Interfaces
@interface ATCQRCodeScannerView ()
    {
    ATCLocationsStruct_ loc_;
    }

/* 
 A display item was selected from the Capture menu. This takes a
 a snapshot image of the screen and creates a new document window
 with the image.
*/
- ( CGImageRef ) screenshotInRect_: ( NSRect )_Rect;

/* Populate the Capture menu with a list of displays by iterating over all of the displays. 
 */
- ( void ) interrogateHardware_;

- ( void ) timerFired_: ( NSTimer* )_Timer;

@end // Private Interfaces

// ATCQRCodeScannerView class
@implementation ATCQRCodeScannerView

#pragma mark - Initializations

- ( void ) awakeFromNib
    {
    [ self interrogateHardware_ ];

    scannerInitialHeight_ = 250.f;
    scannerInitialWidth_ = 250.f;

    [ self setWantsLayer: YES ];

    [ self addTrackingArea: [ [ NSTrackingArea alloc ]
        initWithRect: self.bounds
             options: NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect
               owner: self
            userInfo: nil ] ];
    }

#pragma mark - Events Handling

- ( ATCLocationsStruct_ ) locStructBasedOnCurrentCursorLocation_: ( NSPoint )_CursorPoint
    {
    ATCLocationsStruct_ loc;
    loc.currentCursorLocation = _CursorPoint;

    loc.upperRightCorner = _CursorPoint;
    loc.upperLeftCorner = NSMakePoint( _CursorPoint.x - scannerInitialWidth_, _CursorPoint.y );
    loc.bottomRightCorner = NSMakePoint( _CursorPoint.x, _CursorPoint.y + scannerInitialHeight_ );
    loc.bottomLeftCorner = NSMakePoint( _CursorPoint.x - scannerInitialWidth_, _CursorPoint.y + scannerInitialHeight_ );

    return loc;
    }

- ( void ) mouseEntered: ( NSEvent* )_Event
    {
    currentCursorLocation_ = [ self convertPoint: _Event.locationInWindow fromView: nil ];
    scannerRect_ = NSMakeRect( currentCursorLocation_.x - scannerInitialWidth_
                             , currentCursorLocation_.y
                             , scannerInitialWidth_
                             , scannerInitialHeight_
                             );
    self.needsDisplay = YES;

    [ NSCursor hide ];
    }

- ( void ) mouseExited:(NSEvent *)theEvent
    {
    [ NSCursor unhide ];
    }

- ( void ) mouseMoved: ( NSEvent* )_Event
    {
    [ timer invalidate ];
    timer = [ NSTimer timerWithTimeInterval: .5F target: self selector: @selector( timerFired_: ) userInfo: nil repeats: NO ];
    [ [ NSRunLoop currentRunLoop ] addTimer: timer forMode: NSRunLoopCommonModes ];

    currentCursorLocation_ = [ self convertPoint: _Event.locationInWindow fromView: nil ];
    scannerRect_ = NSMakeRect( currentCursorLocation_.x - scannerInitialWidth_
                             , currentCursorLocation_.y
                             , scannerInitialWidth_
                             , scannerInitialHeight_
                             );
    self.needsDisplay = YES;
    }

- ( void ) mouseDown: ( NSEvent* )_Event
    {
    [ [ NSNotificationCenter defaultCenter ]
        postNotificationName: ATCFinishScanningQRCodeOnScreenNotif object: self ];
    }

#pragma mark - Drawing

- ( BOOL ) isFlipped
    {
    return YES;
    }

- ( void ) drawRect:(NSRect)dirtyRect
    {
    [ super drawRect: dirtyRect ];

    NSBezierPath* scannerPath = [ NSBezierPath bezierPathWithRect: scannerRect_ ];

    scannerPath.lineWidth = 1.f;

    [ [ [ NSColor blackColor ] colorWithAlphaComponent: .5f ] setStroke ];
    [ [ [ NSColor whiteColor ] colorWithAlphaComponent: .1f ] setFill ];
    [ scannerPath stroke ];
    [ scannerPath fill ];

    NSBezierPath* auxiliary = [ NSBezierPath bezierPath ];
    [ auxiliary setLineWidth: 1.f ];

    [ auxiliary moveToPoint: NSMakePoint( currentCursorLocation_.x - scannerInitialWidth_ - 1.f, currentCursorLocation_.y + scannerInitialHeight_ / 2 ) ];
    [ auxiliary lineToPoint: NSMakePoint( NSMinX( self.bounds ), currentCursorLocation_.y + scannerInitialHeight_ / 2 ) ];

    [ auxiliary moveToPoint: NSMakePoint( currentCursorLocation_.x + 1.f, currentCursorLocation_.y + scannerInitialHeight_ / 2 ) ];
    [ auxiliary lineToPoint: NSMakePoint( NSMaxX( self.bounds ), currentCursorLocation_.y + scannerInitialHeight_ / 2 ) ];

    [ auxiliary moveToPoint: NSMakePoint( currentCursorLocation_.x - scannerInitialWidth_ / 2, currentCursorLocation_.y + 1 + scannerInitialHeight_ ) ];
    [ auxiliary lineToPoint: NSMakePoint( currentCursorLocation_.x - scannerInitialWidth_ / 2, NSMaxY( self.bounds ) ) ];

    [ auxiliary moveToPoint: NSMakePoint( currentCursorLocation_.x - scannerInitialWidth_ / 2, currentCursorLocation_.y - 1 ) ];
    [ auxiliary lineToPoint: NSMakePoint( currentCursorLocation_.x - scannerInitialWidth_ / 2, NSMinY( self.bounds ) ) ];

    [ auxiliary stroke ];

    ATCLocationsStruct_ loc = [ self locStructBasedOnCurrentCursorLocation_: currentCursorLocation_ ];
    NSBezierPath* cursorPointPath = [ NSBezierPath bezierPathWithRect: NSMakeRect( loc.upperLeftCorner.x, loc.upperLeftCorner.y, 20, 20 ) ];
    [ cursorPointPath fill ];

    cursorPointPath = [ NSBezierPath bezierPathWithRect: NSMakeRect( loc.upperRightCorner.x, loc.upperRightCorner.y, 20, 20 ) ];
    [ cursorPointPath fill ];

    cursorPointPath = [ NSBezierPath bezierPathWithRect: NSMakeRect( loc.bottomRightCorner.x, loc.bottomRightCorner.y, 20, 20 ) ];
    [ cursorPointPath fill ];

    cursorPointPath = [ NSBezierPath bezierPathWithRect: NSMakeRect( loc.bottomLeftCorner.x, loc.bottomLeftCorner.y, 20, 20 ) ];
    [ cursorPointPath fill ];
    }

#pragma mark - Private Interfaces

/* 
 A display item was selected from the Capture menu. This takes a
 a snapshot image of the screen and creates a new document window
 with the image.
*/
- ( CGImageRef ) screenshotInRect_: ( NSRect )_Rect
    {
    /* Make a snapshot image of the current display. */
    CGImageRef cgImage = CGDisplayCreateImageForRect( displays_[ 0 ], NSRectToCGRect( _Rect ) );
    return cgImage;
    }

/* Populate the Capture menu with a list of displays by iterating over all of the displays. 
 */
- ( void ) interrogateHardware_
    {
	CGError				err = CGDisplayNoErr;
	CGDisplayCount		dspCount = 0;
    
    /* How many active displays do we have? */
    err = CGGetActiveDisplayList( 0, NULL, &dspCount );
    
	/* If we are getting an error here then their won't be much to display. */
    if ( err != CGDisplayNoErr )
        return;
	
	/* Maybe this isn't the first time though this function. */
	if ( displays_ != nil )
		free( displays_ );
    
	/* Allocate enough memory to hold all the display IDs we have. */
    displays_ = calloc( ( size_t )dspCount, sizeof( CGDirectDisplayID ) );
    
	// Get the list of active displays
    err = CGGetActiveDisplayList( dspCount
                                , displays_
                                , &dspCount
                                );
	
	/* More error-checking here. */
    if ( err != CGDisplayNoErr )
        {
        NSLog( @"Could not get active display list (%d)\n", err );
        return;
        }
    }

- ( void ) timerFired_: ( NSTimer* )_Timer
    {
    CGImageRef screenshot = [ self screenshotInRect_: scannerRect_ ];

    ZXLuminanceSource* source = [ [ ZXCGImageLuminanceSource alloc ] initWithCGImage: screenshot ];
    CFRelease( screenshot );

    ZXBinaryBitmap* bitmap = [ ZXBinaryBitmap binaryBitmapWithBinarizer: [ ZXHybridBinarizer binarizerWithSource: source ] ];

    NSError* error = nil;

    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints* hints = [ ZXDecodeHints hints ];
    hints.encoding = NSUTF8StringEncoding;
    [ hints addPossibleFormat: kBarcodeFormatQRCode ];
    [ hints addPossibleFormat: kBarcodeFormatCodabar ];

    ZXMultiFormatReader* reader = [ ZXMultiFormatReader reader ];
    ZXResult* result = [ reader decode: bitmap hints: hints error: &error ];

    if ( result )
        {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString* contents = result.text;
        NSURL* url = [ NSURL URLWithString: contents ];

        // The barcode format, such as a QR code or UPC-A
        ZXBarcodeFormat format = result.barcodeFormat;
        if ( format == kBarcodeFormatQRCode )
            {
            if ( [ url.scheme isEqualToString: @"otpauth" ]
                    && [ url.host isEqualToString: @"totp" ] )
                {
                [ [ NSNotificationCenter defaultCenter ]
                    postNotificationName: ATCFinishScanningQRCodeOnScreenNotif object: self userInfo: @{ kQRCodeContents : url } ];
                }
            }
        else
            {
            NSLog( @"\"%@\" is illegal", contents );
            }
        }
    else
        {
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
        NSLog( @"%@", error );
        printf( "\n" );
        }
    }

@end // ATCQRCodeScannerView class