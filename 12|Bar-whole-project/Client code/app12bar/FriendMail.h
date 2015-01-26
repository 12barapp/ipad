//
//  FriendMail.h
//  app12bar
//
//  Created by Alex on 7/10/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class FriendMail;
@protocol FriendMailDelegate

-(void)cancelMail;
-(void)sendMail:(NSString*)to andMes:(NSString*)m;

@end
@interface FriendMail : UIView<MFMailComposeViewControllerDelegate>
@property(assign)id<FriendMailDelegate> delegate;

+ (id) friendMail:(id)pickDelegate;

@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (strong, nonatomic) IBOutlet UITextField *mailToText;
@property (strong, nonatomic) IBOutlet UITextField *mailFromText;
@property (strong, nonatomic) IBOutlet UIView *mailHead;
@property (strong, nonatomic) IBOutlet UIView *toContainer;
@property (strong, nonatomic) IBOutlet UIView *fromContainer;
@property (strong, nonatomic) IBOutlet UIView *subjectContainer;
@property (strong, nonatomic) IBOutlet UITextView *mailText;
@end
