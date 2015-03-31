//
//  TutorialsView.m
//  app12bar
//
//  Created by Noah Labhart on 3/27/15.
//  Copyright (c) 2015 Vasilkoff LTD. All rights reserved.
//

#import "TutorialsView.h"

@implementation TutorialsView

@synthesize screens;

+ (id) tutorials:(TutorialSet)setChoice
{
    UINib *nib = [UINib nibWithNibName:@"TutorialDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    TutorialsView *me = [nibArray objectAtIndex: 0];
    
    switch (setChoice) {
        case TutorialSetHome:
            me.screens = @[
                           @"12Bar_Homescreen_Tuts-01.png",
                           @"12Bar_Homescreen_Tuts-02.png",
                           @"12Bar_Homescreen_Tuts-03.png",
                           @"12Bar_Homescreen_Tuts-04.png",
                           @"12Bar_Homescreen_Tuts-05.png",
                           @"12Bar_Homescreen_Tuts-06.png"
                         ];
            
            break;
        case TutorialSetCharts:
            me.screens = @[
                          @"12Bar_Charts_Tuts-01.png",
                          @"12Bar_Charts_Tuts-02.png"
                         ];
            break;
        case TutorialSetSets:
            me.screens = @[
                           @"12Bar_Sets_Tuts-01.png"
                           ];
            break;
        case TutorialSetAll:
            me.screens = @[
                           @"12Bar_Homescreen_Tuts-01.png",
                           @"12Bar_Homescreen_Tuts-02.png",
                           @"12Bar_Homescreen_Tuts-03.png",
                           @"12Bar_Homescreen_Tuts-04.png",
                           @"12Bar_Homescreen_Tuts-05.png",
                           @"12Bar_Homescreen_Tuts-06.png",
                           @"12Bar_Charts_Tuts-01.png",
                           @"12Bar_Charts_Tuts-02.png",
                           @"12Bar_Sets_Tuts-01.png"
                           ];
            break;
        default:
            me.screens = @[
                           @"12Bar_Homescreen_Tuts-01.png",
                           @"12Bar_Homescreen_Tuts-02.png",
                           @"12Bar_Homescreen_Tuts-03.png",
                           @"12Bar_Homescreen_Tuts-04.png",
                           @"12Bar_Homescreen_Tuts-05.png",
                           @"12Bar_Homescreen_Tuts-06.png",
                           @"12Bar_Charts_Tuts-01.png",
                           @"12Bar_Charts_Tuts-02.png",
                           @"12Bar_Sets_Tuts-01.png"
                           ];
            break;
    }
    
    [me addTutorialImages:me.screens forScrollView:me.scrollView];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    me.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                     me.scrollView.frame.origin.y +  me.scrollView.frame.size.height + 20.0,
                                                                     screenWidth,
                                                                     50.0)];
    me.pageControl.numberOfPages = me.screens.count;
    me.pageControl.currentPage = 1;
    
    [me addSubview:me.pageControl];
    
    return me;
}

- (void)addTutorialImages:(NSArray *)screensPassed forScrollView:(UIScrollView *)sv {
    
    int posX = 0;
    int sharedHeight = 680;
    int sharedWidth = 756;
    
    for (NSString *tutFileName in screensPassed) {
        
        UIImage *image = [UIImage imageNamed:tutFileName];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = CGRectMake(posX,
                                   0,
                                   sharedWidth,
                                   sharedHeight);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        [sv addSubview:imgView];
        
        posX += sharedWidth;
    }

    sv.contentSize = CGSizeMake((sharedWidth * screens.count), sharedHeight);
}

@end
