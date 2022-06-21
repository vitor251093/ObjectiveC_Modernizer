//
//  VMMPropertyList.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 08/03/2018.
//  Copyright © 2018 VitorMM. All rights reserved.
//

#import "NSMPropertyList.h"

@implementation NSMPropertyList

+(nullable id)propertyListWithUnarchivedString:(nonnull NSString*)string
{
    id result;
    
    @autoreleasepool
    {
        NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
        result = [self propertyListWithUnarchivedData:data];
    }
    
    return result;
    
}
+(nullable id)propertyListWithUnarchivedData:(nonnull NSData*)data
{
    id propertyList;
    
    @autoreleasepool
    {
        NSError *error;
        NSPropertyListFormat format;
        propertyList = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable
                                                                  format:&format error:&error];
        if (propertyList == nil || error != nil)
        {
            return nil;
        }
    }
    
    return propertyList;
}

+(nullable id)propertyListWithArchivedString:(nonnull NSString *)string
{
    id result;
    
    @autoreleasepool
    {
        NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
        result = [self propertyListWithArchivedData:data];
    }
    
    return result;
}
+(nullable id)propertyListWithArchivedData:(nonnull NSData *)data
{
    @try
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException* exception)
    {
        return nil;
    }
}

@end
