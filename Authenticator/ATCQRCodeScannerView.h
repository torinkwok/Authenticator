//
//  ATCQRCodeScannerView.h
//  ScreenshotLab
//
//  Created by Tong G. on 2/22/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// ATCQRCodeScannerView class
@interface ATCQRCodeScannerView : NSView
    {
@protected
    CGFloat scannerInitialHeight_;
    CGFloat scannerInitialWidth_;

    NSTimer __strong* timer;

	/* displays_[] Quartz display ID's */
	CGDirectDisplayID* displays_;
    }

@end // ATCQRCodeScannerView class