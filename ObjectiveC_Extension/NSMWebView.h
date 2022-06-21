//
//  VMMWebView.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 30/10/2017.
//  Copyright © 2017 VitorMM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "VMMView.h"
#import "NSMComputerInformation.h"

#define VMMWebViewSupportsHTML5     IS_SYSTEM_MAC_OS_10_9_OR_SUPERIOR

@interface NSMWebView : VMMView

@property (nonatomic) BOOL urlLoaded;
@property (nonatomic) BOOL usingWkWebView;
@property (nonatomic, strong, nullable) NSView* webView;

-(BOOL)loadURL:(nonnull NSURL*)url;
-(void)loadHTMLString:(nonnull NSString*)htmlPage;

@end

