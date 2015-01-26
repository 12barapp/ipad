//
//  EmailTyper.h
//  app12bar
//
//  Created by Alex on 8/27/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmailTyper;
@protocol EmailTyperDelegate
-(void)cancelEmail;
-(void)loginWithEmail:(NSString*)email;
@end

@interface EmailTyper : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (assign)                     id<EmailTyperDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *emailField;

+ (id) emailTyper:(id)pickDelegate;
@end
