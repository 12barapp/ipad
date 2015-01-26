//
//  NotesDlg.m
//  app12bar
//
//  Created by Alex  on 7/28/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "NotesDlg.h"

@implementation NotesDlg

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (id) notesDialog:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"NotesDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    NotesDlg *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    me.noteIcoBtn.frame = CGRectMake(0, 0, screenWidth/8, screenHeight/10);
    return me;
}

-(void)showNotes:(NSString*)notes{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    self.noteIcoBtn.frame = CGRectMake(0, 0, screenWidth/8, screenHeight/10);
    self.notesText.text = notes;
    self.notesText.delegate = self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self.delegate setTextChanged];
    return YES;
}

- (IBAction)doneNotes:(id)sender {
    [self.delegate saveNotes:self.notesText.text];
    
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
