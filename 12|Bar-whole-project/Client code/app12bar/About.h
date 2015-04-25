//
//  About.h
//  app12bar
//
//  Created by Alex on 7/10/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
@class About;
@protocol AboutDelegate

-(void)closeAbout;
-(void)launchMailFromAbout:(NSString*)email;

@end
@interface About : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (assign) id<AboutDelegate> delegate;
@property (assign) id<MFMailComposeViewControllerDelegate> mailDelegate;

@property UIViewController *parentViewController;

+ (id) about:(id)pickDelegate withMailDelegate:(id)mailDel withVC:(UIViewController*)vc;
@end
