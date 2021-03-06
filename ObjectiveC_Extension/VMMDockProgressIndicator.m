//
//  VMMDockProgressIndicator.m
//  ObjectiveC_Extension
//
//  Copyright (c) 2014, hokein
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the <organization> nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.

//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  Reference:
//  https://github.com/hokein/DockProgressBar
//

#import "VMMDockProgressIndicator.h"

#import "NSBundle+Extension.h"
#import "NSColor+Extension.h"

@implementation VMMDockProgressIndicator

static VMMDockProgressIndicator* progress_bar;

+ (nonnull VMMDockProgressIndicator*)sharedInstance
{
    NSDockTile* dock_tile = [NSApp dockTile];
    
    if (!progress_bar)
    {
        progress_bar = [[VMMDockProgressIndicator alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, dock_tile.size.width, 15.0f)];
        [progress_bar setStyle:NSProgressIndicatorBarStyle];
        [progress_bar setIndeterminate:NO];
        [progress_bar setBezeled:YES];
        [progress_bar setMinValue:0];
        [progress_bar setMaxValue:1];
    }
    
    if (dock_tile.contentView == nil)
    {
        NSImage* contentViewImage;
        
        @try
        {
            contentViewImage = [NSApp applicationIconImage];
        }
        @catch(NSException* exception)
        {
            NSBundle* mainBundle = [NSBundle realMainBundle];
            
            @try
            {
                contentViewImage = [mainBundle bundleIcon];
            }
            @catch(NSException* otherException)
            {
                [exception raise];
            }
        }
        
        NSImageView* contentView = [[NSImageView alloc] init];
        [contentView setImage:contentViewImage];
        [dock_tile setContentView:contentView];
        [contentView addSubview:progress_bar];
    }
    
    return progress_bar;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = NSInsetRect(self.bounds, 1.0, 1.0);
    CGFloat radius = rect.size.height / 2;
    NSBezierPath* bezier_path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
    [bezier_path setLineWidth:2.0];
    [[NSColor grayColor] set];
    [bezier_path stroke];
    
    // Fill the rounded rect.
    rect = NSInsetRect(rect, 2.0, 2.0);
    radius = rect.size.height / 2;
    bezier_path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
    [bezier_path setLineWidth:1.0];
    [bezier_path addClip];
    
    // Calculate the progress width.
    rect.size.width = floor(rect.size.width * ((self.doubleValue - self.minValue) / (self.maxValue - self.minValue)));
    
    // Fill the progress bar with color blue.
    [RGB(51, 153, 255) set];
    NSRectFill(rect);
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    [[NSApp dockTile] display];
}

- (void)setDoubleValue:(double)doubleValue
{
    [super setDoubleValue:doubleValue];
    [[NSApp dockTile] display];
}

@end
