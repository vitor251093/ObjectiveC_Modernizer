//
//  NSArray+Extension.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 15/05/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import "NSArray+Extension.h"

#import "NSMutableArray+Extension.h"

@implementation NSArray (VMMArray)

-(BOOL)contains:(nonnull id)anObject
{
    return [self containsObject:anObject];
}
-(BOOL)containsAll:(nonnull NSArray*)array
{
    for (id anObject in array) {
        if (![self containsObject:anObject]) {
            return false;
        }
    }
    return true;
}
-(nullable id)get:(NSUInteger)index
{
    return [self objectAtIndex:index];
}
-(nonnull NSMutableArray*)map:(_Nullable id (^_Nonnull)(id _Nonnull object))newObjectForObject
{
    return [[self mutableCopy] map:newObjectForObject];
}
-(nonnull NSMutableArray*)mapWithIndex:(_Nullable id (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject
{
    return [[self mutableCopy] mapWithIndex:newObjectForObject];
}
-(nonnull NSMutableArray*)filter:(BOOL (^_Nonnull)(id _Nonnull object))newObjectForObject
{
    return [[self mutableCopy] filter:newObjectForObject];
}
-(nonnull NSMutableArray*)filterWithIndex:(BOOL (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject
{
    return [[self mutableCopy] filterWithIndex:newObjectForObject];
}
-(nonnull instancetype)forEach:(void (^_Nonnull)(id _Nonnull object))newObjectForObject
{
    for (id object in self) {
        newObjectForObject(object);
    }
    return self;
}

-(NSIndexSet* _Nonnull)indexesOf:(id _Nonnull)object inRange:(NSRange)range
{
    return [self indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (idx < range.location)                 return false;
        if (idx >= range.location + range.length) return false;
        return obj == object || [obj isEqual:object];
    }];
}
-(NSIndexSet* _Nonnull)indexesOf:(id _Nonnull)object
{
    return [self indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        return obj == object || [obj isEqual:object];
    }];
}

-(NSInteger)lastIndexOf:(id _Nonnull)object inRange:(NSRange)range
{
    return (NSInteger)[self indexesOf:object inRange:range].lastIndex;
}

@end
