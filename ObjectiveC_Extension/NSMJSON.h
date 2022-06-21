//
//  VMMJSON.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 10/06/22.
//  Copyright © 2022 VitorMM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMJSON : NSObject

+(nullable NSString*)serializeToString:(nonnull id)object;
+(nullable NSData*)serializeToData:(nonnull id)object;
+(nullable id)deserializeFromData:(nonnull NSData*)data;

@end

NS_ASSUME_NONNULL_END
