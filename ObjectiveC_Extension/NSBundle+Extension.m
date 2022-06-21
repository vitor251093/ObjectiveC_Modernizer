//
//  NSBundle+Extension.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 25/11/2017.
//  Copyright © 2017 VitorMM. All rights reserved.
//

#import "NSBundle+Extension.h"

#import "NSTask+Extension.h"
#import "NSException+Extension.h"
#import "NSFileManager+Extension.h"
#import "NSString+Extension.h"
#import "NSUserDefaults+Extension.h"

#import "NSMComputerInformation.h"

#include <stdlib.h>
#import <objc/runtime.h>

static NSString* const BUNDLE_NAME_PLACEHOLDER = @"App";

@implementation NSBundle (VMMBundle)

NSBundle* _originalMainBundle;

-(nonnull NSUserDefaults*)userDefaults
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults addSuiteNamed:[self bundleIdentifier]];
    return defaults;
}

-(nonnull NSString*)bundleName
{
    @synchronized(self)
    {
        NSString* bundleName = [self objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        
        if (bundleName == nil)
        {
            bundleName = [self objectForInfoDictionaryKey:@"CFBundleName"];
        }
        
        if (bundleName == nil)
        {
            // Reference:
            // https://stackoverflow.com/a/35322073/4370893
            
            bundleName = [NSString stringWithUTF8String:getprogname()];
        }
        
        if (bundleName == nil)
        {
            NSString* newBundleName = self.bundlePath.stringByDeletingPathExtension.lastPathComponent;
            if (newBundleName != nil) bundleName = newBundleName;
        }
        
        if (bundleName != nil)
        {
            return bundleName;
        }
        
        return BUNDLE_NAME_PLACEHOLDER;
    }
}
-(nullable NSImage*)bundleIcon
{
    NSString* appImageFileName = [self objectForInfoDictionaryKey:@"CFBundleIconFile"];
    
    if (![appImageFileName hasSuffix:@".icns"])
        appImageFileName = [appImageFileName stringByAppendingString:@".icns"];
    
    NSString* appImageCompletePath = [NSString stringWithFormat:@"%@/Contents/Resources/%@",[self bundlePath],appImageFileName];
    
    NSImage* appImage = [[NSImage alloc] initWithContentsOfFile:appImageCompletePath];
    
    return appImage;
}

-(BOOL)doesBundleAtPath:(NSString*)bundlePath executableMatchesWithMD5Checksum:(NSString*)checksum
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:bundlePath] == false) return false;
    
    NSBundle* applicationInDesktopBundle = [[NSBundle alloc] initWithPath:bundlePath];
    NSString* applicationInDesktopExecutablePath = [applicationInDesktopBundle executablePath];
    if (!applicationInDesktopExecutablePath) return false;
    
    NSString* applicationInDesktopBinaryChecksum = [[NSFileManager defaultManager] checksum:NSChecksumTypeMD5
                                                                               ofFileAtPath:applicationInDesktopExecutablePath];
    return [applicationInDesktopBinaryChecksum isEqualToString:checksum];
}
-(NSString*)bundlePathBeforeAppTranslocation
{
    if (IS_SYSTEM_MAC_OS_10_15_OR_SUPERIOR) {
        @throw exception(NSGenericException, [NSString stringWithFormat:@"App Translocation can't be automatically fixed in macOS 10.15+"]);
    }

    @synchronized(self)
    {
        NSString* bundlePathBeforeAppTranslocation;
        
        @autoreleasepool
        {    
            NSString* appBinaryPath = [self executablePath];
            NSString* appBundleFileName = [[self bundlePath] lastPathComponent];
            if (!appBinaryPath || !appBundleFileName) return nil;
            
            NSString* appBinaryChecksum = [[NSFileManager defaultManager] checksum:NSChecksumTypeMD5 ofFileAtPath:appBinaryPath];
            if (!appBinaryChecksum) return nil;
            
            NSString* applicationsFolderPath = @"/Applications/";
            NSString* desktopFolderPath = [NSString stringWithFormat:@"%@/Desktop/",NSHomeDirectory()];
            NSString* downloadsFolderPath = [NSString stringWithFormat:@"%@/Downloads/",NSHomeDirectory()];
            
            // Applications
            NSString* applicationInApplicationsFolderPath = [applicationsFolderPath stringByAppendingString:appBundleFileName];
            if ([self doesBundleAtPath:applicationInApplicationsFolderPath executableMatchesWithMD5Checksum:appBinaryChecksum])
            {
                bundlePathBeforeAppTranslocation = applicationInApplicationsFolderPath;
            }
            if (bundlePathBeforeAppTranslocation == nil)
            {
                NSArray* applicationsFilesMatches = [[NSFileManager defaultManager] subpathsAtPath:applicationsFolderPath
                                                                                      ofFilesNamed:appBundleFileName];
                for (NSString* applicationsFilesMatch in applicationsFilesMatches)
                {
                    if ([self doesBundleAtPath:applicationsFilesMatch executableMatchesWithMD5Checksum:appBinaryChecksum])
                    {
                        bundlePathBeforeAppTranslocation = applicationsFilesMatch;
                        break;
                    }
                }
            }
            
            // Desktop
            if (bundlePathBeforeAppTranslocation == nil)
            {
                NSString* applicationInDesktopFolderPath = [desktopFolderPath stringByAppendingString:appBundleFileName];
                if ([self doesBundleAtPath:applicationInDesktopFolderPath executableMatchesWithMD5Checksum:appBinaryChecksum])
                {
                    bundlePathBeforeAppTranslocation = applicationInDesktopFolderPath;
                }
            }
            if (bundlePathBeforeAppTranslocation == nil)
            {
                NSArray* desktopFilesMatches = [[NSFileManager defaultManager] subpathsAtPath:desktopFolderPath
                                                                                 ofFilesNamed:appBundleFileName];
                for (NSString* desktopFilesMatch in desktopFilesMatches)
                {
                    if ([self doesBundleAtPath:desktopFilesMatch executableMatchesWithMD5Checksum:appBinaryChecksum])
                    {
                        bundlePathBeforeAppTranslocation = desktopFilesMatch;
                        break;
                    }
                }
            }
            
            // Downloads
            if (bundlePathBeforeAppTranslocation == nil)
            {
                NSString* applicationInDownloadsFolderPath = [downloadsFolderPath stringByAppendingString:appBundleFileName];
                if ([self doesBundleAtPath:applicationInDownloadsFolderPath executableMatchesWithMD5Checksum:appBinaryChecksum])
                {
                    bundlePathBeforeAppTranslocation = applicationInDownloadsFolderPath;
                }
            }
            if (bundlePathBeforeAppTranslocation == nil)
            {
                NSArray* downloadsFilesMatches = [[NSFileManager defaultManager] subpathsAtPath:downloadsFolderPath
                                                                                   ofFilesNamed:appBundleFileName];
                for (NSString* downloadsFilesMatch in downloadsFilesMatches)
                {
                    if ([self doesBundleAtPath:downloadsFilesMatch executableMatchesWithMD5Checksum:appBinaryChecksum])
                    {
                        bundlePathBeforeAppTranslocation = downloadsFilesMatch;
                        break;
                    }
                }
            }
            
            // Home
            if (bundlePathBeforeAppTranslocation == nil)
            {
                NSArray* homeFilesMatches = [[NSFileManager defaultManager] subpathsAtPath:@"~" ofFilesNamed:appBundleFileName];
                
                for (NSString* homeFilesMatch in homeFilesMatches)
                {
                    if ([self doesBundleAtPath:homeFilesMatch executableMatchesWithMD5Checksum:appBinaryChecksum])
                    {
                        bundlePathBeforeAppTranslocation = homeFilesMatch;
                        break;
                    }
                }
            }
            
            // Disk
            if (bundlePathBeforeAppTranslocation == nil)
            {
                NSArray* diskFilesMatches = [[NSFileManager defaultManager] subpathsAtPath:@"/" ofFilesNamed:appBundleFileName];
                
                for (NSString* diskFilesMatch in diskFilesMatches)
                {
                    if ([self doesBundleAtPath:diskFilesMatch executableMatchesWithMD5Checksum:appBinaryChecksum])
                    {
                        bundlePathBeforeAppTranslocation = diskFilesMatch;
                        break;
                    }
                }
            }
        }
        
        return bundlePathBeforeAppTranslocation;
    }
}

-(BOOL)isAppTranslocationActive
{
    // App Translocation description:
    // http://lapcatsoftware.com/articles/app-translocation.html
    
    if (!IS_SYSTEM_MAC_OS_10_12_OR_SUPERIOR) return false;
    
    NSString* path = [self bundlePath];
    return [path hasPrefix:@"/private/var/folders/"] || [path hasPrefix:@"/var/folders/"];
}
-(BOOL)disableAppTranslocation
{
    NSString* originalPath = [self bundlePath];
    if (originalPath == nil) return false;
    
    [NSTask runProgram:@"xattr" withFlags:@[@"-r",@"-d",@"com.apple.quarantine",originalPath]];
    return true;
}

+(nullable NSBundle*)realMainBundle
{
    @synchronized ([NSBundle class])
    {
        if ([[NSBundle mainBundle] isAppTranslocationActive])
        {
            if (_originalMainBundle != nil && [[NSFileManager defaultManager] fileExistsAtPath:_originalMainBundle.bundlePath])
            {
                return _originalMainBundle;
            }
            
            NSString* originalPath = [[NSBundle mainBundle] bundlePathBeforeAppTranslocation];
            _originalMainBundle = [NSBundle bundleWithPath:originalPath];
            return _originalMainBundle;
        }
        
        return [NSBundle mainBundle];
    }
}

-(BOOL)preferExternalGPU
{
    NSUserDefaults* defaults = [self userDefaults];
    return [defaults preferExternalGPU];
}
-(void)setPreferExternalGPU:(BOOL)prefer
{
    NSUserDefaults* defaults = [self userDefaults];
    [defaults setPreferExternalGPU:prefer];
    [defaults synchronize];
}

@end
