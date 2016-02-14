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

@import Security;

void ATCFillErrorParamWithSecErrorCode( OSStatus _ResultCode, NSError** _ErrorParam )
    {
    if ( _ErrorParam )
        {
        CFStringRef cfErrorDesc = SecCopyErrorMessageString( _ResultCode, NULL );
        *_ErrorParam = [ [ NSError errorWithDomain: NSOSStatusErrorDomain
                                              code: _ResultCode
                                          userInfo: @{ NSLocalizedDescriptionKey : [ ( __bridge NSString* )cfErrorDesc copy ] }
                                                  ] copy ];
        CFRelease( cfErrorDesc );
        }
    }

// Retrieves a SecKeychainRef represented the current default keychain.
SecKeychainRef ATCCurrentDefaultKeychain( NSError** _Error )
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainRef secCurrentDefaultKeychain = NULL;

    if ( ( resultCode = SecKeychainCopyDefault( &secCurrentDefaultKeychain ) ) != errSecSuccess )
        ATCFillErrorParamWithSecErrorCode( resultCode, _Error );

    return secCurrentDefaultKeychain;
    }

// Adds a new generic passphrase to the keychain represented by receiver.
SecKeychainItemRef ATCAddApplicationPassphraseToDefaultKeychain( NSString* _ServiceName
                                                               , NSString* _AccountName
                                                               , NSString* _Passphrase
                                                               , NSError** _Error
                                                               )
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainItemRef secKeychainItem = NULL;
    SecKeychainRef secDefaultKeychain = ATCCurrentDefaultKeychain( _Error );
    if ( secDefaultKeychain )
        {
        // As described in documentation:
        // SecKeychainAddGenericPassword() function automatically calls the SecKeychainUnlock () function
        // to display the Unlock Keychain dialog box if the keychain is currently locked.
        // Adding.... Beep Beep Beep...
        if ( ( resultCode = SecKeychainAddGenericPassword( secDefaultKeychain
                                                         , ( UInt32 )_ServiceName.length, _ServiceName.UTF8String
                                                         , ( UInt32 )_AccountName.length, _AccountName.UTF8String
                                                         , ( UInt32 )_Passphrase.length, _Passphrase.UTF8String
                                                         , &secKeychainItem
                                                         ) ) != errSecSuccess )
            ATCFillErrorParamWithSecErrorCode( resultCode, _Error );

        CFRelease( secDefaultKeychain );
        }

    return secKeychainItem;
    }

SecKeychainItemRef ATCFindApplicationPassphraseInDefaultKeychain( NSString* _ServiceName
                                                                , NSString* _AccountName
                                                                , NSError** _Error )
    {
    SecKeychainRef secDefaultKeychain = ATCCurrentDefaultKeychain( _Error );

    OSStatus resultCode = errSecSuccess;
    NSMutableDictionary* finalQueryDictionary =
        [ NSMutableDictionary dictionaryWithObjectsAndKeys:
              ( __bridge id )kSecClassGenericPassword, ( __bridge id )kSecClass
            , _ServiceName, ( __bridge id )kSecAttrService
            , _AccountName , ( __bridge id )kSecAttrAccount
            , ( __bridge id )kSecMatchLimitOne, ( __bridge id )kSecMatchLimit
            , @[ ( __bridge id )secDefaultKeychain ], ( __bridge id )kSecMatchSearchList
            , ( __bridge id )kCFBooleanTrue, ( __bridge id )kSecReturnRef
            , nil ];

    CFTypeRef secMatchedItem = NULL;
    if ( ( resultCode = SecItemCopyMatching( ( __bridge CFDictionaryRef )finalQueryDictionary
                                           , &secMatchedItem ) ) != errSecSuccess )
        if ( resultCode != errSecItemNotFound )
            ATCFillErrorParamWithSecErrorCode( resultCode, _Error );

    return ( SecKeychainItemRef )secMatchedItem;
    }

NSData* ATCGetPassphrase( SecKeychainItemRef _KeychainItemRef )
    {
    OSStatus resultCode = errSecSuccess;
    NSData* passphraseData = nil;

    UInt32 lengthOfSecretData = 0;
    void* secretData = NULL;

    // Get the secret data
    resultCode = SecKeychainItemCopyAttributesAndData( _KeychainItemRef, NULL, NULL, NULL
                                                     , &lengthOfSecretData, &secretData );
    if ( resultCode == errSecSuccess )
        {
        passphraseData = [ NSData dataWithBytes: secretData length: lengthOfSecretData ];
        SecKeychainItemFreeAttributesAndData( NULL, secretData );
        }

    return passphraseData;
    }

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