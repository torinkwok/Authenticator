#import <CommonCrypto/CommonHMAC.h>

NSString* TKSignWithHMACSHA1( NSString* _SignatureBaseString, NSString* _SigningKey );
NSString* TKTimestamp(void);
NSString* TKNonce(void);
