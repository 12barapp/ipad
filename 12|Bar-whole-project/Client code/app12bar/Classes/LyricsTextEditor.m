//
//  LyricsTextEditor.m
//  app12bar
//
//  Created by Alex on 8/8/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "LyricsTextEditor.h"

@implementation LyricsTextEditor


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        someChords = [[NSMutableArray alloc] init];
        partsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark DropZone delegate
-(void)droppedView:(int)pos{
    [partsArray addObject:[NSNumber numberWithInt:pos]];
    [self setNeedsDisplay];
}

-(void)deleteView:(int)pos{
    for (int  i = 0; i < partsArray.count; i++) {
        if ([[partsArray objectAtIndex:i] intValue] == pos) {
            [partsArray removeObjectAtIndex:i];
        }
    }
     [self setNeedsDisplay];
}

-(void)setPerformMode{
    self.isPerformMode = true;
}

#pragma mark D&G
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
    // NSLog(@"AtkSampleOneDropZoneView.dragExited");
    // self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}

- (void)dragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //NSLog(@"AtkSampleOneDropZoneView.dragMoved");
}



-(void)deleteChord:(UITapGestureRecognizer*)sender{
    [sender.view removeFromSuperview];
    NSString* idForRemoving = [(LyricsDragSource*)sender.view getMyId];
    if (idForRemoving != nil)
        
        
        for (int i = 0; i < someChords.count; i++) {
            NSDictionary *dcForRemoving = [someChords objectAtIndex:i];
            if ([dcForRemoving[@"uniqueId"] isEqualToString:idForRemoving]) {
                [someChords removeObjectAtIndex:i];
                [(LyricsDragSource*)sender.view removeFromSuperview];
            }
        }
}

- (void)dragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    BOOL canDrop = true;
    NSArray *views = [(UIView*)((id<AtkDragSourceProtocol>)[manager getDataSource]) subviews];
    {
        NSString* someKey = [[NSString alloc] init];
        if ([views count] == 2){
            someKey = ((UILabel*)[views objectAtIndex:1]).text;
            if (((UILabel*)[views objectAtIndex:1]).tag == 1) {
                canDrop = false;
            }
        }
        else{
            someKey = ((UILabel*)[views objectAtIndex:0]).text;
            if (((UILabel*)[views objectAtIndex:0]).tag == 1) {
                canDrop = false;
            }
        }
        if (canDrop) {
            CGRect screenBound = [[UIScreen mainScreen] bounds];
            CGSize screenSize = screenBound.size;
            
            int screenHeight = screenSize.height;
            time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
            float newRowY = round((([manager getLocation].y - screenHeight/10)+35)/60)*51.5f;
            float rows = roundf( (self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom) / 50 );
            
            if (newRowY/50 >= rows) {
                newRowY -= 50;
            }
            if ([manager getLocation].x >= (self.frame.size.width - 50)) {
                NSLog(@"Need remove");
            }
            
            
            
            float areaWidth = 25.0f;
            NSString *chordMod = [(LyricsDragSource*)[manager getDataSource] getModifierForChord];
            if (chordMod == nil) {
                chordMod = @"";
            } else {
                CGSize stringSize = [chordMod sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];//[chordMod sizeWithFont:[UIFont systemFontOfSize:15]];
                
                CGFloat width = stringSize.width;
                areaWidth += width+30;
                
            }
            
            NSDictionary *dc = @{@"y":[NSString stringWithFormat:@"%f",newRowY+((UIScrollView*)self.superview).contentOffset.y],@"x":[NSString stringWithFormat:@"%f",[manager getLocation].x-self.frame.origin.x], @"key_char":[(LyricsDragSource*)[manager getDataSource] getMetadata] , @"metadata":chordMod, @"uniqueId":[NSString stringWithFormat:@"%ld",unixTime]};
            [someChords addObject:dc];
            
            LyricsDragSource *chordView = [[LyricsDragSource alloc] initWithFrame:CGRectMake([manager getLocation].x-self.frame.origin.x, newRowY+((UIScrollView*)self.superview).contentOffset.y, areaWidth, 25)];
            [chordView setMetadata:[(LyricsDragSource*)[manager getDataSource] getMetadata]];
            [chordView setChordModifier:[(LyricsDragSource*)[manager getDataSource] getModifierForChord]];
            chordView.layer.borderColor = [UIColor grayColor].CGColor;
            chordView.layer.borderWidth = 2.0f;
            [chordView setInText:YES];
            chordView.backgroundColor = [UIColor whiteColor];
            [chordView setMyId:[NSString stringWithFormat:@"%ld",unixTime]];
            if (!self.isPerformMode){
                UITapGestureRecognizer *double_tap_recognizer;
                double_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteChord:)];
                [double_tap_recognizer setNumberOfTapsRequired:2];
                [chordView addGestureRecognizer:double_tap_recognizer];
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, areaWidth, 25)];
            if ([views count] == 2){
                label.text = [NSString stringWithFormat:@"%@ %@",[((LyricsDragSource*)((UILabel*)[views objectAtIndex:1]).superview) getMetadata], chordMod];
            }
            else{
                label.text = [NSString stringWithFormat:@"%@ %@",[((LyricsDragSource*)((UILabel*)[views objectAtIndex:0]).superview) getMetadata], chordMod];
            }
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [chordView addSubview:label];
            [self addSubview:chordView];
        }
    }
    NSArray *mySubViews = [self subviews];
    if ([mySubViews count] != 0)
        for (NSObject* chord in mySubViews) {
            if ([chord isKindOfClass:[LyricsDragSource class]]){
                if ([(LyricsDragSource*)chord isShouldRemove]){
                    if (((LyricsDragSource*)chord).tag == 100){
                        NSString* idForRemoving = [(LyricsDragSource*)chord getMyId];
                        for (int i = 0; i < someChords.count; i++) {
                            NSDictionary *dcForRemoving = [someChords objectAtIndex:i];
                            if ([dcForRemoving[@"uniqueId"] isEqualToString:idForRemoving]) {
                                NSLog(@"Remove chord %@",dcForRemoving);
                                [someChords removeObjectAtIndex:i];
                            }
                        }
                        [(LyricsDragSource*)chord removeFromSuperview];
                    }
                }
            }
        }
}

-(void)addExistingChords:(NSMutableArray*)chordsArray andTitle:(NSString*)title{
    for (int c = 0; c < chordsArray.count; c++){
        //  LyricsDragSource *draggableChord = [[LyricsDragSource alloc] initWithFrame:CGRectMake([[[chordsArray objectAtIndex:c] valueForKey:@"x"] floatValue]-self.frame.origin.x, ([[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue]- self.superview.frame.origin.y)-self.frame.size.height, 30, 30)];
        float areaWidth = 25.0f;
        NSString *chordMod = [[chordsArray objectAtIndex:c] valueForKey:@"metadata"];
        if (chordMod == nil || [chordMod isEqualToString:@""]) {
            chordMod = @"";
        } else {
            CGSize stringSize = [chordMod sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];//[chordMod sizeWithFont:[UIFont systemFontOfSize:15]];
            CGFloat width = stringSize.width;
            areaWidth += width+30;
        }
        LyricsDragSource *draggableChord = [[LyricsDragSource alloc] initWithFrame:CGRectMake([[[chordsArray objectAtIndex:c] valueForKey:@"x"] floatValue], [[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue], areaWidth, 25)];
        [draggableChord setMetadata:[[chordsArray objectAtIndex:c] valueForKey:@"key_char"]];
        [draggableChord setChordModifier:[[chordsArray objectAtIndex:c] valueForKey:@"metadata"]];
         if (!self.isPerformMode) {
             draggableChord.backgroundColor = [UIColor whiteColor];
             draggableChord.layer.borderColor = [UIColor grayColor].CGColor;
            draggableChord.layer.borderWidth = 2.0f;
             [draggableChord setInText:YES];
            if (!self.isPerformMode){
                UITapGestureRecognizer *double_tap_recognizer;
                double_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteChord:)];
                [double_tap_recognizer setNumberOfTapsRequired:2];
                [draggableChord addGestureRecognizer:double_tap_recognizer];
             }
        }
                [draggableChord setMyId:[[chordsArray objectAtIndex:c] valueForKey:@"uniqueId"]];
        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, areaWidth, 25)];
        lb.textColor = [UIColor grayColor];
        if (self.isPerformMode) {
            if (!isLight) {
                lb.textColor = [UIColor whiteColor];
            } else {
                lb.textColor = [UIColor grayColor];
            }
        }
        
        [lb setText:[NSString stringWithFormat:@"%@ %@",[[chordsArray objectAtIndex:c] valueForKey:@"key_char"],[[chordsArray objectAtIndex:c] valueForKey:@"metadata"]]];
      //  lb.frame = CGRectMake(0, 0, lb.co, 30)
        lb.textAlignment = NSTextAlignmentCenter;
        [draggableChord addSubview:lb];
        [self addSubview:draggableChord];
        
        NSString *cId = [[chordsArray objectAtIndex:c] valueForKey:@"uniqueId"];
        if (cId == nil) {
            cId = @"null";
        }
       
        NSDictionary *dc = @{@"y":[NSString stringWithFormat:@"%f",[[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue]],@"x":[NSString stringWithFormat:@"%f",[[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue]],@"key_char":[[chordsArray objectAtIndex:c] valueForKey:@"key_char"],@"uniqueId":cId, @"metadata":chordMod};
        [someChords addObject:dc];
    }
}


-(void)changeToLightTheme{
    self.textColor = [UIColor grayColor];
    self.backgroundColor = [UIColor whiteColor];
    isLight = true;
}

-(void)changeToDarkTheme{
    [self setTextColor:[UIColor whiteColor]];
    self.backgroundColor = [self colorWithHexString:@"#4d4d4d"];
    isLight = false;
}


#pragma mark TextView methods

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString*)text andWidth:(CGFloat)width
{
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height + 50; // 5O is your gap for example
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
        [self calcHeight:textView];
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(paste:)) {
       // [self.lyricsDelegate updateForHeight:self.frame.size.height];
        [self calcHeight:self];
        
       
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
     [self calcHeight:textView];
   // [self setNeedsDisplay];
}



-(void)textViewDidEndEditing:(UITextView *)textView{
        [self calcHeight:textView];
   // [self setNeedsDisplay];
}


- (void)textViewDidChange:(UITextView *)textView{
  //  [self setNeedsDisplay];
    [self calcHeight:textView];
     NSLog(@"textViewDidChange ");
}

-(void)calcHeight:(UITextView*)textView{
  
    CGRect frame;
    frame = self.frame;
    frame.size.height = self.contentSize.height;
    
    self.frame = frame;
    
    float rows = roundf( (self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom) / 50 );
    if ((int)rows%2 != 0) {
        [self.lyricsDelegate updateForHeight:frame.size.height+50];
    }else
        [self.lyricsDelegate updateForHeight:frame.size.height];
    [self setContentOffset:CGPointZero animated:NO];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float rows = roundf( (self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom) / 50 );
       CGContextRef context = UIGraphicsGetCurrentContext();
    NSLog(@"Count of rows %f",rows);
    if (isLight)
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f].CGColor);
    else
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextBeginPath(context);
    for (int i = 0; i < (NSInteger)rows; i++){
        if (i%2 == 0) {
            if (partsArray.count != 0) {
                int vr = i/2;
                for (int c = 0; c < partsArray.count; c++) {
                    if ([[partsArray objectAtIndex:c] intValue] == vr){
                        if ((i+i*50)+i > 20){
                            CGContextMoveToPoint(context, self.bounds.origin.x+10,(i+i*50)+i);
                            CGContextAddLineToPoint(context, self.bounds.size.width-10, (i+i*50)+i);
                        }
                        
                    }
                }
            }
        }
        
    }
    CGContextClosePath(context);
    CGContextStrokePath(context);

    
    
}

- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    unsigned hex;
    if (![scanner scanHexInt:&hex]){
        return nil;
    }
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}


#pragma mark Public methods

-(void)setSelftText:(NSString*)text{
    self.text = text;
    [self setNeedsDisplay];
}

-(NSString*)getSelfText{
    return self.text;
}

-(void)updateLines{
    CGRect frame;
    frame = self.frame;
    frame.size.height = [self contentSize].height;
 //   self.frame = frame;
    
    
    float rows = roundf( (self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom) / 50 );
    if ((int)rows%2 != 0) {
        [self.lyricsDelegate updateForHeight:self.contentSize.height+50];
    }else
        [self.lyricsDelegate updateForHeight:self.contentSize.height];
    [self setNeedsDisplay];
}

-(NSMutableArray*)getSelfChords{
    return someChords;
}
@end
