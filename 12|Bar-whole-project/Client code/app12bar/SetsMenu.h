//
//  SetsMenu.h
//  app12bar
//
//  Created by Alex on 7/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SetsMenu;
@protocol SetsMenuDelegate

-(void)SetOrder;
-(void)SetSearch;
-(void)SetNew;
-(void)loadNormalSets;
@end

@interface SetsMenu : UIView

- (IBAction)setsOrder:(id)sender;
- (IBAction)setsSearch:(id)sender;
- (IBAction)setsNew:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn;
@property (strong, nonatomic) IBOutlet UIButton *orderBtn;


@property(assign)id<SetsMenuDelegate> delegate;
+(id)setsMenu:(id)pickDelegate;
-(void)setSearchToGray;
@end
