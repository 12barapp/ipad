//
//  LyricsDropZone.m
//  app12bar
//
//  Created by Alex on 7/29/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "LyricsDropZone.h"

@implementation LyricsDropZone




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lyricsText = [[NSString alloc] init];
        lyricsText = @"";
        selfValue = @"";
        redColors = @[@"#fd2732", @"#e3363e", @"#e15a5d", @"#df7c7e", @"#ec9c9d"];
        someChords = [[NSMutableArray alloc] init];
        self.zonePosition = 0;
    }
    return self;
}

-(void)setPerformMode{
    self.isPerform = true;
}

- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    return YES;
}

- (BOOL)isInterested:(AtkDragAndDropManager *)manager
{
 //   NSLog(@"AtkSampleOneDropZoneView.isInterested");
    
    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *tagValue = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    NSString *pasteboardString = pastebaord.string;
    
    return [tagValue isEqualToString:pasteboardString];
}

- (void)dragStarted:(AtkDragAndDropManager *)manager
{
  //  NSLog(@"AtkSampleOneDropZoneView.dragStarted");
    self.savedBackgroundColor = self.backgroundColor;
    
    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *tagValue = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    NSString *pasteboardString = pastebaord.string;
    
    if([tagValue isEqualToString:pasteboardString])
    {
        //self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    else
    {
        //self.backgroundColor = [UIColor redColor];
    }
}

- (void)dragEnded:(AtkDragAndDropManager *)manager
{
    [self performSelector:@selector(delayEnd) withObject:nil afterDelay:0.4];
}

-(void)initForChordsContainer:(BOOL)bl{
    isChordsContainer = bl;
}

- (void)delayEnd
{
    self.backgroundColor = self.savedBackgroundColor;
}

- (void)dragEntered:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //self.backgroundColor = [UIColor orangeColor];
}

- (void)dragExited:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    // self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}

- (void)dragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"AtkSampleOneDropZoneView.dragMoved");
}

-(void)deleteChord:(UITapGestureRecognizer*)sender{
    [sender.view removeFromSuperview];
    selfValue = @"";
  /*  NSArray* sv = [sender.view subviews];
    LyricsDragSource *ds = (LyricsDragSource*)sender.view;
    NSString* idForRemoving = [ds getMyId];
    if (idForRemoving != nil)
        
        
        for (int i = 0; i < someChords.count; i++) {
            NSDictionary *dcForRemoving = [someChords objectAtIndex:i];
            if ([dcForRemoving[@"uniqueId"] isEqualToString:idForRemoving]) {
                [someChords removeObjectAtIndex:i];
                [(LyricsDragSource*)sender.view removeFromSuperview];
            }
        }*/
}

-(void)deletePart:(UITapGestureRecognizer*)sender{
    [sender.view removeFromSuperview];
    selfValue = @"";
    [self.editorDelegate deleteView:self.zonePosition];

}


- (void)dragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    [self.editorDelegate refreshDrawArea];
    NSArray *views = [(UIView*)((id<AtkDragSourceProtocol>)[manager getDataSource]) subviews];
    if ([views count] !=0)
        if (![((LyricsDragSource*)[manager getDataSource]) likeChord]){
            [self.editorDelegate  droppedView:self.zonePosition];
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            v.backgroundColor = [[ColorHelper alloc] colorWithHexString:redColors[arc4random()%redColors.count]];//[UIColor redColor];
            UIButton *partBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            selfValue = [((LyricsDragSource*)[manager getDataSource]) getMetadata];
            NSString* mData = [((LyricsDragSource*)[manager getDataSource]) getMetadata];
            [partBtn setTitle:mData forState:(UIControlStateNormal)];
            partBtn.layer.zPosition = 99;
            [partBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 10.0, 10.0)];
            [partBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            partBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            partBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
            partBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [partBtn setNeedsDisplay];
            [v addSubview:partBtn];
            
            //[v addSubview:titleLabel];
            if (!self.isPerform){
                UITapGestureRecognizer *double_tap_recognizer;
                double_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletePart:)];
                [double_tap_recognizer setNumberOfTapsRequired:2];
                [v addGestureRecognizer:double_tap_recognizer];
            }
            
            [self addSubview:v];
            [self.editorDelegate refreshDrawArea];
        }
    NSArray *mySubViews = [self subviews];
    if ([mySubViews count] != 0)
        for (NSObject* chord in mySubViews) {
            
            if ([chord isKindOfClass:[LyricsDragSource class]]){
                if ([(LyricsDragSource*)chord isShouldRemove]){
                    if (((LyricsDragSource*)chord).tag == 100){
                        [(LyricsDragSource*)chord removeFromSuperview];
                    }
                }
            }
        }
}


-(void)addLyticsPartWithTitle:(NSString*)title{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    v.backgroundColor = [[ColorHelper alloc] colorWithHexString:redColors[arc4random()%redColors.count]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 50, 25)];
    [titleLabel setText:title];
    selfValue = title;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.backgroundColor = [UIColor grayColor];
 
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.layer.zPosition = 99;
    
    UIButton *partBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [partBtn setTitle:title forState:(UIControlStateNormal)];
    partBtn.layer.zPosition = 99;
    [partBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 10.0, 10.0)];
    partBtn.backgroundColor = [UIColor clearColor];
    partBtn.titleLabel.textColor = [UIColor whiteColor];
    partBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    partBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    partBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [v addSubview:partBtn];
    if (!self.isPerform){
        UITapGestureRecognizer *double_tap_recognizer;
        double_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletePart:)];
        [double_tap_recognizer setNumberOfTapsRequired:2];
        [v addGestureRecognizer:double_tap_recognizer];
    }

    [self addSubview:v];

}

-(void)addExistingChords:(NSMutableArray*)chordsArray andTitle:(NSString*)title{
    for (int c = 0; c < chordsArray.count; c++){
        LyricsDragSource *draggableChord = [[LyricsDragSource alloc] initWithFrame:CGRectMake([[[chordsArray objectAtIndex:c] valueForKey:@"x"] floatValue]-self.frame.origin.x, ([[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue]- self.superview.frame.origin.y)-self.frame.size.height, 30, 30)];
        draggableChord.backgroundColor = [UIColor redColor];
        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [lb setText:[[chordsArray objectAtIndex:c] valueForKey:@"key_char"]];
        lb.textColor = [UIColor whiteColor];
        lb.textAlignment = NSTextAlignmentCenter;
//        lb.backgroundColor = [UIColor grayColor];
        [draggableChord addSubview:lb];
        [self addSubview:draggableChord];
        
        
        
        NSDictionary *dc = @{@"y":[NSString stringWithFormat:@"%f",[[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue]],@"x":[NSString stringWithFormat:@"%f",[[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue]],@"key_char":[[chordsArray objectAtIndex:c] valueForKey:@"key_char"]};
        [someChords addObject:dc];
    }
}

-(void)setSelfTextEdtor:(UITextView*)textView{
    self.txt = textView;
}
-(void)setActiveTextEditor{
    //self.txt.selectedRange = NSMakeRange(3, 0);
    [self.txt becomeFirstResponder];
}


-(void)setSelfLyric:(NSString*)lyric{
    lyricsText = lyric;
}

-(NSMutableArray*)getChords{
    return someChords;
}

-(NSString*)getSelfLyric{
    return lyricsText;
}

-(NSString*)getSelfValue{
    return selfValue;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    // pretend there's more vertical space to get that extra line to check on
    CGSize tallerSize = CGSizeMake(textView.frame.size.width-15, textView.frame.size.height);
    
    CGSize newSize = [newText sizeWithFont:textView.font constrainedToSize:tallerSize lineBreakMode:UILineBreakModeWordWrap];
   
    if (newSize.height > 60)
    {
        CALayer *bottomBorder = [CALayer layer];
        
        bottomBorder.frame = CGRectMake(10.0f, textView.frame.size.height-3.0f, textView.frame.size.width-20.0f, 1.0f);
        
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                         alpha:1.0f].CGColor;
        [textView.layer addSublayer:bottomBorder];
        [self.delegate typeInNextEditor:(NSInteger*)textView.tag];
        return NO;
    }
    
    return YES;

}

- (void)textViewDidChange:(UITextView *)textView{
    lyricsText = textView.text;
   
    
}


@end
