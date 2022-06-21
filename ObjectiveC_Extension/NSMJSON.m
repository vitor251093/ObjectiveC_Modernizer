//
//  VMMJSON.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 10/06/22.
//  Copyright © 2022 VitorMM. All rights reserved.
//

#import "NSMJSON.h"

#import "SZJsonParser.h"

#import "NSException+Extension.h"
#import "NSMutableString+Extension.h"

#import "NSMComputerInformation.h"

@implementation NSMJSON

+(nullable NSString*)serializeToString:(nonnull id)object
{
    if (IsClassNSJSONSerializationAvailable == false)
    {
        @autoreleasepool
        {
            if ([object isKindOfClass:[NSString class]])
            {
                NSMutableString* stringObject = [(NSString*)object mutableCopy];
                [stringObject replace:@"\"" with:@"\\\""];
                [stringObject replace:@"\n" with:@"\\\n"];
                [stringObject replace:@"/"  with:@"\\/" ];
                return [NSString stringWithFormat:@"\"%@\"",stringObject];
            }
            
            if ([object isKindOfClass:[NSArray class]])
            {
                NSMutableArray* array = [[NSMutableArray alloc] init];
                for (id innerObject in (NSArray*)object)
                {
                    [array addObject:[self serializeToString:innerObject]];
                }
                return [NSString stringWithFormat:@"[%@]",[array componentsJoinedByString:@","]];
            }
            
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSMutableArray* dict = [[NSMutableArray alloc] init];
                for (NSString* key in [(NSDictionary*)object allKeys])
                {
                    [dict addObject:[NSString stringWithFormat:@"%@:%@",[self serializeToString:key],
                                     [self serializeToString:[(NSDictionary*)object objectForKey:key]]]];
                }
                return [NSString stringWithFormat:@"{%@}",[dict componentsJoinedByString:@","]];
            }
            
            if ([object isKindOfClass:[NSNumber class]])
            {
                NSInteger integerValue = [(NSNumber*)object integerValue];
                double doubleValue = [(NSNumber*)object doubleValue];
                BOOL boolValue = [(NSNumber*)object boolValue];
                
                if (integerValue != doubleValue) return [NSString stringWithFormat:@"%lf",doubleValue];
                if (integerValue != boolValue)   return [NSString stringWithFormat:@"%ld",integerValue];
                return boolValue ? @"true" : @"false";
            }
            
            return @"";
        }
    }

    return [[NSString alloc] initWithData:[self serializeToData:object] encoding:NSUTF8StringEncoding];
}

+(nullable NSData*)serializeToData:(nonnull id)object
{
    if (IsClassNSJSONSerializationAvailable == false)
    {
        @autoreleasepool
        {
            return [[self serializeToString:object] dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    NSError *error = nil;
    NSData* result = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        @throw [NSException exceptionWithError:error];
    }
    return result;
}

+(nullable id)deserializeFromData:(nonnull NSData*)data
{
    if (IsClassNSJSONSerializationAvailable == false)
    {
        @autoreleasepool
        {
            return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] jsonObject];
        }
    }

    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        @throw [NSException exceptionWithError:error];
    }
    return result;
}

@end
