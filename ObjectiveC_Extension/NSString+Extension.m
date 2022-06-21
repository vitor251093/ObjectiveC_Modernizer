//
//  NSString+Extension.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 22/02/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

#import "NSString+Extension.h"

#import "NSData+Extension.h"
#import "NSException+Extension.h"
#import "NSTask+Extension.h"
#import "VMMAlert.h"
#import "NSFileManager+Extension.h"
#import "NSMutableString+Extension.h"

#import "NSMComputerInformation.h"
#import "NSMJSON.h"
#import "NSMLocalizationUtility.h"
#import "NSMUUID.h"

@implementation NSString (VMMString)

-(unichar)charAt:(NSUInteger)index {
    return [self characterAtIndex:index];
}
-(BOOL)contains:(nonnull NSString*)string {
    return [self rangeOfString:string].location != NSNotFound;
}
-(NSUInteger)indexOf:(nonnull NSString*)string {
    return [self rangeOfString:string].location;
}
-(NSUInteger)indexOf:(nonnull NSString*)string fromIndex:(NSUInteger)index {
    NSRange range = NSMakeRange(index, self.length - index);
    return [self rangeOfString:string options:0 range:range].location;
}
-(BOOL)isBlank {
    return ((NSMutableString*)self.mutableCopy).trim.isEmpty;
}
-(BOOL)isEmpty {
    return self.length == 0;
}
-(NSUInteger)lastIndexOf:(nonnull NSString*)string {
    return [self rangeOfString:string options:NSBackwardsSearch].location;
}
-(BOOL)matches:(nonnull NSString*)regexString {
    BOOL result;
    
    @autoreleasepool
    {
        NSPredicate* regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
        result = [regex evaluateWithObject:self];
    }
    
    return result;
}
-(nonnull NSArray<NSString*>*)split:(nonnull NSString*)separator {
    return [self componentsSeparatedByString:separator];
}

+(nonnull NSString*)stringWithCFTypeIDDescription:(CFTypeRef _Nonnull)cf_type {
    CFTypeID type_id = (CFTypeID) CFGetTypeID(cf_type);
    CFStringRef typeIdDescription = CFCopyTypeIDDescription(type_id);
    NSString* string = [self stringWithCFString:typeIdDescription];
    CFRelease(typeIdDescription);
    return [NSString stringWithFormat:@"<%@>",string];
}
+(nullable NSString*)stringWithCFString:(CFStringRef _Nonnull)cf_string {
    char * buffer;
    CFIndex len = CFStringGetLength(cf_string);
    buffer = (char *) malloc(sizeof(char) * len + 1);
    CFStringGetCString(cf_string, buffer, len + 1,
                       CFStringGetSystemEncoding());
    NSString* string = [NSString stringWithUTF8String:buffer];
    free(buffer);
    return string;
}
+(nonnull NSString*)stringWithCFNumber:(CFNumberRef _Nonnull)cf_number ofType:(CFNumberType)number_type {
    int number; 
    CFNumberGetValue(cf_number, number_type, &number);
    return [NSString stringWithFormat:@"%d",number];
}
+(nullable NSString*)stringWithCFType:(CFTypeRef _Nonnull)cf_type {
    CFTypeID type_id;
    
    type_id = (CFTypeID) CFGetTypeID(cf_type);
    if (type_id == CFStringGetTypeID())
    {
        return [self stringWithCFString:cf_type];
    }
    else if (type_id == CFNumberGetTypeID())
    {
        return [self stringWithCFNumber:cf_type ofType:kCFNumberIntType];
    }
    else if (type_id == CFDateGetTypeID())
    {
        // TODO: Not tested
        NSDate* date = (__bridge NSDate*)cf_type;
        return [date descriptionWithLocale:[NSLocale currentLocale]];
    }
    
    // TODO: The types below are still unsupported:
    //{CFArrayGetTypeID(),"CFArray"},
    //{CFBooleanGetTypeID(),"CFBoolean"},
    //{CFDataGetTypeID(),"CFData"},
    //{CFDictionaryGetTypeID(),"CFDictionary"},
    
    return nil;
}

-(nonnull NSArray<NSString*>*)findAll:(nonnull NSString*)regexString
{
    NSMutableArray* matches;
    
    if (IsClassNSRegularExpressionAvailable == false)
    {
        // TODO: Find a different way to replace NSRegularExpression... there must be a better way
        
        /*NSString* string = [self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
        NSString* regexFunction = [NSString stringWithFormat:
                                          @"return function() {\
                                                var str = '%@';\
                                                var regexp = /%@/g;\
                                                matchAll = Array.from(matchAll);\
                                                return matchAll;\
                                            }()", string, regexString];
        
        JSGlobalContextRef ctx = JSGlobalContextCreate(NULL);
        JSStringRef scriptJS = JSStringCreateWithUTF8CString([regexFunction UTF8String]);
        
        JSObjectRef fn = JSObjectMakeFunction(ctx, NULL, 0, NULL, scriptJS, NULL, 1, NULL);
        JSValueRef result = JSObjectCallAsFunction(ctx, fn, NULL, 0, NULL, NULL);
        JSStringRef resultJson = JSValueCreateJSONString(ctx, result, 0, NULL);
        
        size_t length = JSStringGetMaximumUTF8CStringSize(resultJson);
        char* resultJsonStringValue = (char*)malloc(length);
        JSStringGetUTF8CString(resultJson, resultJsonStringValue, length);
        
        JSStringRelease(scriptJS);
        JSGlobalContextRelease(ctx);
        
        NSString* resultJsonString = [NSString stringWithUTF8String:resultJsonStringValue];
        NSData* resultJsonData = [resultJsonString dataUsingEncoding:NSUTF8StringEncoding];
        [VMMJSON deserializeFromData:resultJsonData];*/
        
        @autoreleasepool
        {
            NSString* uuid = VMMUUIDCreate();
            NSString* pyFileName  = [NSString stringWithFormat:@"pythonRegex%@.py",uuid];
            NSString* datFileName = [NSString stringWithFormat:@"pythonFile%@.dat",uuid];
            
            NSString* pythonScriptPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),pyFileName ];
            NSString* stringFilePath   = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),datFileName];
            
            NSArray* pythonScriptContentsArray = @[@"import re",
                                                   @"import os",
                                                   @"dir_path = os.path.dirname(os.path.abspath(__file__))",
                                                   [NSString stringWithFormat:@"text_file = open(dir_path + \"/%@\", \"r\")",datFileName],
                                                   @"text = text_file.read()",
                                                   [NSString stringWithFormat:@"regex = re.compile(r\"(%@)\")",regexString],
                                                   @"matches = regex.finditer(text)",
                                                   @"for match in matches:",
                                                   @"    print match.group()"];
            NSString* pythonScriptContents = [pythonScriptContentsArray componentsJoinedByString:@"\n"];
            
            [self                 writeToFile:stringFilePath   atomically:YES encoding:NSASCIIStringEncoding];
            [pythonScriptContents writeToFile:pythonScriptPath atomically:YES encoding:NSASCIIStringEncoding];
            
            NSString* output = [NSTask runCommand:@[@"python", pythonScriptPath]];
            matches = [[output split:@"\n"] mutableCopy];
            [matches removeObject:@""];
        }
        
        return matches;
    }
    
    @autoreleasepool
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:0 error:NULL];
        NSArray* rangeArray = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
        
        matches = [[NSMutableArray alloc] init];
        for (NSTextCheckingResult *match in rangeArray)
        {
            [matches addObject:[self substringWithRange:match.range]];
        }
    }
        
    return matches;
}

-(nonnull NSString*)encodeURIComponent
{
    NSString* webString;
    
    @autoreleasepool
    {
        webString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        webString = [webString stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        webString = [webString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        webString = [webString stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        webString = [webString stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
        webString = [webString stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        webString = [webString stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    }
    
    return webString;
}

-(NSRange)rangeAfterString:(nullable NSString*)before andBeforeString:(nullable NSString*)after
{
    NSRange result;
    
    @autoreleasepool
    {
        NSRange beforeRange = before ? [self rangeOfString:before] : NSMakeRange(0, 0);
        
        if (beforeRange.location == NSNotFound)
        {
            return NSMakeRange(NSNotFound, 0);
        }
        
        CGFloat afterBeforeRangeStart = beforeRange.location + beforeRange.length;
        NSRange afterBeforeRange = NSMakeRange(afterBeforeRangeStart, self.length - afterBeforeRangeStart);
        NSRange afterRange = after ? [self rangeOfString:after options:0 range:afterBeforeRange] : NSMakeRange(NSNotFound, 0);
        
        if (afterRange.location == NSNotFound)
        {
            return afterBeforeRange;
        }
        
        result = NSMakeRange(afterBeforeRangeStart, afterRange.location - afterBeforeRangeStart);
    }
    
    return result;
}
-(nullable NSString*)getFragmentAfter:(nullable NSString*)before andBefore:(nullable NSString*)after
{
    NSRange range = [self rangeAfterString:before andBeforeString:after];
    if (range.location == NSNotFound) return nil;
    return [self substringWithRange:range];
}

+(nullable NSString*)stringWithContentsOfFile:(nonnull NSString*)file encoding:(NSStringEncoding)enc
{
    if (![[NSFileManager defaultManager] regularFileExistsAtPath:file]) return nil;
    
    NSError* error;
    NSString* string = [self stringWithContentsOfFile:file encoding:enc error:&error];
    
    if (error != nil)
    {
        @throw [NSException exceptionWithError:error];
    }
    
    return string;
}

-(BOOL)writeToFile:(nonnull NSString*)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc
{
    if (![[NSFileManager defaultManager] regularFileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createEmptyFileAtPath:path];
    }
    
    NSError* error;
    BOOL created = [self writeToFile:path atomically:useAuxiliaryFile encoding:enc error:&error];
    
    if (error != nil)
    {
        @throw [NSException exceptionWithError:error];
    }
    
    return created;
}

-(nonnull NSData*)dataWithBase64Encoding
{
    if (!IS_SYSTEM_MAC_OS_10_9_OR_SUPERIOR)
    {
        return [[NSData alloc] initWithBase64Encoding:self];
    }
    
    return [[NSData alloc] initWithBase64EncodedString:self options:0];
}

-(BOOL)isAValidURL
{
    BOOL isValid = true;
    
    @autoreleasepool
    {
        if (![self hasPrefix:@"http://"] && ![self hasPrefix:@"https://"] && ![self hasPrefix:@"ftp://"])
        {
            isValid = false;
        }
        
        if (isValid)
        {
            NSURL *candidateURL = [NSURL URLWithString:self];
            isValid = candidateURL && candidateURL.scheme && candidateURL.host;
        }
    }
    
    return isValid;
}

-(nonnull NSString*)stringByReplacingCharactersInSet:(nonnull NSCharacterSet *)characterset withString:(nonnull NSString *)string
{
    NSString *result = self;
    NSRange range = [result rangeOfCharacterFromSet:characterset];
    
    while (range.location != NSNotFound) {
        result = [result stringByReplacingCharactersInRange:range withString:string];
        range = [result rangeOfCharacterFromSet:characterset];
    }
    return result;
}
-(nonnull NSString*)stringByRemovingCharactersInSet:(nonnull NSCharacterSet *)characterset
{
    return [self stringByReplacingCharactersInSet:characterset withString:@""];
}

@end
