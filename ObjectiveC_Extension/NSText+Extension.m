//
//  NSText+Extension.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 22/02/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import "NSText+Extension.h"

#import "NSMutableAttributedString+Extension.h"

#import "VMMComputerInformation.h"

@implementation NSText (VMMText)
-(void)resetSelectedRangeToStart
{
    [self setSelectedRange:NSMakeRange(0,0)];
}
-(void)resetSelectedRangeToEnd
{
    [self setSelectedRange:NSMakeRange(self.string.length,0)];
}
@end

@implementation NSTextView (VMMTextView)
-(void)setJustifiedAttributedString:(NSAttributedString*)string withColor:(NSColor*)color
{
    NSMutableAttributedString* str = string ? [string mutableCopy] : [[NSMutableAttributedString alloc] init];
    
    [self scrollRangeToVisible:NSMakeRange(0,0)];
    [self setSelectedRange:NSMakeRange(0, 0)];
    
    if (color != nil) [str setFontColor:color];
    
    // NSTextAlignment values changed in macOS 10.11
    // https://developer.apple.com/library/content/releasenotes/AppKit/RN-AppKitOlderNotes/index.html#10_11DynamicTracking
    
    [str setTextJustified];
    
    [[self textStorage] setAttributedString:str];
}
-(void)deselectText
{
    [self setSelectable:NO];
    [self setSelectable:YES];
}
-(void)scrollToBottom
{
    // Reference:
    // https://stackoverflow.com/a/28708474/4370893 
    
    NSPoint pt = NSMakePoint(0, 100000000000.0);
    
    id scrollView = [self enclosingScrollView];
    id clipView = [scrollView contentView];
    
    pt = [clipView constrainScrollPoint:pt];
    [clipView scrollToPoint:pt];
    [scrollView reflectScrolledClipView:clipView];
}
@end

@implementation NSTextField (VMMTextField)
-(void)resetSelectedRangeToStart
{
    [[self currentEditor] resetSelectedRangeToStart];
}
-(void)resetSelectedRangeToEnd
{
    [[self currentEditor] resetSelectedRangeToEnd];
}
@end

