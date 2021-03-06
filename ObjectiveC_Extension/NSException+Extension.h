//
//  NSException+Extension.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 19/12/2017.
//  Copyright © 2017 VitorMM. All rights reserved.
//

#import <Foundation/Foundation.h>

NSException* _Nonnull exception(NSString* _Nonnull name, NSString* _Nonnull reason);

@interface NSException (VMMException)

+(nonnull NSException*)exceptionWithError:(nonnull NSError*)error;

@end
