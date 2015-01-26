//
//  ChartInfo.h
//  app12bar
//
//  Created by Alex on 7/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChartInfo;
@protocol ChartInfoDelegate

-(void)chordShare;
-(void)chordEdit;
-(void)chordPerform;
-(void)chordDelete;

-(void)closeInfo;

@end

@interface ChartInfo : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (assign)                     id<ChartInfoDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *titleInfo;
@property (strong, nonatomic) IBOutlet UILabel *authorInfo;
@property (strong, nonatomic) IBOutlet UILabel *genreInfo;
@property (strong, nonatomic) IBOutlet UILabel *ontherInfo;

-(void)showInfo:(NSString*)title author:(NSString*)author key:(NSString*)key time:(NSString*)time bpm:(NSString*)bpm genre:(NSString*)genre;
- (IBAction)closeInfo:(id)sender;
+ (id) chartInfo:(id)pickDelegate;
@end
