//
//  ChartInfo.m
//  app12bar
//
//  Created by Alex on 7/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "ChartInfo.h"

@implementation ChartInfo
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)showInfo:(NSString*)title author:(NSString*)author key:(NSString*)key time:(NSString*)time bpm:(NSString*)bpm genre:(NSString*)genre{
    self.titleInfo.text = title;
    self.authorInfo.text = author;
    self.genreInfo.text = genre;
    self.ontherInfo.text = [NSString stringWithFormat:@"%@ • %@ • %@",key,time,bpm];
}

- (IBAction)closeInfo:(id)sender {
    [self.delegate closeInfo];
}

-(void)closeInfo{
    
}
- (IBAction)share:(id)sender {
    [self.delegate chordShare];
}
- (IBAction)edit:(id)sender {
    [self.delegate chordEdit];
}
- (IBAction)perform:(id)sender {
    [self.delegate chordPerform];
}
- (IBAction)delete:(id)sender {
    [self.delegate chordDelete];
}



+ (id) chartInfo:(id)pickDelegate{
    
    UINib *nib = [UINib nibWithNibName:@"ChartInfo" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    ChartInfo *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
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
