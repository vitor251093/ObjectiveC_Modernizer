//
//  VMMWebView.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 30/10/2017.
//  Copyright © 2017 VitorMM. All rights reserved.
//

#import "NSMWebView.h"

#import "NSColor+Extension.h"
#import "NSException+Extension.h"
#import "NSString+Extension.h"
#import "NSMutableAttributedString+Extension.h"

#import "NSMComputerInformation.h"
#import "NSMLocalizationUtility.h"

@implementation NSMWebView

// Private functions that may be overrided
-(BOOL)shouldLoadUrl:(NSURL*)urlToOpenUrl withHttpBody:(NSData*)httpBody
{
    return YES;
}

// WebView needed delegates
-(WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    return sender;
}
-(void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request
         frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    NSData* httpBody = request.HTTPBody;
    
    NSURL* url = actionInformation[WebActionOriginalURLKey];
    if (![self shouldLoadUrl:url withHttpBody:httpBody]) return;
    
    [listener use];
}

// WKWebView needed delegates
- (id)webView:(id)webView createWebViewWithConfiguration:(id)configuration forNavigationAction:(id)navigationAction windowFeatures:(id)windowFeatures
{
    NSData* httpBody = ((WKNavigationAction *)navigationAction).request.HTTPBody;
    
    NSURL* url = ((WKNavigationAction *)navigationAction).request.URL;
    if (![self shouldLoadUrl:url withHttpBody:httpBody]) return nil;
    
    [self loadURL:url];
    return nil;
}
- (void)webView:(id)webView decidePolicyForNavigationAction:(id)navigationAction decisionHandler:(void (^)(NSInteger))decisionHandler
{
    NSData* httpBody = ((WKNavigationAction *)navigationAction).request.HTTPBody;
    
    NSURL *urlToOpenUrl = ((WKNavigationAction *)navigationAction).request.URL;
    if (![self shouldLoadUrl:urlToOpenUrl withHttpBody:httpBody])
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
- (void)webView:(id)webView didCommitNavigation:(id)navigation
{
    
}

// Initialization private methods
-(void)initializeWebView
{
    _usingWkWebView = IsClassWKWebViewAvailable;
    
    if (_usingWkWebView)
    {
        _webView = [[WKWebView alloc] init];
        WKWebView* webView = (WKWebView*)_webView;
        
        webView.UIDelegate = (id<WKUIDelegate>)self;
        webView.navigationDelegate = (id<WKNavigationDelegate>)self;
        
        webView.allowsMagnification = true;
        
        [webView setValue:@FALSE forKey:@"opaque"];
        
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
        BOOL setDrawsBackgroundExists = [webView respondsToSelector:@selector(_setDrawsBackground:)];
#pragma GCC diagnostic pop
        
        if (setDrawsBackgroundExists)
        {
            [webView setValue:@FALSE forKey:@"drawsBackground"];
        }
        else
        {
            [webView setValue:@TRUE  forKey:@"drawsTransparentBackground"];
        }
    }
    else
    {
        _webView = [[WebView alloc] init];
        WebView* webView = (WebView*)_webView;
        
        webView.UIDelegate = (id<WebUIDelegate>)self;
        webView.policyDelegate = (id<WebPolicyDelegate>)self;
        webView.frameLoadDelegate = (id<WebFrameLoadDelegate>)self;
        
        webView.shouldUpdateWhileOffscreen = false;
        
        @try		
        {		
            [webView setValue:@FALSE forKey:@"opaque"];		
        }		
        @catch (NSException *exception)		
        {		
            @try		
            {		
                [webView setValue:@FALSE forKey:@"isOpaque"];		
            }		
            @catch (NSException *exception) {}		
        }
        
        [webView setValue:@FALSE forKey:@"drawsBackground"];
    }
    
    [self addSubview:_webView];
    [_webView setAutoresizingMask:NSViewMinYMargin|NSViewMaxXMargin|NSViewMinXMargin|NSViewWidthSizable|NSViewHeightSizable];
}
-(void)reloadWebViewIfNeeded
{
    @synchronized(self)
    {
        BOOL loadingForTheFirstTime = (_webView == nil);
        
        CGFloat width = self.frame.size.width;
        
        if (loadingForTheFirstTime)
        {
            [self initializeWebView];
        }
        
        CGFloat webViewHeight = self.frame.size.height;
        
        [_webView setFrame:NSMakeRect(0, 0, width, webViewHeight)];
    }
}

// Public functions
-(BOOL)loadURL:(nonnull NSURL*)url
{
    if (!_usingWkWebView && [url.absoluteString contains:@"://www.youtube.com/v/"])
    {
        NSString* mainFolderPluginPath = @"/Library/Internet Plug-Ins/Flash Player.plugin";
        NSString* userFolderPluginPath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),mainFolderPluginPath];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:mainFolderPluginPath] &&
            ![[NSFileManager defaultManager] fileExistsAtPath:userFolderPluginPath])
        {
            @throw exception(NSInvalidArgumentException, @"You need Flash Player in order to watch YouTube videos in your macOS version");
        }
    }
    
    _urlLoaded = true;
    [self reloadWebViewIfNeeded];
    
    if (_usingWkWebView)
    {
        [(WKWebView*)self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else
    {
        [((WebView*)self.webView).mainFrame loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
    return YES;
}
-(void)loadHTMLString:(nonnull NSString*)htmlPage
{
    _urlLoaded = false;
    [self reloadWebViewIfNeeded];
    NSURL* url = [NSURL URLWithString:@"about:blank"];
    
    if (_usingWkWebView)
    {
        [(WKWebView*)self.webView loadHTMLString:htmlPage baseURL:url];
    }
    else
    {
        [((WebView*)self.webView).mainFrame loadHTMLString:htmlPage baseURL:url];
    }
}

@end

