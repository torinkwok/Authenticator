/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 _______    _             _                 _                 |██
|                (_______)  (_)           | |               | |                |██
|                    _ _ _ _ _ ____   ___ | |  _ _____  ____| |                |██
|                   | | | | | |  _ \ / _ \| |_/ ) ___ |/ ___)_|                |██
|                   | | | | | | |_| | |_| |  _ (| ____| |    _                 |██
|                   |_|\___/|_|  __/ \___/|_| \_)_____)_|   |_|                |██
|                             |_|                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "NSBezierPath+ATCExtensions.h"
#import "NSAffineTransform+ATCExtensions.h"

// NSBezierPath + ATCExtensions protocol
@implementation NSBezierPath ( ATCExtensions )

+ ( NSBezierPath* ) bezierPathWithRoundedRect: ( NSRect )_BaseRect
                    withRadiusOfTopLeftCorner: ( CGFloat )topLeft
                             bottomLeftCorner: ( CGFloat )bottomLeft
                               topRightCorner: ( CGFloat )topRight
                            bottomRightCorner: ( CGFloat )bottomRight
                                    isFlipped: ( BOOL )_IsFlipped
    {

    NSBezierPath* outlinePath = [ NSBezierPath bezierPath ];
    [ outlinePath moveToPoint: NSMakePoint( NSMinX( _BaseRect ) + bottomLeft, NSMinY( _BaseRect ) ) ];

    [ outlinePath lineToPoint: NSMakePoint( NSMaxX( _BaseRect ) - bottomRight, NSMinY( _BaseRect ) ) ];

    NSPoint rightBottomCorner = NSMakePoint( NSMaxX( _BaseRect ), NSMinY( _BaseRect ) );
    [ outlinePath curveToPoint: NSMakePoint( NSMaxX( _BaseRect ), NSMinY( _BaseRect ) + bottomRight )
                 controlPoint1: rightBottomCorner
                 controlPoint2: rightBottomCorner ];

    [ outlinePath lineToPoint: NSMakePoint( NSMaxX( _BaseRect ), NSMaxY( _BaseRect ) - topRight ) ];

    NSPoint righTopCorner = NSMakePoint( NSMaxX( _BaseRect ), NSMaxY( _BaseRect ) );
    [ outlinePath curveToPoint: NSMakePoint( NSMaxX( _BaseRect ) - topRight, NSMaxY( _BaseRect ) )
                 controlPoint1: righTopCorner
                 controlPoint2: righTopCorner ];

    [ outlinePath lineToPoint: NSMakePoint( NSMinX( _BaseRect ) + topLeft, NSMaxY( _BaseRect ) ) ];

    NSPoint leftTopCorner = NSMakePoint( NSMinX( _BaseRect ), NSMaxY( _BaseRect ) );
    [ outlinePath curveToPoint: NSMakePoint( NSMinX( _BaseRect ), NSMaxY( _BaseRect ) - topLeft )
                 controlPoint1: leftTopCorner
                 controlPoint2: leftTopCorner ];

    [ outlinePath lineToPoint: NSMakePoint( NSMinX( _BaseRect ), NSMinY( _BaseRect ) + bottomLeft ) ];

    NSPoint leftBottomCorner = NSMakePoint( NSMinX( _BaseRect ), NSMinY( _BaseRect ) );
    [ outlinePath curveToPoint: NSMakePoint( NSMinX( _BaseRect ) + bottomLeft, NSMinY( _BaseRect ) )
                 controlPoint1: leftBottomCorner
                 controlPoint2: leftBottomCorner ];

    if ( _IsFlipped )
        [ outlinePath transformUsingAffineTransform: [ NSAffineTransform flipTransformForRect: _BaseRect ] ];

    return outlinePath;
    }

@end // NSBezierPath + ATCExtensions protocol

/*=============================================================================┐
|                                                                              |
|                                        `-://++/:-`    ..                     |
|                    //.                :+++++++++++///+-                      |
|                    .++/-`            /++++++++++++++/:::`                    |
|                    `+++++/-`        -++++++++++++++++:.                      |
|                     -+++++++//:-.`` -+++++++++++++++/                        |
|                      ``./+++++++++++++++++++++++++++/                        |
|                   `++/++++++++++++++++++++++++++++++-                        |
|                    -++++++++++++++++++++++++++++++++`                        |
|                     `:+++++++++++++++++++++++++++++-                         |
|                      `.:/+++++++++++++++++++++++++-                          |
|                         :++++++++++++++++++++++++-                           |
|                           `.:++++++++++++++++++/.                            |
|                              ..-:++++++++++++/-                              |
|                             `../+++++++++++/.                                |
|                       `.:/+++++++++++++/:-`                                  |
|                          `--://+//::-.`                                      |
|                                                                              |
└=============================================================================*/