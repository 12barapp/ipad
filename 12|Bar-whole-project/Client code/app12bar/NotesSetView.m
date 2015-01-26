//
//  NotesSetView.m
//  app12bar
//
//  Created by Alex on 8/9/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "NotesSetView.h"

@implementation NotesSetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)doneNotes:(id)sender {
    [self.delegate saveNotes:self.notesText.text];
}


+ (id) notesDialog:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"NotesSetDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    NotesSetView *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    me.notesIcoBtn.frame = CGRectMake(0, 0, screenWidth/8, screenHeight/10);
    return me;
}



-(void)showNotes:(NSString*)notes{
    self.notesText.text = notes;
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
