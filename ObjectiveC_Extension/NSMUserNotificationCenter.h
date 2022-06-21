//
//  VMMUserNotificationCenter.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 22/02/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NSMUserNotificationNormal                = 0,
    NSMUserNotificationOnlyWithAction        = 1 << 0,
    NSMUserNotificationPreferGrowl           = 1 << 1,
    NSMUserNotificationNoAlert               = 1 << 2
    
} NSMUserNotificationCenterOptions;

@protocol NSMUserNotificationCenterDelegate
-(void)actionButtonPressedForNotificationWithUserInfo:(nullable NSObject*)userInfo;
@end

@interface NSMUserNotificationCenter : NSObject

@property (nonatomic, nullable) id<NSMUserNotificationCenterDelegate> delegate;

+(nonnull instancetype)defaultUserNotificationCenter;

+(BOOL)isGrowlAvailable;
+(BOOL)isNSUserNotificationCenterAvailable;

-(BOOL)deliverNotificationWithTitle:(nullable NSString*)title message:(nullable NSString*)message userInfo:(nullable NSObject*)info icon:(nullable NSImage*)icon actionButtonText:(nullable NSString*)actionButton options:(NSMUserNotificationCenterOptions)options;

-(BOOL)deliverNotificationWithTitle:(nullable NSString*)title message:(nullable NSString*)message icon:(nullable NSImage*)icon options:(NSMUserNotificationCenterOptions)options;

@end
