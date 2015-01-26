//
//  ChangeKeysView.m
//  app12bar
//
//  Created by Alex on 8/14/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "ChangeKeysView.h"

@implementation ChangeKeysView


+ (id) changeKeysDialog:(id)pickDelegate andSecondDelegate:(id)sDelegate{
    UINib *nib = [UINib nibWithNibName:@"ChangeKeysAction" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    ChangeKeysView *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = sDelegate;
    return me;
}

-(IBAction)keyClicked:(UIButton*)sender{
    [self.delegate setNewSongKey:sender.titleLabel.text];
    [self.delegate closeKeyDialog];
}

- (IBAction)closeDialog:(id)sender {
    [self.delegate closeKeyDialog];
}



@end
