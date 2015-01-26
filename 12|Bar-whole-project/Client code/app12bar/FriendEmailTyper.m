//
//  FriendEmailTyper.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 9/1/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "FriendEmailTyper.h"

@implementation FriendEmailTyper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)doneEmailSharing:(id)sender {
    if (self.sharingSet == YES) {
        [self.delegate doneEmailSharing:self.emailField.text forSet:YES];
    } else {
        [self.delegate doneEmailSharing:self.emailField.text forSet:NO];
    }
    
}

- (IBAction)cancelEmailSharing:(id)sender {
    [self.delegate cancelEmailSharing];
}

+ (id) emailFriend:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"ShareEmail" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    FriendEmailTyper *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    [me.emailField becomeFirstResponder];
    me.delegate = pickDelegate;
    return me;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
