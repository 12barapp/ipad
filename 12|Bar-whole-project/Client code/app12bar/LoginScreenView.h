//
//  LoginScreenView.h
//  app12bar
//
//  Created by Alex on 7/24/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginScreenView;
@protocol LoginScreenDelegate
-(void)loginWithFacebook;
-(void)loginWithEmail;
-(void)freeView;
@end

@interface LoginScreenView : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (assign)                     id<LoginScreenDelegate> delegate;
+ (id) loginScreen:(id)pickDelegate;
@end
