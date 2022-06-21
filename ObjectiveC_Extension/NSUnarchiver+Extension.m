//
//  NSUnarchiver+Extension.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 22/02/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import "NSUnarchiver+Extension.h"

#import "NSData+Extension.h"

@implementation NSUnarchiver (VMMUnarchiver)

+(nullable id)safeUnarchiveObjectFromFile:(nonnull NSString*)path
{
    @autoreleasepool
    {
        return [self unarchiveObjectWithData:[NSData safeDataWithContentsOfFile:path]];
    }
}

@end
