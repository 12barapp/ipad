//
//  FriendMail.m
//  app12bar
//
//  Created by Alex on 7/10/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "FriendMail.h"

@implementation FriendMail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (id) friendMail:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"FriendMail" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    FriendMail *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 43.0f, me.mailHead.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    
    [me.mailHead.layer addSublayer:bottomBorder];
    
    bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 43.0f, me.mailToText.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [me.mailToText.layer addSublayer:bottomBorder];
    [me.fromContainer.layer addSublayer:bottomBorder];
    [me.subjectContainer.layer addSublayer:bottomBorder];
    return me;
}

- (IBAction)doneMail:(id)sender {
    [self.delegate sendMail:self.mailToText.text andMes:self.mailText.text];
}
- (IBAction)cancelMail:(id)sender {
    [self.delegate cancelMail];
}
- (IBAction)sendMail:(id)sender {
    [self checkEmailAndDisplayAlert];
    
}

- (void)checkEmailAndDisplayAlert {
    if(![self validateEmail:[self.mailToText text]]) {
        // user entered invalid email address
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
    } else {
        NSArray *toRecipents = [self.mailToText.text componentsSeparatedByString:@","];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:@"Check out 12Bar"];
        [mc setToRecipients:toRecipents];
        [mc setMessageBody:self.mailText.text isHTML:NO];
        
        [self.delegate sendMail:self.mailToText.text andMes:self.mailText.text];
       // [self presentViewController:mc animated:YES completion:NULL];
    }
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


@end
