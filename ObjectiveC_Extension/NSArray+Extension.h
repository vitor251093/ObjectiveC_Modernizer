//
//  NSArray+Extension.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 15/05/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSArray<ObjectType> (VMMArray)

-(BOOL)contains:(nonnull id)anObject;
-(BOOL)containsAll:(nonnull NSArray*)array;
-(nullable ObjectType)get:(NSUInteger)index;
-(nonnull NSMutableArray*)map:(_Nullable id (^_Nonnull)(id _Nonnull object))newObjectForObject;
-(nonnull NSMutableArray*)mapWithIndex:(_Nullable id (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject;
-(nonnull NSMutableArray*)filter:(BOOL (^_Nonnull)(id _Nonnull object))newObjectForObject;
-(nonnull NSMutableArray*)filterWithIndex:(BOOL (^_Nonnull)(id _Nonnull object, NSUInteger index))newObjectForObject;
-(nonnull instancetype)forEach:(void (^_Nonnull)(id _Nonnull object))newObjectForObject;

-(NSIndexSet* _Nonnull)indexesOf:(ObjectType _Nonnull)object inRange:(NSRange)range;
-(NSIndexSet* _Nonnull)indexesOf:(ObjectType _Nonnull)object;

-(NSInteger)lastIndexOf:(ObjectType _Nonnull)object inRange:(NSRange)range;

@end
