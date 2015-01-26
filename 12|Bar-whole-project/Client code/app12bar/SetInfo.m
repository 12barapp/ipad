//
//  SetInfo.m
//  app12bar
//
//  Created by Alex on 7/8/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "SetInfo.h"

@implementation SetInfo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(id)setInfo:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"SetInfo" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    SetInfo *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    return me;
}

-(void)showInfo:(NSString*)title author:(NSString*)author date:(NSString*)date location:(NSString*)location{
    self.setTitle.text = title;
    self.setDate.text = date;
    self.setLocation.text = location;
    self.setArtist.text = author;
}

- (IBAction)share:(id)sender {
    [self.delegate shareSet];
}
- (IBAction)edit:(id)sender {
    [self.delegate editSet];
}
- (IBAction)perform:(id)sender {
    [self.delegate performSet];
}
- (IBAction)delete:(id)sender {
    [self.delegate deleteSet];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)closeInfo:(id)sender {
    [self.delegate closeInfo];
}
@end
