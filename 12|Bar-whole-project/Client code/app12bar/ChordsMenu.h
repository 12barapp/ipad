//
//  ChordsMenu.h
//  app12bar
//
//  Created by Alex on 7/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChordsMenu;
@protocol ChordsMenuDelegate

-(void)orderCharts;
-(void)searchCharts;
-(void)addChord;
-(void)loadNormalChords;
@end

@interface ChordsMenu : UIView
@property (assign) id<ChordsMenuDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UIButton *orderBtn;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn;



- (IBAction)chordsOrder:(id)sender;
- (IBAction)chordsSearch:(id)sender;
- (IBAction)chordADd:(id)sender;
-(void)setSearchToGray;
+ (id) chartMenu:(id)pickDelegate;
@end
