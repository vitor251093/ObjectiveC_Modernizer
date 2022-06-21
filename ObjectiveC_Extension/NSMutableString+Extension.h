//
//  NSMutableString+Extension.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 04/11/2017.
//  Copyright © 2017 VitorMM. All rights reserved.
//

#ifndef NSMutableString_Extension_Class
#define NSMutableString_Extension_Class

#import <Foundation/Foundation.h>

@interface NSMutableString (VMMMutableString)

-(void)replace:(nonnull NSString *)target with:(nonnull NSString *)replacement;

-(void)replaceRegex:(nonnull NSString *)target with:(nonnull NSString *)replacement;

-(nonnull NSMutableString*)trim;

@end

#endif
