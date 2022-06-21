//
//  NSString+Extension.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 22/02/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#ifndef NSString_Extension_Class
#define NSString_Extension_Class

#import <Foundation/Foundation.h>

@interface NSString (VMMString)

-(unichar)charAt:(NSUInteger)index;
-(BOOL)contains:(nonnull NSString*)string;
-(NSUInteger)indexOf:(nonnull NSString*)string;
-(NSUInteger)indexOf:(nonnull NSString*)string fromIndex:(NSUInteger)index;
-(BOOL)isBlank;
-(BOOL)isEmpty;
-(NSUInteger)lastIndexOf:(nonnull NSString*)string;
-(BOOL)matches:(nonnull NSString*)regexString;
-(nonnull NSArray<NSString*>*)split:(nonnull NSString*)separator;

+(nonnull  NSString*)stringWithCFTypeIDDescription:(CFTypeRef _Nonnull)cf_type;
+(nullable NSString*)stringWithCFString:(CFStringRef _Nonnull)cf_string;
+(nonnull  NSString*)stringWithCFNumber:(CFNumberRef _Nonnull)cf_number ofType:(CFNumberType)number_type;
+(nullable NSString*)stringWithCFType:(CFTypeRef _Nonnull)cf_type;

-(nonnull NSArray<NSString*>*)findAll:(nonnull NSString*)regexString;

-(nonnull NSString*)encodeURIComponent;

-(NSRange)rangeAfterString:(nullable NSString*)before andBeforeString:(nullable NSString*)after;
-(nullable NSString*)getFragmentAfter:(nullable NSString*)before andBefore:(nullable NSString*)after;

+(nullable NSString*)stringWithContentsOfFile:(nonnull NSString*)file encoding:(NSStringEncoding)enc;

-(BOOL)writeToFile:(nonnull NSString*)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc;

-(nonnull NSData*)dataWithBase64Encoding;

-(BOOL)isAValidURL;

-(nonnull NSString*)stringByReplacingCharactersInSet:(nonnull NSCharacterSet *)characterset withString:(nonnull NSString *)string;
-(nonnull NSString*)stringByRemovingCharactersInSet:(nonnull NSCharacterSet *)characterset;

@end

#endif
