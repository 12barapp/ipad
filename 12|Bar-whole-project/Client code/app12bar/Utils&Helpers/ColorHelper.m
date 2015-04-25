//
//  ColorUtil.m
//  app12bar
//
//  Created by Alex on 8/12/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "ColorHelper.h"

@implementation ColorHelper
- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    unsigned hex;
    if (![scanner scanHexInt:&hex]){
        return nil;
    }
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

-(NSString*)getRandomRedString {
    NSArray *redColors = @[@"#fd2732", @"#e3363e", @"#e15a5d"];
    return redColors[arc4random()%redColors.count];
}

-(NSString*)getRandomBlueString {
    NSArray* blueColors = @[@"#36abe0", @"#5cb0d2", @"#7ec2d7"];
    return blueColors[arc4random()%blueColors.count];
}

-(UIColor*)getRandomBlueColor {
    NSArray* blueColors = @[@"#36abe0", @"#5cb0d2", @"#7ec2d7"];
    return [self colorWithHexString:blueColors[arc4random()%blueColors.count]];
}

-(UIColor*)getRandomRedColor {
    NSArray *redColors = @[@"#EA465A", @"#EE6B7B", @"#F07E8C", @"#F2909C", @"#F4A2AC"];
    return [self colorWithHexString:redColors[arc4random()%redColors.count]];
}

-(UIColor*)getBadgeRedColor {
    NSArray *redColors = @[@"#EA465A"];
    return [self colorWithHexString:redColors[arc4random()%redColors.count]];
}

@end
