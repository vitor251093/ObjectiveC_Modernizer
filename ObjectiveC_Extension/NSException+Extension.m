//
//  NSException+Extension.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 19/12/2017.
//  Copyright © 2017 VitorMM. All rights reserved.
//

#import "NSException+Extension.h"

NSException* _Nonnull exception(NSString* _Nonnull name, NSString* _Nonnull reason)
{
    return [NSException exceptionWithName:name reason:reason userInfo:nil];
}

@implementation NSException (VMMException)

+(nonnull NSException*)exceptionWithError:(nonnull NSError*)error
{
    return [NSException exceptionWithName:NSGenericException reason:error.localizedDescription userInfo:error.userInfo];
}

@end
