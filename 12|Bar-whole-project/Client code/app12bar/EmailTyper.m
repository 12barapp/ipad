//
//  EmailTyper.m
//  app12bar
//
//  Created by Alex on 8/27/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "EmailTyper.h"

@implementation EmailTyper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (IBAction)cancelLogiWithEmail:(id)sender {
    [self.delegate cancelEmail];
}


- (IBAction)doneEmail:(id)sender {
    if ([self validateEmail:self.emailField.text]) {
        [self.delegate loginWithEmail:self.emailField.text];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}


+ (id) emailTyper:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"EnterEmail" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    EmailTyper *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    [me.emailField becomeFirstResponder];
    me.delegate = pickDelegate;
    return me;
}

@end
