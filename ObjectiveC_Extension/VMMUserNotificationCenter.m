//
//  VMMUserNotificationCenter.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 22/02/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//
//  Reference:
//  https://github.com/indragiek/NSUserNotificationPrivate
//

#import "VMMUserNotificationCenter.h"

#import "VMMComputerInformation.h"

#import "NSAlert+Extension.h"

#define NOTIFICATION_UTILITY_SHARED_DICTIONARY_KEY @"info"

@interface NSUserNotification (NSUserNotificationPrivate)

@property(readonly, nonatomic) NSData *_identityImageData;
- (void)_setIdentityImage:(id)arg1 withIdentifier:(id)arg2;

@property(copy) NSImage *_identityImage;
@property BOOL _identityImageHasBorder;

@end

@implementation VMMUserNotificationCenter

static VMMUserNotificationCenter *_sharedInstance;

+(instancetype)defaultUserNotificationCenter
{
    @synchronized([self class])
    {
        if (!_sharedInstance)
        {
            _sharedInstance = [[VMMUserNotificationCenter alloc] init];
        }
        return _sharedInstance;
    }
    return nil;
}

-(void)deliverNotificationWithTitle:(NSString*)title message:(NSString*)message userInfo:(NSObject*)info icon:(NSImage*)icon actionButtonText:(NSString*)actionButton
{
    if (IsNSUserNotificationCenterAvailable == false)
    {
        [NSAlert showAlertWithTitle:title message:message andSettings:^(NSAlert *alert)
        {
            [alert setIcon:icon];
        }];
        
        return;
    }
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:(id<NSUserNotificationCenterDelegate>)self];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.informativeText = message;
    notification.soundName = NSUserNotificationDefaultSoundName;
    notification.userInfo = info ? @{NOTIFICATION_UTILITY_SHARED_DICTIONARY_KEY:info} : @{};
    
    if (icon != nil)
    {
        @try
        {
            [notification setValue:icon   forKey:@"_identityImage"];
            [notification setValue:@FALSE forKey:@"_identityImageHasBorder"];
        }
        @catch (NSException* exception)
        {
            // Avoiding API exception in case something changes in the future
            
            // That feature is only available from macOS 10.9 and beyond
            if ([notification respondsToSelector:@selector(setContentImage:)])
            {
                notification.contentImage = icon;
            }
        }
    }
    
    if (actionButton != nil)
    {
        [notification setHasActionButton:YES];
        [notification setActionButtonTitle:actionButton];
    }
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(BOOL)userNotificationCenter:(id)center shouldPresentNotification:(id)notification
{
    return YES;
}
-(void)userNotificationCenter:(id)center didActivateNotification:(id)notification
{
    if (self.delegate != nil)
    {
        NSDictionary* userInfoDict = ((NSUserNotification *)notification).userInfo;
        NSObject* userInfo = userInfoDict[NOTIFICATION_UTILITY_SHARED_DICTIONARY_KEY];
        [self.delegate actionButtonPressedForNotificationWithUserInfo:userInfo];
    }
}

@end
