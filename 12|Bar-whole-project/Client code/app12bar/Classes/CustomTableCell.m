//
//  CustomTableCell.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 12/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "CustomTableCell.h"
#import "PerformSetController.h"

@implementation CustomTableCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 96, 102)];
        infoView.backgroundColor = [UIColor colorWithRed:(255.0/255.0)
                                                   green:(102.0/255.0)
                                                    blue:(102.0/255.0)
                                                   alpha:1.0];
        
        [self.backgroundView addSubview:infoView];
    }
    return self;
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:1.0];
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

-(void)setUniqueId:(NSString*)uid{
    uniqueID = uid;
}

-(NSString*)getUniqueId{
    return uniqueID;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];
    
    if (!self.isPerform) {
        
        for (UIView * view in self.subviews)
        {
            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound)
                for (UIView * subview in view.subviews)
                    if ([subview isKindOfClass: [UIImageView class]])
                    {
                        UIImageView *reorderButton = (UIImageView *)subview;
                        [reorderButton setFrame:CGRectMake(15,
                                                           47,
                                                           22,
                                                           8.5)];
                        NSLog(@"%f %f %f %f", reorderButton.frame.origin.x,
                                              reorderButton.frame.origin.y,
                                              reorderButton.frame.size.width,
                                              reorderButton.frame.size.height);
//                        [reorderButton setImage:[UIImage imageNamed: @"set_list_menu.png"]];
//                        [reorderButton.layer setOpacity:0.75];
    //                    [reorderButton setContentMode:UIViewContentModeScaleAspectFit];
    //                    [reorderButton.layer setBorderColor:[UIColor greenColor].CGColor];
    //                    [reorderButton.layer setBorderWidth:1.0];

                    }
        }
        
        float buffer = 3.0;
        float commonHeight = 18;
        float commonY = 25;
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 96, 100)];
        infoView.backgroundColor = [UIColor colorWithRed:(255.0/255.0)
                                                   green:(102.0/255.0)
                                                    blue:(102.0/255.0)
                                                   alpha:1.0];

        UILabel *smallTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        commonY,
                                                                        infoView.frame.size.width - buffer,
                                                                        commonHeight)];
        [self setupInfoLabel:smallTitle];
        smallTitle.text = self.smallTitle;
        
        UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    commonY + smallTitle.frame.size.height,
                                                                    infoView.frame.size.width - buffer,
                                                                    commonHeight)];
        [self setupInfoLabel:author];
        author.text = self.author;
        
        UILabel *otherInfo = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                       commonY + smallTitle.frame.size.height + author.frame.size.height,
                                                                       infoView.frame.size.width - buffer,
                                                                       commonHeight)];
        
        [self setupInfoLabel:otherInfo];
        otherInfo.text = self.otherInfo;
        
        UILabel *genre = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   commonY + smallTitle.frame.size.height + author.frame.size.height + otherInfo.frame.size.height,
                                                                   infoView.frame.size.width - buffer,
                                                                   commonHeight)];
        [self setupInfoLabel:genre];
        genre.text = self.genre;
        
        UIButton *largeTitle = [[UIButton alloc] initWithFrame:CGRectMake(infoView.frame.size.width + 75,
                                                                        0,
                                                                        450,
                                                                        102)];
        [largeTitle setTitle:self.smallTitle forState:UIControlStateNormal];
        [largeTitle setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [largeTitle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [largeTitle setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        [largeTitle.titleLabel setFont:[UIFont systemFontOfSize:22.0]];
        [largeTitle addTarget:self action:@selector(launchChordChart) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *infoButton = [[UIButton alloc] initWithFrame:infoView.frame];
        [infoButton addTarget:self action:@selector(showInfoForChord:) forControlEvents:UIControlEventTouchUpInside];
        
        [infoView addSubview:smallTitle];
        [infoView addSubview:author];
        [infoView addSubview:otherInfo];
        [infoView addSubview:genre];
        [infoView addSubview:infoButton];
        
        [self addSubview:infoView];
        [self addSubview:largeTitle];
    }
}

- (void)setupInfoLabel:(UILabel *)label {
    [label setFont:[UIFont systemFontOfSize:13.0]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentRight];
}

-(void)showInfoForChord:(id)sender{
    [self.delegate showChartInfo:self];
}

-(void)launchChordChart {
    [self.delegate launchChordChart:self];
}

- (IBAction)titleTappedForPerform:(id)sender {
    [self.delegate launchChordChart:self];
}
@end
