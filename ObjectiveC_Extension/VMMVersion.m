//
//  VMMVersion.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 18/09/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import "VMMVersion.h"

#import "NSString+Extension.h"

@implementation VMMVersion

-(nonnull instancetype)initWithString:(nonnull NSString*)string
{
    self = [super init];
    if (self)
    {
        self.components = [string split:@"."];
    }
    return self;
}
-(nullable NSNumber*)initialIntegerValueFromString:(NSString*)string
{
    NSNumber* numberValue;
    
    @autoreleasepool
    {
        NSMutableString* originalString = [string mutableCopy];
        NSMutableString* newString = [NSMutableString stringWithString:@""];
        NSRange firstCharRange = NSMakeRange(0, 1);
        
        while (originalString.length > 0 && [originalString characterAtIndex:0] >= '0' && [originalString characterAtIndex:0] <= '9')
        {
            [newString appendString:[originalString substringWithRange:firstCharRange]];
            [originalString deleteCharactersInRange:firstCharRange];
        }
        
        if (newString.length > 0) numberValue = [[NSNumber alloc] initWithInt:newString.intValue];
    }
    
    return numberValue;
}
-(VMMVersionCompare)compareWithVersion:(nonnull VMMVersion*)version
{
    @autoreleasepool
    {
        NSArray<NSString*>* PKArray1 = self.components;
        NSArray<NSString*>* PKArray2 = version.components;
        
        for (int x = 0; x < PKArray1.count && x < PKArray2.count; x++)
        {
            if ([self initialIntegerValueFromString:PKArray1[x]].intValue < [self initialIntegerValueFromString:PKArray2[x]].intValue)
                return VMMVersionCompareSecondIsNewest;
            
            if ([self initialIntegerValueFromString:PKArray1[x]].intValue > [self initialIntegerValueFromString:PKArray2[x]].intValue)
                return VMMVersionCompareFirstIsNewest;
            
            if (PKArray1[x].length > PKArray2[x].length) return VMMVersionCompareFirstIsNewest;
            if (PKArray1[x].length < PKArray2[x].length) return VMMVersionCompareSecondIsNewest;
        }
        
        if (PKArray1.count < PKArray2.count) return VMMVersionCompareSecondIsNewest;
        if (PKArray1.count > PKArray2.count) return VMMVersionCompareFirstIsNewest;
        
        return VMMVersionCompareSame;
    }
}

+(VMMVersionCompare)compareVersionString:(nonnull NSString*)PK1 withVersionString:(nonnull NSString*)PK2
{
    @autoreleasepool
    {
        VMMVersion* version1 = [[VMMVersion alloc] initWithString:PK1];
        VMMVersion* version2 = [[VMMVersion alloc] initWithString:PK2];
        
        return [version1 compareWithVersion:version2];
    }
}

@end
