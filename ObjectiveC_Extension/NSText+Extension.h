//
//  NSText+Extension.h
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 22/02/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#ifndef NSText_Extension_Class
#define NSText_Extension_Class

#import <Cocoa/Cocoa.h>

@interface NSText (VMMText)
-(void)resetSelectedRangeToStart;
-(void)resetSelectedRangeToEnd;
@end

@interface NSTextView (VMMTextView)
-(void)setJustifiedAttributedString:(NSAttributedString*)string withColor:(NSColor*)color;
-(void)deselectText;
-(void)scrollToBottom;
@end

@interface NSTextField (VMMTextField)
-(void)resetSelectedRangeToStart;
-(void)resetSelectedRangeToEnd;
@end

#endif
