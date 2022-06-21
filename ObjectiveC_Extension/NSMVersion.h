//
//  VMMVersion.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 18/09/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum NSMVersionCompare
{
    NSMVersionCompareFirstIsNewest,
    NSMVersionCompareSecondIsNewest,
    NSMVersionCompareSame
} NSMVersionCompare;

@interface NSMVersion : NSObject

@property (nonatomic, strong) NSArray<NSString*>* _Nonnull components;

-(nonnull instancetype)initWithString:(nonnull NSString*)string;
-(NSMVersionCompare)compareWithVersion:(nonnull NSMVersion*)version;

+(NSMVersionCompare)compareVersionString:(nonnull NSString*)PK1 withVersionString:(nonnull NSString*)PK2;

@end
