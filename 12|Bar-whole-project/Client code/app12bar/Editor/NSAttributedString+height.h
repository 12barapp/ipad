//
//  NSAttributedString+height.h
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <CoreText/CoreText.h>

@interface NSAttributedString (Height)
-(CGFloat)boundingHeightForWidth:(CGFloat)inWidth;
@end
