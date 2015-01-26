//
//  ColorUtil.h
//  app12bar
//
//  Created by Alex on 8/12/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorHelper : NSObject
- (UIColor *)colorWithHexString:(NSString *)stringToConvert;
-(UIColor*)getRandomBlueColor;
-(UIColor*)getRandomRedColor;
-(NSString*)getRandomRedString;
-(NSString*)getRandomBlueString;
@end
