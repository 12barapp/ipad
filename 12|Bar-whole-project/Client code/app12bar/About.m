//
//  About.m
//  app12bar
//
//  Created by Alex on 7/10/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "About.h"
#import <MessageUI/MFMailComposeViewController.h>

@implementation About

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id) about:(id)pickDelegate withMailDelegate:(id)mailDel withVC:(UIViewController*)vc{
    UINib *nib = [UINib nibWithNibName:@"About" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    About *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    me.mailDelegate = mailDel;
    me.parentViewController = vc;
    return me;
}

- (IBAction)closeAbout:(id)sender {
    [self.delegate closeAbout];
}

- (IBAction)openJonnyFB:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/thejonnymack"]];
    }else
    [self openLinkInSafari:@"https://www.facebook.com/thejonnymack"];
}

- (IBAction)openJonnyTwitter:(id)sender {
    [self openLinkInSafari:@"https://twitter.com/jonny_mack"];
}

- (IBAction)openJonnyInstagram:(id)sender {
    [self openLinkInSafari:@"https://instagram.com/jonnymack"];
}

- (IBAction)writeEmailForJonny:(id)sender {
    [self openMail:@"jonny@12barapp.com"];
}

- (IBAction)openRichFB:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/richwilliamsmba"]];
    }else
    [self openLinkInSafari:@"https://www.facebook.com/richwilliamsmba"];
}

- (IBAction)openRichTwitter:(id)sender {
    [self openLinkInSafari:@"https://twitter.com/richwilliamsmba"];
}

- (IBAction)openRichInstagram:(id)sender {
    [self openLinkInSafari:@"https://instagram.com/richwilliamsmba/"];
}

- (IBAction)writeEmailForRich:(id)sender {
    [self openMail:@"rich@12barapp.com"];
}

- (IBAction)openBarFB:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/12barapp"]];
    }else
    [self openLinkInSafari:@"https://www.facebook.com/12barapp"];
}

- (IBAction)openBarTwitter:(id)sender {
    [self openLinkInSafari:@"https://twitter.com/12barapp/"];
}

- (IBAction)openBarInstagram:(id)sender {
    [self openLinkInSafari:@"https://instagram.com/12barapp"];
}

- (IBAction)writeEmailForBar:(id)sender {
    [self openMail:@"12barapp@gmail.com"];
}


-(void)openLinkInSafari:(NSString*)link{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

-(void)openMail:(NSString*)email {
    [self.delegate launchMailFromAbout:email];
}

@end
