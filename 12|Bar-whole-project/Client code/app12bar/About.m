//
//  About.m
//  app12bar
//
//  Created by Alex on 7/10/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "About.h"

@implementation About

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id) about:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"About" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    About *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
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
}

- (IBAction)openJonnyInstagram:(id)sender {
}

- (IBAction)writeEmailForJonny:(id)sender {
}

- (IBAction)openRichFB:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/richwilliamsmba"]];
    }else
    [self openLinkInSafari:@"https://www.facebook.com/richwilliamsmba"];
}

- (IBAction)openRichTwitter:(id)sender {
}

- (IBAction)openRichInstagram:(id)sender {
}

- (IBAction)writeEmailForRich:(id)sender {
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
}

- (IBAction)writeEmailForBar:(id)sender {
}


-(void)openLinkInSafari:(NSString*)link{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

@end
