//
//  SetInfo.h
//  app12bar
//
//  Created by Alex on 7/8/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetInfo;
@protocol SetInfoDelegate
-(void)closeInfo;
-(void)deleteSet;
-(void)editSet;
-(void)performSet;
-(void)shareSet;
@end

@interface SetInfo : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property(assign)                      id<SetInfoDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *setTitle;
@property (strong, nonatomic) IBOutlet UILabel *setLocation;
@property (strong, nonatomic) IBOutlet UILabel *setDate;
@property (strong, nonatomic) IBOutlet UILabel *setArtist;
- (IBAction)closeInfo:(id)sender;
+(id)setInfo:(id)pickDelegate;
-(void)showInfo:(NSString*)title author:(NSString*)author date:(NSString*)date location:(NSString*)location;
@end
