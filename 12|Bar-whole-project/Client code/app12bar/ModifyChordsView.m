//
//  ModifyChordsView.m
//  app12bar
//
//  Created by Alex on 8/14/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "ModifyChordsView.h"

@implementation ModifyChordsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id) modifyChordsDialog:(id)pickDelegate andSecondDelegate:(id)sDelegate{
    UINib *nib = [UINib nibWithNibName:@"ModifyChordsDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    ModifyChordsView *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    me.delegate2 = sDelegate;
    return me;

}

- (IBAction)done:(id)sender {
    if ((self.tempModifier != nil) && ![self.tempModifier isEqualToString:@""]) {
        self.tempModifier = [self.tempModifier stringByReplacingOccurrencesOfString:@"Major " withString:@""];
        self.tempModifier = [self.tempModifier stringByReplacingOccurrencesOfString:@"Major" withString:@""];
        self.tempModifier = [self.tempModifier stringByReplacingOccurrencesOfString:@"Minor " withString:@"m"];
         self.tempModifier = [self.tempModifier stringByReplacingOccurrencesOfString:@"Minor" withString:@"m"];
        
        [self.delegate setChordModifier:self.tempModifier];
        [self.delegate setKeyModifier:self.tempModifier];
        [self.delegate makeCustom];
    }
        [self.delegate2 closeKeyDialog];
    // [self.delegate setMetadataForChord:sender.titleLabel.text ];
}


-(IBAction)setChord:(UIButton*)sender{
    if (self.prevButton == nil) {
        
    } else {
        self.prevButton.backgroundColor = [UIColor clearColor];
        self.prevButton.layer.opacity = 1.0f;
    }
    self.prevButton = sender;
    sender.backgroundColor = [UIColor lightGrayColor];
    sender.layer.opacity = 0.5f;
    self.tempModifier = sender.titleLabel.text;
    
    [self done:nil];
}
- (IBAction)close:(id)sender {
    [self.delegate2 closeKeyDialog];
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
