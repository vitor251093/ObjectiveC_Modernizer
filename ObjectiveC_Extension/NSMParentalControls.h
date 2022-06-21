//
//  VMMUserAuthorization.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 05/02/2018.
//  Copyright © 2018 VitorMM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum NSMParentalControlsItunesGamesAgeRestriction
{
    NSMParentalControlsItunesGamesAgeRestrictionNone = 1000,
    NSMParentalControlsItunesGamesAgeRestriction4    = 100,
    NSMParentalControlsItunesGamesAgeRestriction9    = 200,
    NSMParentalControlsItunesGamesAgeRestriction12   = 300,
    NSMParentalControlsItunesGamesAgeRestriction17   = 600,
} NSMParentalControlsItunesGamesAgeRestriction;


@interface NSMParentalControls : NSObject

+(BOOL)isEnabled;

+(id)parentalControlsValueForAppWithDomain:(NSString*)appDomain keyName:(NSString*)keyName;

+(BOOL)iTunesMatureGamesAllowed;
+(NSMParentalControlsItunesGamesAgeRestriction)iTunesAgeRestrictionForGames;

+(BOOL)isAppRestrictionEnabled;
+(BOOL)isAppUseRestricted:(NSString*)appPath;

+(BOOL)isInternetUseRestricted;
+(BOOL)isWebsiteAllowed:(NSString*)websiteAddress;

@end
