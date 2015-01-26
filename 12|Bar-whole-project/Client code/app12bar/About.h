//
//  About.h
//  app12bar
//
//  Created by Alex on 7/10/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class About;
@protocol AboutDelegate

-(void)closeAbout;

@end
@interface About : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (assign)                     id<AboutDelegate> delegate;
+ (id) about:(id)pickDelegate;
@end
