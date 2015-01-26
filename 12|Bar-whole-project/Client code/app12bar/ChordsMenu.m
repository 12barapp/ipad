//
//  ChordsMenu.m
//  app12bar
//
//  Created by Alex on 7/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "ChordsMenu.h"

@implementation ChordsMenu


+ (id) chartMenu:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"ChordsMenu" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    ChordsMenu *me = [nibArray objectAtIndex:0];
    me.delegate = pickDelegate;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height-8;
   
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 5.0f, 1.0f, screenHeight/10-10);
    
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    me.searchBtn.frame = CGRectMake((screenWidth/8)*3, 0, screenWidth/8, screenHeight/10);
    
    me.orderBtn.frame = CGRectMake((screenWidth/8)*2, 0, screenWidth/8, screenHeight/10);
    me.plusBtn.frame = CGRectMake((screenWidth/8)*4, 0, screenWidth/8, screenHeight/10);
    
    [me.orderBtn.layer  addSublayer:bottomBorder];
    bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 5.0f, 1.0f, screenHeight/10-10);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [me.searchBtn.layer  addSublayer:bottomBorder];
    bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 5.0f, 1.0f, screenHeight/10-10);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [me.plusBtn.layer  addSublayer:bottomBorder];
    return me;
}


-(void)setSearchToGray{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 5.0f, 1.0f, screenSize.height/10-10);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [self.plusBtn.layer  addSublayer:bottomBorder];
   
    self.searchBtn.backgroundColor = [UIColor grayColor];
    self.searchBtn.layer.opacity = 0.5f;
}

-(void)orderCharts{
    
}
-(void) searchCharts {}
-(void) addChord {}

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
        [self.delegate loadNormalChords];
    }
        
}

- (IBAction)chordsOrder:(id)sender {
    [self restoreSearchButton];
    [self.delegate orderCharts];
}

- (IBAction)chordsSearch:(id)sender {
    if (self.searchBtn.backgroundColor != [UIColor grayColor]) {
        [self.delegate searchCharts];
    }
    [self restoreSearchButton];
    
}

- (IBAction)chordADd:(id)sender {
    [self restoreSearchButton];
    
    [self.delegate addChord];
}
@end
