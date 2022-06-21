//
//  ObjCExtensionConfig.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 22/08/18.
//  Copyright © 2018 VitorMM. All rights reserved.
//

#ifndef ObjCExtensionConfig_h
#define ObjCExtensionConfig_h


#define I_WANT_TO_BE_RELEASED_IN_APPLE_STORE  true
//
// Pretty straightforward. If you set this to TRUE, any of the conditions
// below that may cause a rejection in the Apple Store will be automatically
// disabled in the end of this file.
//



#define NSDEBUGLOG_SHOULD_PRINT_TO_A_DESKTOP_FILE_TOO  false
//
// By enabling this, NSDebugLog should not only run as NSLog white in Debug,
// but it should also create a debug.log file in your Desktop with the same
// content. It's really useful in case you restart your app and lose some log,
// and with Mojave's extra logs in the console, that gives you a source without
// those extra contents.
//



#define USER_NOTIFICATIONS_SHOULD_SHOW_A_BIGGER_ICON  true
//
// User notifications have two different icons. A big one with the app icon
// in the left, and a squared smaller one in the right with a thumbnail.
//
// If this is set to FALSE and you ask VMMUserNotificationCenter to show a
// notification with an icon, it's going to show the icon in the right side
// of the notification.
//
// If this is set to TRUE and you ask VMMUserNotificationCenter to show a
// notification with an icon, it's going to show the icon in the left side
// of the notification, and the app icon will appear with a smaller side
// next to the notification title, in the left.
//
// WARNING: Setting this to TRUE will make your app be rejected
// in the Apple Store.
//



// DO NOT CHANGE WHAT'S BELOW THIS POINT!
// THIS IS WHAT MAKES THE I_WANT_TO_BE_RELEASED_IN_APPLE_STORE
// CONDITION WORK!

#if I_WANT_TO_BE_RELEASED_IN_APPLE_STORE == true
    #define USER_NOTIFICATIONS_SHOULD_SHOW_A_BIGGER_ICON  false
#endif



#endif /* ObjCExtensionConfig_h */
