//
//  LoginScreenView.m
//  app12bar
//
//  Created by Alex on 7/24/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "LoginScreenView.h"

@implementation LoginScreenView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id) loginScreen:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"LoginScreen" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    LoginScreenView *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    return me;

}

- (IBAction)loginWithFB:(id)sender {
    [self.delegate loginWithFacebook];
}
- (IBAction)loginWithEmail:(id)sender {
    [self.delegate loginWithEmail];
}
- (IBAction)onlyView:(id)sender {
    [self.delegate freeView];
}

@end
