//
//  NSMutableArray+Extension.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 24/07/2017.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import "NSMutableArray+Extension.h"

#import "NSException+Extension.h"

@implementation NSMutableArray (VMMMutableArray)

-(void)add:(nonnull id)anObject
{
    [self addObject:anObject];
}
-(void)add:(nonnull id)anObject atIndex:(NSUInteger)index
{
    [self insertObject:anObject atIndex:index];
}
-(void)addAll:(nonnull NSArray *)otherArray
{
    [self addObjectsFromArray:otherArray];
}
-(void)clear
{
    [self removeAllObjects];
}
-(nonnull NSMutableArray*)filter:(BOOL (^_Nonnull)(id _Nonnull object))newObjectForObject
{
    NSUInteger size = self.count;
    for (NSUInteger index = 0; index < size; index++)
    {
        BOOL preserve = newObjectForObject([self objectAtIndex:index]);
        if (!preserve) {
            [self removeObjectAtIndex:index];
            index--;
            size--;
        }
    }
    return self;
}
-(nonnull NSMutableArray*)filterWithIndex:(BOOL (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject
{
    NSUInteger size = self.count;
    for (NSUInteger index = 0; index < size; index++)
    {
        BOOL preserve = newObjectForObject([self objectAtIndex:index], index);
        if (!preserve) {
            [self removeObjectAtIndex:index];
            index--;
            size--;
        }
    }
    return self;
}
-(nonnull NSMutableArray*)map:(_Nullable id (^_Nonnull)(id _Nonnull object))newObjectForObject
{
    for (NSUInteger index = 0; index < self.count; index++)
    {
        id newObject = newObjectForObject([self objectAtIndex:index]);
        [self replaceObjectAtIndex:index withObject:newObject ? newObject : [NSNull null]];
    }
    return self;
}
-(nonnull NSMutableArray*)mapWithIndex:(_Nullable id (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject
{
    for (NSUInteger index = 0; index < self.count; index++)
    {
        id newObject = newObjectForObject([self objectAtIndex:index], index);
        [self replaceObjectAtIndex:index withObject:newObject ? newObject : [NSNull null]];
    }
    return self;
}
-(void)removeAll:(nonnull NSArray*)array
{
    [self removeObjectsInArray:array];
}

-(void)sortBySelector:(SEL _Nonnull)selector usingComparator:(NSInteger (^_Nonnull)(id _Nonnull object1, id _Nonnull object2))comparator
{
    [self sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
    {
         id obj1ReturnedValue = nil;
         id obj2ReturnedValue = nil;
         
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
         if (![obj1 respondsToSelector:selector])
         {
             @throw exception(NSInvalidArgumentException, @"Selector unavailable in one of the objects");
         }
         
         obj1ReturnedValue = [obj1 performSelector:selector];
         
         if (![obj2 respondsToSelector:selector])
         {
             @throw exception(NSInvalidArgumentException, @"Selector unavailable in one of the objects");
         }
        
         obj2ReturnedValue = [obj2 performSelector:selector];
#pragma clang diagnostic pop
         
         NSInteger result = comparator(obj1ReturnedValue, obj2ReturnedValue);
         if (result > 0) return NSOrderedDescending;
         if (result < 0) return NSOrderedAscending;
         return NSOrderedSame;
    }];
}


@end
