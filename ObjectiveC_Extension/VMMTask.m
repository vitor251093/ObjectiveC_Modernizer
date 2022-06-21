//
//  VMMTask.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 02/01/20.
//  Copyright © 2020 VitorMM. All rights reserved.
//

#import "VMMTask.h"

#import "NSFileManager+Extension.h"
#import "NSMutableString+Extension.h"
#import "NSThread+Extension.h"

#import "VMMAlert.h"
#import "VMMLogUtility.h"
#import "VMMLocalizationUtility.h"

@implementation VMMTask

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.program = nil;
        self.flags = nil;
        self.runPath = @"/";
        self.environment = nil;
        self.timeout = 0;
        self.outputEncoding = NSUTF8StringEncoding;
    }
    return self;
}
-(instancetype)initWithProgram:(NSString*)program
{
    self = [self init];
    if (self) {
        self.program = program;
    }
    return self;
}
-(instancetype)initWithProgram:(NSString*)program andFlags:(NSArray<NSString*>*)flags
{
    self = [self init];
    if (self) {
        self.program = program;
        self.flags = flags;
    }
    return self;
}
-(instancetype)initWithCommand:(NSArray<NSString*>*)programAndFlags
{
    self = [self init];
    if (self) {
        NSArray* flags = [programAndFlags
                          objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, programAndFlags.count - 1)]];
        self.program = programAndFlags.firstObject;
        self.flags = flags;
    }
    return self;
}

-(BOOL)validateProperties
{
    if (_program && ![_program hasPrefix:@"/"])
    {
        NSString* newProgramPath = [VMMTask getPathOfProgram:_program];
        
        if (newProgramPath == nil)
        {
            [VMMAlert showAlertOfType:VMMAlertTypeError
                          withMessage:[NSString stringWithFormat:VMMLocalizedString(@"Path for %@ not found."), _program]];
            return FALSE;
        }
        
        _program = newProgramPath;
    }
    
#ifdef DEBUG
    if (_runPath && _flags) NSDebugLog(@"Running %@ at path %@ with flags %@",_program,_runPath,[_flags componentsJoinedByString:@" "]);
    else if (_runPath && !_flags)  NSDebugLog(@"Running %@ at path %@",_program,_runPath);
    else if (!_runPath && _flags)  NSDebugLog(@"Running %@ with flags %@",_program,[_flags componentsJoinedByString:@" "]);
    else if (!_runPath && !_flags) NSDebugLog(@"Running %@",_program);
#endif
    
    if (_runPath && ![_runPath hasSuffix:@"/"]) _runPath = [_runPath stringByAppendingString:@"/"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_program])
    {
        [VMMAlert showAlertOfType:VMMAlertTypeError
                      withMessage:[NSString stringWithFormat:VMMLocalizedString(@"File %@ not found."), _program]];
        return FALSE;
    }
    
    if (![[NSFileManager defaultManager] isExecutableFileAtPath:_program])
    {
        [VMMAlert showAlertOfType:VMMAlertTypeError
                      withMessage:[NSString stringWithFormat:VMMLocalizedString(@"File %@ not runnable."), _program]];
        return FALSE;
    }
    
    if (_runPath && ![[NSFileManager defaultManager] directoryExistsAtPath:_runPath])
    {
        [VMMAlert showAlertOfType:VMMAlertTypeError
                      withMessage:[NSString stringWithFormat:VMMLocalizedString(@"Directory %@ does not exists."), _runPath]];
        return FALSE;
    }
    
    return TRUE;
}
-(NSTask*)task
{
    NSTask *server = [NSTask new];
    [server setLaunchPath:_program];
    if (_runPath != nil)     [server setCurrentDirectoryPath:_runPath];
    if (_flags != nil)       [server setArguments:_flags];
    if (_environment != nil) [server setEnvironment:_environment];
    
    NSFileHandle *errorFileHandle = [NSFileHandle fileHandleWithNullDevice];
    [server setStandardError:errorFileHandle];
    [server setStandardInput:[NSPipe pipe]];
    
    return server;
}

-(NSString*)run
{
    if (![self validateProperties]) {
        return @"";
    }
    
    @autoreleasepool
    {
        @try
        {
            NSTask *server = [self task];
            
            NSPipe *outputPipe = [NSPipe pipe];
            [server setStandardOutput:outputPipe];
            [server launch];
            
            if (_timeout == 0)
            {
                [server waitUntilExit];
            }
            else
            {
                __block NSCondition* lock = [[NSCondition alloc] init];
                
                [NSThread dispatchQueueWithName:"wait-until-task-exit" priority:DISPATCH_QUEUE_PRIORITY_DEFAULT concurrent:NO withBlock:^
                 {
                     [server waitUntilExit];
                     
                     @synchronized (lock)
                     {
                         if (lock != nil) [lock signal];
                     }
                 }];
                
                [NSThread dispatchQueueWithName:"wait-to-kill-task" priority:DISPATCH_QUEUE_PRIORITY_DEFAULT concurrent:NO withBlock:^
                 {
                     [NSThread sleepForTimeInterval:self->_timeout];
                     
                     @synchronized (lock)
                     {
                         if (lock != nil)
                         {
                             [lock signal];
                             [server terminate];
                         }
                     }
                 }];
                
                [lock lock];
                [lock wait];
                [lock unlock];
                lock = nil;
            }
            
            NSFileHandle *file = [outputPipe fileHandleForReading];
            NSData *outputData = [file readDataToEndOfFile];
            [file closeFile];
            
            NSDebugLog(@"Instruction finished");
            return [[NSString alloc] initWithData:outputData encoding:_outputEncoding];
        }
        @catch (NSException* exception)
        {
            // Sometimes (very rarely) the app might fail to retrieve the output of a command; with that, your app won't stop
            NSDebugLog(@"Failed to retrieve instruction output: %@", exception.reason);
            return @"";
        }
    }
}
-(void)runAsynchronous
{
    if (![self validateProperties]) {
        return;
    }
    
    @autoreleasepool
    {
        @try
        {
            [[self task] launch];
            
            NSDebugLog(@"Instruction finished");
        }
        @catch (NSException* exception)
        {
            // Sometimes (very rarely) the app might fail to retrieve the output of a command; with that, your app won't stop
            NSDebugLog(@"Failed to retrieve instruction output: %@", exception.reason);
        }
    }
}

+(NSString*)getPathOfProgram:(NSString*)programName
{
    if (programName == nil) return nil;
    
    NSString* programPath;
    
    @autoreleasepool
    {
        programPath = [[[VMMTask alloc] initWithProgram:@"/usr/bin/type" andFlags:@[@"-a", programName]] run];
        if (programPath == nil) return nil;
        
        programPath = [[programPath componentsSeparatedByString:@" "] lastObject];
        if (programPath.length == 0) return nil;
        
        programPath = [programPath substringToIndex:programPath.length-1];
    }
    
    return programPath;
}

@end
