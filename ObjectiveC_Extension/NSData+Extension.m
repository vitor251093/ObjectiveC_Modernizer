//
//  NSData+Extension.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 22/02/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import "NSData+Extension.h"

#import "SZJsonParser.h"

#import "VMMAlert.h"
#import "NSException+Extension.h"
#import "NSMutableString+Extension.h"

#import "NSMComputerInformation.h"
#import "NSMLocalizationUtility.h"

@implementation NSData (VMMData)

+(nullable NSData*)safeDataWithContentsOfFile:(nonnull NSString*)filePath
{
    NSData* data;
    
    @autoreleasepool
    {
        NSError *error = nil;
        data = [[NSData alloc] initWithContentsOfFile:filePath options:0 error:&error];
        
        if (error != nil)
        {
            @throw [NSException exceptionWithError:error];
        }
    }
    
    return data;
}

-(nonnull NSString*)base64EncodedString
{
    if (![self respondsToSelector:@selector(base64EncodedStringWithOptions:)])
    {
        return [self base64Encoding];
    }
    
    return [self base64EncodedStringWithOptions:0];
}

@end
