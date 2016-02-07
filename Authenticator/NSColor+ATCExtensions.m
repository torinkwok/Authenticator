/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 ______                   _  _  _ _ _     _ _                 |██
|                (_____ \                 (_)(_)(_|_) |   (_) |                |██
|                 _____) )   _  ____ _____ _  _  _ _| |  _ _| |                |██
|                |  ____/ | | |/ ___) ___ | || || | | |_/ ) |_|                |██
|                | |    | |_| | |   | ____| || || | |  _ (| |_                 |██
|                |_|    |____/|_|   |_____)\_____/|_|_| \_)_|_|                |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ██████████████████████████████████████████████████████████████████████████████*/

#import "NSColor+ATCExtensions.h"

#define COMPARE_WITH_CASE_INSENSITIVE( _Lhs, _Rhs )                                 \
    ( [ _Lhs compare: _Rhs options: NSCaseInsensitiveSearch ] == NSOrderedSame )    \

// NSColor + ATCExtensions protocol
@implementation NSColor ( ATCExtensions )

BOOL isCharInAtoE( NSString* );
NSUInteger mapHexAlphaToDecimalNumeric( NSString* _AlphaInHexNumeric );

+ ( NSColor* ) colorWithHTMLColor: ( NSString* )_HTMLColor
    {
    NSColor* color = nil;

    NSString* colorString = nil;
    if ( _HTMLColor.length == 6 )
        colorString = _HTMLColor;

    else if ( _HTMLColor.length > 6 )
        colorString = [ _HTMLColor substringToIndex: 5 ];

    else if ( _HTMLColor.length < 5 )
        {
        NSUInteger diff = 6 - _HTMLColor.length;
        NSMutableString* appendingString = [ NSMutableString stringWithCapacity: diff ];

        for ( int _Index = 0; _Index < diff; _Index++ )
            [ appendingString appendString: @"0" ];

        colorString = [ _HTMLColor stringByAppendingString: appendingString ];
        }

    if ( colorString )
        {
        NSString* redValueInHex = [ @"0x" stringByAppendingString: [ colorString substringWithRange: NSMakeRange( 0, 2 ) ] ];
        NSString* greenValueInHex = [ @"0x" stringByAppendingString: [ colorString substringWithRange: NSMakeRange( 2, 2 ) ] ];
        NSString* blueValueInHex = [ @"0x" stringByAppendingString: [ colorString substringWithRange: NSMakeRange( 4, 2 ) ] ];

        NSUInteger redValue = OMCOperandConvertHexToDecimal( redValueInHex );
        NSUInteger greenValue = OMCOperandConvertHexToDecimal( greenValueInHex );
        NSUInteger blueValue = OMCOperandConvertHexToDecimal( blueValueInHex );

        color = [ NSColor colorWithSRGBRed: redValue / 255.f green: greenValue / 255.f blue: blueValue / 255.f alpha: 1.f ];
        }
    else
        color = [ NSColor whiteColor ];

    return color;
    }

NSUInteger OMCOperandConvertHexToDecimal( NSString* _HexNumeric )
    {
    NSString* prefixForHex = @"0x";
    if ( ![ _HexNumeric hasPrefix: prefixForHex ] )
        return NAN;

    NSString* hexNumericWithoutPrefix = [ _HexNumeric substringFromIndex: prefixForHex.length ];

    NSUInteger resultInDecimal = 0U;
    double exponent = 0.f;
    for ( int index = ( int )hexNumericWithoutPrefix.length - 1; index >= 0; index-- )
        {
        NSString* stringForCurrentDigit = [ hexNumericWithoutPrefix substringWithRange: NSMakeRange( index, 1 ) ];
        NSUInteger valueForCurrentDigit = 0U;

        if ( isCharInAtoE( stringForCurrentDigit ) )
            valueForCurrentDigit = mapHexAlphaToDecimalNumeric( stringForCurrentDigit );
        else
            valueForCurrentDigit = ( NSUInteger )[ stringForCurrentDigit integerValue ];

        resultInDecimal += valueForCurrentDigit * ( NSUInteger )pow( 16, exponent++ );
        }

    return resultInDecimal;
    }

BOOL isCharInAtoE( NSString* _Char )
    {
    if ( COMPARE_WITH_CASE_INSENSITIVE( _Char, @"A" )
            || COMPARE_WITH_CASE_INSENSITIVE( _Char, @"B" )
            || COMPARE_WITH_CASE_INSENSITIVE( _Char, @"C" )
            || COMPARE_WITH_CASE_INSENSITIVE( _Char, @"D" )
            || COMPARE_WITH_CASE_INSENSITIVE( _Char, @"E" )
            || COMPARE_WITH_CASE_INSENSITIVE( _Char, @"F" ) )
        return YES;
    else
        return NO;
    }

NSUInteger mapHexAlphaToDecimalNumeric( NSString* _AlphaInHexNumeric )
    {
    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"A" ) )
        return 10;

    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"B" ) )
        return 11U;

    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"C" ) )
        return 12U;

    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"D" ) )
        return 13U;

    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"E" ) )
        return 14U;

    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"F" ) )
        return 15U;

    return NAN;
    }

@end // NSColor + ATCExtensions protocol

/*===============================================================================┐
|                                                                                | 
|                      ++++++     =++++~     +++=     =+++                       | 
|                        +++,       +++      =+        ++                        | 
|                        =+++       ~+++     +        =+                         | 
|                         +++=       =++=   +=        +                          | 
|                          +++        +++= +=        +=                          | 
|                          =+++        ++++=        =+                           | 
|                           +++=       =+++         +                            | 
|                            +++~       +++=       +=                            | 
|                            ,+++      ~++++=     ==                             | 
|                             ++++     +  +++     +                              | 
|                              +++=   +   ~+++   +,                              | 
|                               +++  +:    =+++ ==                               | 
|                               =++++=      +++++                                | 
|                                +++=        +++                                 | 
|                                 ++          +=                                 | 
|                                                                                | 
└===============================================================================*/