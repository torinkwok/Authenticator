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
    // Fields of Scan Region
    CGPoint scanRegionUpperLeftCorner;
    CGPoint scanRegionUpperRightCorner;
    CGPoint scanRegionBottomLeftCorner;
    CGPoint scanRegionBottomRightCorner;

    NSRect scanRegion;
    double scanRegionFactor;

    // Fields of Auxiliary Line
    CGPoint leftAuxiliaryLineBeginPoint;
    CGPoint leftAuxiliaryLineEndPoint;

    CGPoint rightAuxiliaryLineBeginPoint;
    CGPoint rightAuxiliaryLineEndPoint;

    CGPoint topAuxiliaryLineBeginPoint;
    CGPoint topAuxiliaryLineEndPoint;

    CGPoint bottomAuxiliaryLineBeginPoint;
    CGPoint bottomAuxiliaryLineEndPoint;

    } ATCPaintStateStruct_;

// Private Interfaces
@interface ATCQRCodeScannerView ()
    {
@private
    ATCPaintStateStruct_ paintStates_;
    }

/* This method takes a snapshot image of the scan region on screen and return it.
 */
- ( CGImageRef ) takeSnapshot_;

/* Populate the displays_[]
 */
- ( void ) interrogateHardware_;

- ( void ) timerFired_: ( NSTimer* )_Timer;

@end // Private Interfaces

#define ATC_SCANNER_DEFAULT_WIDTH   250.f
#define ATC_SCANNER_DEFAULT_HEIGHT  250.f

// ATCQRCodeScannerView class
@implementation ATCQRCodeScannerView

#pragma mark - Initializations

- ( void ) awakeFromNib
    {
    currentCursorPoint_ = NSZeroPoint;
    paintStates_.scanRegionFactor = 1.f;
    [ self rederiveStatesStruct_ ];

    [ self interrogateHardware_ ];

    [ self setWantsLayer: YES ];

    [ self addTrackingArea: [ [ NSTrackingArea alloc ]
        initWithRect: self.bounds
             options: NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect
               owner: self
            userInfo: nil ] ];
    }

#pragma mark - Events Handling

- ( void ) rederiveStatesStruct_
    {
    paintStates_.scanRegionUpperRightCorner = currentCursorPoint_;

    paintStates_.scanRegionUpperLeftCorner =
        NSMakePoint( currentCursorPoint_.x - ATC_SCANNER_DEFAULT_WIDTH * paintStates_.scanRegionFactor
                   , currentCursorPoint_.y
                   );

    paintStates_.scanRegionBottomRightCorner =
        NSMakePoint( currentCursorPoint_.x
                   , currentCursorPoint_.y + ATC_SCANNER_DEFAULT_HEIGHT * paintStates_.scanRegionFactor
                   );

    paintStates_.scanRegionBottomLeftCorner =
        NSMakePoint( currentCursorPoint_.x - ATC_SCANNER_DEFAULT_WIDTH * paintStates_.scanRegionFactor
                   , currentCursorPoint_.y + ATC_SCANNER_DEFAULT_HEIGHT * paintStates_.scanRegionFactor
                   );

    paintStates_.scanRegion =
        NSMakeRect( paintStates_.scanRegionUpperLeftCorner.x
                  , paintStates_.scanRegionUpperLeftCorner.y
                  , ATC_SCANNER_DEFAULT_WIDTH * paintStates_.scanRegionFactor
                  , ATC_SCANNER_DEFAULT_HEIGHT * paintStates_.scanRegionFactor
                  );

    /*
                │
                a            
                │            
           .---(1)---.       
           |         |       
    ───d──(4)       (2)──b───
           |         |       
           |         |       
           .---(3)---.       
                │            
                c            
                │                
    */

    CGFloat unitedX = 0.f;
    CGFloat unitedY = 0.f;

    // (4) - d
    unitedY = paintStates_.scanRegionUpperLeftCorner.y + ( ATC_SCANNER_DEFAULT_HEIGHT * paintStates_.scanRegionFactor ) / 2;
    paintStates_.leftAuxiliaryLineBeginPoint = NSMakePoint( paintStates_.scanRegionUpperLeftCorner.x - 1.f, unitedY );
    paintStates_.leftAuxiliaryLineEndPoint = NSMakePoint( NSMinX( self.bounds ), unitedY );

    // (2) - b
    unitedY = paintStates_.scanRegionUpperRightCorner.y + ( ATC_SCANNER_DEFAULT_HEIGHT * paintStates_.scanRegionFactor ) / 2;
    paintStates_.rightAuxiliaryLineBeginPoint = NSMakePoint( paintStates_.scanRegionUpperRightCorner.x + 1.f, unitedY );
    paintStates_.rightAuxiliaryLineEndPoint = NSMakePoint( NSMaxX( self.bounds ), unitedY );

    // (3) - c
    unitedX = paintStates_.scanRegionBottomRightCorner.x - ( ATC_SCANNER_DEFAULT_WIDTH * paintStates_.scanRegionFactor ) / 2;
    paintStates_.bottomAuxiliaryLineBeginPoint = NSMakePoint( unitedX, paintStates_.scanRegionBottomRightCorner.y + 1 );
    paintStates_.bottomAuxiliaryLineEndPoint = NSMakePoint( unitedX, NSMaxY( self.bounds ) );

    // (1) - a
    unitedX = paintStates_.scanRegionUpperLeftCorner.x + ( ATC_SCANNER_DEFAULT_WIDTH * paintStates_.scanRegionFactor ) / 2;
    paintStates_.topAuxiliaryLineBeginPoint = NSMakePoint( unitedX, paintStates_.scanRegionUpperLeftCorner.y - 1 );
    paintStates_.topAuxiliaryLineEndPoint = NSMakePoint( unitedX, NSMinY( self.bounds ) );
    }

- ( void ) mouseEntered: ( NSEvent* )_Event
    {
    currentCursorPoint_ = [ self convertPoint: _Event.locationInWindow fromView: nil ];
    [ self rederiveStatesStruct_ ];

    self.needsDisplay = YES;

    [ NSCursor hide ];
    }

- ( void ) mouseExited: ( NSEvent* )_Event
    {
    [ NSCursor unhide ];
    }

- ( void ) mouseMoved: ( NSEvent* )_Event
    {
    [ timer invalidate ];
    timer = [ NSTimer timerWithTimeInterval: .5F target: self selector: @selector( timerFired_: ) userInfo: nil repeats: NO ];
    [ [ NSRunLoop currentRunLoop ] addTimer: timer forMode: NSRunLoopCommonModes ];

    currentCursorPoint_ = [ self convertPoint: _Event.locationInWindow fromView: nil ];
    [ self rederiveStatesStruct_ ];

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

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSBezierPath* scannerPath = [ NSBezierPath bezierPathWithRect: paintStates_.scanRegion ];

    scannerPath.lineWidth = 1.f;

    [ [ [ NSColor blackColor ] colorWithAlphaComponent: .5f ] setStroke ];
    [ [ [ NSColor whiteColor ] colorWithAlphaComponent: .1f ] setFill ];
    [ scannerPath stroke ];
    [ scannerPath fill ];

    NSBezierPath* auxiliaryLines = [ NSBezierPath bezierPath ];
    [ auxiliaryLines setLineWidth: 1.f ];

    [ auxiliaryLines moveToPoint: paintStates_.leftAuxiliaryLineBeginPoint ];
    [ auxiliaryLines lineToPoint: paintStates_.leftAuxiliaryLineEndPoint ];

    [ auxiliaryLines moveToPoint: paintStates_.rightAuxiliaryLineBeginPoint ];
    [ auxiliaryLines lineToPoint: paintStates_.rightAuxiliaryLineEndPoint ];

    [ auxiliaryLines moveToPoint: paintStates_.topAuxiliaryLineBeginPoint ];
    [ auxiliaryLines lineToPoint: paintStates_.topAuxiliaryLineEndPoint ];

    [ auxiliaryLines moveToPoint: paintStates_.bottomAuxiliaryLineBeginPoint ];
    [ auxiliaryLines lineToPoint: paintStates_.bottomAuxiliaryLineEndPoint ];

    [ auxiliaryLines stroke ];
    }

#pragma mark - Private Interfaces

/* This method takes a snapshot image of the scan region on screen and return it.
 */
- ( CGImageRef ) takeSnapshot_
    {
    /* Make a snapshot image of the current display. */
    CGImageRef cgScreenshotImage = CGDisplayCreateImageForRect( displays_[ 0 ], NSRectToCGRect( paintStates_.scanRegion ) );
    return cgScreenshotImage;
    }

/* Populate the displays_[]
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
    CGImageRef screenshot = [ self takeSnapshot_ ];

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