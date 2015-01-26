//
//  FriendEmailTyper.h
//  app12bar
//
//  Created by Vasiliy Alifanov on 9/1/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendEmailTyper;

@protocol FrienEmilDelegate
-(void)cancelEmailSharing;
-(void)doneEmailSharing:(NSString*)friendEmail forSet:(BOOL)setSharing;
@end

@interface FriendEmailTyper : UIView

@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (assign)                     id<FrienEmilDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic, assign)          BOOL sharingSet;
+ (id) emailFriend:(id)pickDelegate;
@end
