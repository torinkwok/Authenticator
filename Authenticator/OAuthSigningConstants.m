#import "OAuthSigningConstants.h"

NSString* TKSignWithHMACSHA1( NSString* _SignatureBaseString, NSString* _SigningKey )
    {
    unsigned char buffer[ CC_SHA1_DIGEST_LENGTH ];
    CCHmac( kCCHmacAlgSHA1
          , _SigningKey.UTF8String, _SigningKey.length
          , _SignatureBaseString.UTF8String, _SignatureBaseString.length
          , buffer
          );

    NSData* signatureData = [ NSData dataWithBytes: buffer length: CC_SHA1_DIGEST_LENGTH ];
    NSString* base64 = [ signatureData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength ];

    return base64;
    }

NSString* TKTimestamp()
    {
    NSTimeInterval UnixEpoch = [ [ NSDate date ] timeIntervalSince1970 ];
    NSString* timestamp = [ NSString stringWithFormat: @"%lu", ( NSUInteger )floor( UnixEpoch ) ];
    return timestamp;
    }

NSString* TKNonce()
    {
    CFUUIDRef UUID = CFUUIDCreate( kCFAllocatorDefault );
    CFStringRef cfStringRep = CFUUIDCreateString( kCFAllocatorDefault, UUID ) ;
    NSString* stringRepresentation = [ ( __bridge NSString* )cfStringRep copy ];

    if ( UUID )
        CFRelease( UUID );

    if ( cfStringRep )
        CFRelease( cfStringRep );

    return stringRepresentation;
    }