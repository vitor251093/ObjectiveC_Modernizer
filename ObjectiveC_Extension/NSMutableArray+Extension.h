//
//  NSMutableArray+Extension.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 24/07/2017.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray<ObjectType> (VMMMutableArray)

-(void)add:(nonnull id)anObject;
-(void)add:(nonnull id)anObject atIndex:(NSUInteger)index;
-(void)addAll:(nonnull NSArray *)otherArray;
-(void)clear;
-(nonnull NSMutableArray*)filter:(BOOL (^_Nonnull)(id _Nonnull object))newObjectForObject;
-(nonnull NSMutableArray*)filterWithIndex:(BOOL (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject;
-(nonnull NSMutableArray*)map:(_Nullable id (^_Nonnull)(id _Nonnull object))newObjectForObject;
-(nonnull NSMutableArray*)mapWithIndex:(_Nullable id (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject;
-(void)removeAll:(nonnull NSArray*)array;

-(void)sortBySelector:(SEL _Nonnull)selector usingComparator:(NSInteger (^_Nonnull)(id _Nonnull object1, id _Nonnull object2))comparator;

@end
