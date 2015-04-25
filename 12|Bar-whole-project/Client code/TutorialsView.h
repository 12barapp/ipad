//
//  TutorialsView.h
//  app12bar
//
//  Created by Noah Labhart on 3/27/15.
//  Copyright (c) 2015 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialsView : UIView <UIScrollViewDelegate>

typedef enum TutorialSet: NSInteger
{
    TutorialSetCharts,
    TutorialSetSets,
    TutorialSetHome,
    TutorialSetAll
} TutorialSet;

@property NSArray *screens;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property id<UIScrollViewDelegate> parentScrollViewDelegate;

+ (id) tutorials:(TutorialSet)setChoice;
- (void)initScrollViewDelegation;

@end
