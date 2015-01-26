//
//  NSAttributedString+height.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "NSAttributedString+height.h"

@implementation NSAttributedString (Height)
- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth {
    CGFloat height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString ( (CFMutableAttributedStringRef) self);
    CGRect box = CGRectMake(0,0, inWidth, CGFLOAT_MAX);
    
    CFIndex startIndex = 0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, box);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
    
    CFArrayRef lineArray = CTFrameGetLines(frame);
    CFIndex j = 0, lineCount = CFArrayGetCount(lineArray);
    CGFloat lineHeight, ascent, descent, leading;
    
    for (j=0; j < lineCount; j++) {
        CTLineRef currentLine = (CTLineRef)CFArrayGetValueAtIndex(lineArray, j);
        CTLineGetTypographicBounds(currentLine, &ascent, &descent, &leading);
        lineHeight = ascent + descent + leading;
        height += lineHeight;
    }
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    
    return height;
}

@end
