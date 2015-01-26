//
//  SetsMenu.m
//  app12bar
//
//  Created by Alex on 7/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "SetsMenu.h"

@implementation SetsMenu
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(id)setsMenu:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"SetsMenu" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    SetsMenu *me = [nibArray objectAtIndex:0];
    me.delegate = pickDelegate;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height-8;
    
    
    
   
    me.searchBtn.frame = CGRectMake((screenWidth/8)*3, 0, screenWidth/8, screenHeight/10);
    me.orderBtn.frame = CGRectMake((screenWidth/8)*2, 0, screenWidth/8, screenHeight/10);
    me.plusBtn.frame = CGRectMake((screenWidth/8)*4, 0, screenWidth/8, screenHeight/10);
    
    CALayer *bottomBorder = [CALayer layer];

    bottomBorder.frame = CGRectMake(0.0f, 5.0f, 1.0f, screenHeight/10-10);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
   
    
    [me.searchBtn.layer  addSublayer:bottomBorder];
    bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 5.0f, 1.0f, screenHeight/10-10);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [me.plusBtn.layer  addSublayer:bottomBorder];
    bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 5.0f, 1.0f, screenHeight/10-10);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [me.orderBtn.layer  addSublayer:bottomBorder];
    
    return me;
}
-(void)SetOrder{};
-(void)SetSearch{};
-(void)SetNew{};

-(void)setSearchToGray{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 5.0f, 1.0f, screenSize.height/10-10);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;        
    [self.plusBtn.layer  addSublayer:bottomBorder];
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 0.0f, 0.0f, screenSize.height/10-10);
    bottomBorder.backgroundColor = [UIColor clearColor].CGColor;
    [self.orderBtn.layer  addSublayer:bottomBorder];
    self.searchBtn.backgroundColor = [UIColor grayColor];
    self.searchBtn.layer.opacity = 0.5f;
}

-(void)restoreSearchButton {
    if (self.searchBtn.backgroundColor == [UIColor grayColor]) {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, 5.0f, 1.0f, screenSize.height/10-10);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                         alpha:1.0f].CGColor;
        [self.plusBtn.layer  addSublayer:bottomBorder];
        self.searchBtn.backgroundColor = [UIColor clearColor];
        self.searchBtn.layer.opacity = 1.0f;
        [self.delegate loadNormalSets];
    }
        
}

- (IBAction)setsOrder:(id)sender {
    [self restoreSearchButton];
    [self.delegate SetOrder];
}

- (IBAction)setsSearch:(id)sender {
    if (self.searchBtn.backgroundColor != [UIColor grayColor]) {
        [self.delegate SetSearch];
    }
    [self restoreSearchButton];
}

- (IBAction)setsNew:(id)sender {
    [self restoreSearchButton];
    [self.delegate SetNew];
}


@end
