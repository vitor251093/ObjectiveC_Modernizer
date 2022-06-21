//
//  VMMTask.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 02/01/20.
//  Copyright © 2020 VitorMM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMTask : NSObject

@property (nonatomic, strong, nullable) NSString* program;
@property (nonatomic, strong, nullable) NSArray<NSString*>* flags;
@property (nonatomic, strong, nullable) NSString* runPath;
@property (nonatomic, strong, nullable) NSDictionary* environment;
@property (nonatomic) unsigned int timeout;
@property (nonatomic) NSStringEncoding outputEncoding;

-(instancetype)init;
-(instancetype)initWithProgram:(NSString*)program;
-(instancetype)initWithProgram:(NSString*)program andFlags:(NSArray<NSString*>*)flags;
-(instancetype)initWithCommand:(NSArray<NSString*>*)programAndFlags;

-(NSString*)run;
-(void)runAsynchronous;

+(NSString*)getPathOfProgram:(NSString*)programName;

@end

NS_ASSUME_NONNULL_END
