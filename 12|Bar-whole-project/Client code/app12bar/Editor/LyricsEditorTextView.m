//
//  TextEditor.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "LyricsEditorTextView.h"
#import "AtkDragAndDrop.h"
#import "LyricsDragSource.h"
#import "LyricsDropZone.h"
#import "AtkDragAndDrop.h"


#define TEXT_FONT_SIZE 21.0
#define Y_OFFSET 3
#define LABEL_WIDTH 25.0F
#define LABEL_HEIGHT 25.0F
#define AREA_WIDTH 25.0F
#define AREA_HEIGHT 25.0F
#define REMOVABLE_TAGE 100
#define MAXIMUM_LINE_HEIGHT 51.200001f
#define MINIMUM_LINE_HEIGHT 51.200001f


@interface LyricsEditorTextView ()  <AtkDropZoneProtocol, UITextViewDelegate> {
    BOOL drawPointer;
    BOOL isLight;
    CGPoint pointerPosition;
}
@end

@implementation LyricsEditorTextView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        drawPointer = false;
        self.delegate = self;
        self.backgroundColor = [UIColor orangeColor];
        self.userInteractionEnabled = YES;
        [self setFont:[UIFont fontWithName:@"Helvetica Neue" size:TEXT_FONT_SIZE]];
        someChords = [[NSMutableArray alloc] init];
        chordObjects = [[NSMutableArray alloc] init];
        partsArray = [[NSMutableArray alloc] init];
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth_ = screenSize.width;
        CGFloat screenHeight_ = screenSize.height;
        screenHeight = screenHeight_;
        screenWidth = screenWidth_;
        isLight = YES;
        isChanged = false;
        [self setUserInteractionEnabled:YES];
        
        UITextField *lagFreeField = [[UITextField alloc] init];
        [self.window addSubview:lagFreeField];
        [lagFreeField becomeFirstResponder];
        [lagFreeField resignFirstResponder];
        [lagFreeField removeFromSuperview];
    }
    return self;
}

-(BOOL)wasEdited{
    return isChanged;
}

-(NSMutableArray*)getChordsForUpdate{
    return chordObjects;
}

-(void)setPerformMode {
    self.isPerformMode = true;
}

-(void)changeToLightTheme{
    self.textColor = [UIColor grayColor];
    self.backgroundColor = [UIColor whiteColor];
    isLight = YES;
}


-(void)changeToDarkTheme{
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:@"#4d4d4d"];
    isLight = NO;
}

-(void)setSelftText:(NSString*)text{
    
}

-(void)updateChordWithTitle:(NSString*)title index:(int)idx{
    NSDictionary *dc = [[someChords objectAtIndex:idx] mutableCopy];
    [dc setValue:title forKey:@"key_char"];
    [someChords replaceObjectAtIndex:idx withObject:dc];
}

-(void)updateChordWithY:(int)yPos index:(NSString*)idx{
    for (int i = 0; i < someChords.count; i++) {
        if ([[someChords objectAtIndex:i][@"uniqueId"] isEqualToString:idx]) {
            NSDictionary *dc = [[someChords objectAtIndex:i] mutableCopy];
            [dc setValue:[NSString stringWithFormat:@"%d",yPos] forKey:@"y"];
            [someChords replaceObjectAtIndex:i withObject:dc];
        }
    }
    
}

-(NSMutableArray*)getSelfChords{
    return someChords;
}

-(NSString*)getSelfText{
    return self.text;
}




-(void)deleteChord:(UITapGestureRecognizer*)sender{
    NSString* idForRemoving = [(LyricsDragSource*)sender.view getMyId];
    if (idForRemoving != nil)
        isChanged = true;
        
        for (int i = 0; i < someChords.count; i++) {
            NSDictionary *dcForRemoving = [someChords objectAtIndex:i];
            if ([dcForRemoving[@"uniqueId"] isEqualToString:idForRemoving]) {
                [someChords removeObjectAtIndex:i];
                [chordObjects removeObjectAtIndex:i];
                [(LyricsDragSource*)sender.view removeFromSuperview];
            }
           
        }
}

-(void)addExistingChords:(NSMutableArray*)chordsArray andTitle:(NSString*)title{
    for (int c = 0; c < chordsArray.count; c++){
        float areaWidth = AREA_WIDTH;
        NSString *chordMod = [[chordsArray objectAtIndex:c] valueForKey:@"metadata"];
        if (chordMod == nil || [chordMod isEqualToString:@""]) {
            chordMod = @"";
        } else {
            CGSize stringSize = [chordMod sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];// [chordMod sizeWithFont:[UIFont systemFontOfSize:15]];
            CGFloat width = stringSize.width;
            areaWidth += width+30;
        }
        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, areaWidth, LABEL_HEIGHT)];
        lb.textColor = [UIColor grayColor];
        
        if (self.isPerformMode) {
            if (!isLight) {
                lb.textColor = [UIColor whiteColor];
            } else {
                lb.textColor = [UIColor grayColor];
            }
        }
        
        [lb setText:[NSString stringWithFormat:@"%@%@",[[chordsArray objectAtIndex:c] valueForKey:@"key_char"],[[chordsArray objectAtIndex:c] valueForKey:@"metadata"]]];
        lb.textAlignment = NSTextAlignmentCenter;
        int chordIndex = -1;
        if (!self.isPerformMode) {
            
            LyricsDragSource *draggableChord = [[LyricsDragSource alloc] initWithFrame:CGRectMake([[[chordsArray objectAtIndex:c] valueForKey:@"x"] floatValue], [[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue], areaWidth, AREA_HEIGHT)];
            [draggableChord checkLikeChord];
            [draggableChord setChordRow:(int)([[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue]/MAXIMUM_LINE_HEIGHT) + 1];
            @try {
                [draggableChord setChordIndex:[[[chordsArray objectAtIndex:c] valueForKey:@"index"] intValue]];
                chordIndex = [[[chordsArray objectAtIndex:c] valueForKey:@"index"] intValue];
            }
            @catch (NSException *exception) {
                [draggableChord setChordIndex:-1];
            }
            
            if ([[chordsArray objectAtIndex:c] valueForKey:@"custom"] != nil) {
                if ([[[chordsArray objectAtIndex:c] valueForKey:@"key_char"] isEqualToString:@"1"]) {
                    [draggableChord makeCustom];
                }
            }
           
            [chordObjects addObject:draggableChord];
            [draggableChord setMetadata:[[chordsArray objectAtIndex:c] valueForKey:@"key_char"]];
            [draggableChord setChordModifier:[[chordsArray objectAtIndex:c] valueForKey:@"metadata"]];
            
            [draggableChord refreshText];
            
            if (!self.isPerformMode) {
                draggableChord.backgroundColor = [UIColor whiteColor];
                draggableChord.layer.borderColor = [UIColor grayColor].CGColor;
                draggableChord.layer.borderWidth = 2.0f;
                [draggableChord setInText:YES];
                if (!self.isPerformMode){

                    UITapGestureRecognizer *double_tap_recognizer;
                    double_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteChord:)];
                    [double_tap_recognizer setNumberOfTapsRequired:2];
                    [draggableChord setUserInteractionEnabled:YES];
                    [draggableChord addGestureRecognizer:double_tap_recognizer];
                }
                
            }
            [draggableChord setMyId:[[chordsArray objectAtIndex:c] valueForKey:@"uniqueId"]];
            if ([[chordsArray objectAtIndex:c] valueForKey:@"index"] != nil)
                 [draggableChord setChordIndex:[[[chordsArray objectAtIndex:c] valueForKey:@"index"] intValue]];
            chordIndex = [[[chordsArray objectAtIndex:c] valueForKey:@"index"] intValue];
            [self addSubview:draggableChord];
            
        } else {
           self.chordView = [[UIView alloc] initWithFrame:CGRectMake([[[chordsArray objectAtIndex:c] valueForKey:@"x"] floatValue], [[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue], areaWidth, AREA_HEIGHT)];
            [self.chordView addSubview:lb];
            if (self.contentSize.height < [[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue]) {
                CGRect frame;
                frame = self.frame;
                frame.size.height = [[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue] +30;
                self.frame = frame;
                
            }
            if (performChords == nil) {
                performChords = [[NSMutableArray alloc] init];
            }
            [performChords addObject:self.chordView];
            [self addSubview:self.chordView];
        }
        NSString *cId = [[chordsArray objectAtIndex:c] valueForKey:@"uniqueId"];
        if (cId == nil) {
            cId = @"null";
        }
        
        int isCustom = 0;
        if ([[chordsArray objectAtIndex:c] valueForKey:@"custom"] != nil) {
            if ([[[chordsArray objectAtIndex:c] valueForKey:@"custom"] isEqualToString:@"1"]) {
                isCustom = 1;
            }
        }
        
        NSDictionary *dc = @{@"y":[NSString stringWithFormat:@"%f",[[[chordsArray objectAtIndex:c] valueForKey:@"y"] floatValue]],
                             @"x":[NSString stringWithFormat:@"%f",[[[chordsArray objectAtIndex:c] valueForKey:@"x"] floatValue]],
                             @"key_char":[[chordsArray objectAtIndex:c] valueForKey:@"key_char"],
                             @"uniqueId":cId,
                             @"metadata":chordMod,
                             @"index":[NSString stringWithFormat:@"%d",chordIndex],
                             @"custom":[NSString stringWithFormat:@"%d",isCustom]
                             };
        [someChords addObject:dc];
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return NO;
}



-(BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view{
    UITouch *touch = [touches anyObject];
    if ([[touch.view class] isSubclassOfClass:[LyricsDragSource class]]) {
        self.scrollEnabled = NO;
        ((UIScrollView*)self.superview).scrollEnabled = NO;
        self.prevWidth = ((LyricsDragSource*)touch.view).frame.size.width;
        ((LyricsDragSource*)touch.view).frame = CGRectMake(((LyricsDragSource*)touch.view).frame.origin.x, ((LyricsDragSource*)touch.view).frame.origin.y, screenWidth/8, screenHeight/10); //transform = CGAffineTransformMakeScale(2,2);
        ((LyricsDragSource*)touch.view).backgroundColor = [UIColor redColor];
        ((LyricsDragSource*)touch.view).layer.zPosition = 1;
        [((LyricsDragSource*)touch.view) setTintColor:[UIColor whiteColor]];
        return false;
    }
    return true;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
     UITouch *touch = [touches anyObject];
 if ([[touch.view class] isSubclassOfClass:[LyricsDragSource class]]) {
     self.scrollEnabled = NO;
     ((UIScrollView*)self.superview).scrollEnabled = NO;
     self.prevWidth = ((LyricsDragSource*)touch.view).frame.size.width;
     ((LyricsDragSource*)touch.view).frame = CGRectMake(((LyricsDragSource*)touch.view).frame.origin.x, ((LyricsDragSource*)touch.view).frame.origin.y, screenWidth/8, screenHeight/10); //transform = CGAffineTransformMakeScale(2,2);
     ((LyricsDragSource*)touch.view).backgroundColor = [UIColor redColor];
     ((LyricsDragSource*)touch.view).layer.zPosition = 1;
     [((LyricsDragSource*)touch.view) setTintColor:[UIColor whiteColor]];
 }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
     ((UIScrollView*)self.superview).scrollEnabled = YES;
    UITouch *touch = [touches anyObject];
    if ([[touch.view class] isSubclassOfClass:[LyricsDragSource class]]) {
        self.scrollEnabled = YES;
        ((LyricsDragSource*)touch.view).frame = CGRectMake(((LyricsDragSource*)touch.view).frame.origin.x,((LyricsDragSource*)touch.view).frame.origin.y, self.prevWidth, AREA_HEIGHT);
        ((LyricsDragSource*)touch.view).backgroundColor = [UIColor whiteColor];
        ((LyricsDragSource*)touch.view).layer.zPosition = 0;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
     ((UIScrollView*)self.superview).scrollEnabled = YES;
    UITouch *touch = [touches anyObject];
    if ([[touch.view class] isSubclassOfClass:[LyricsDragSource class]]) {
        ((LyricsDragSource*)touch.view).transform = CGAffineTransformMakeScale(1,1);
    }
}

- (void)longHold:(UIGestureRecognizer*)sender {
    UITapGestureRecognizer *longPress = (UITapGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            ((LyricsDragSource*)sender.view).transform = CGAffineTransformMakeScale(2,2);
            break;
        case UIGestureRecognizerStateEnded:
            ((LyricsDragSource*)sender.view).transform = CGAffineTransformMakeScale(1,1);
            break;
        case UIGestureRecognizerStateCancelled:
            (sender.view).transform = CGAffineTransformMakeScale(1,1);
            break;
        default:
            break;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    int myScreenHeight = screenSize.height;
    CGRect frame;
    frame = self.frame;
    if (self.contentSize.height < myScreenHeight) {
        frame.size.height = myScreenHeight;
    }else
        frame.size.height = self.contentSize.height;
    
    self.frame = frame;
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
}



-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(paste:)) {
        [self setNeedsDisplay];
        
        CGRect frame;
        frame = self.frame;
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        
        frame = self.frame;
        if (self.contentSize.height <= screenSize.height) {
            frame.size.height = screenSize.height;
        } else
            frame.size.height = self.contentSize.height;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)deletePart:(UITapGestureRecognizer*)sender{
    NSLog(@"Part for remove");
}

#pragma mark DropZone delegate
-(void)droppedView:(int)pos {
    [partsArray addObject:[NSNumber numberWithInt:pos]];
    [self setNeedsDisplay];
}

-(void)refreshDrawArea{
    [self setNeedsDisplay];
}

-(void)deleteView:(int)pos{
    isChanged = true;
    for (int  i = 0; i < partsArray.count; i++) {
        if ([[partsArray objectAtIndex:i] intValue] == pos) {
            [partsArray removeObjectAtIndex:i];
        }
    }
    [self setNeedsDisplay];
}

#pragma mark D&G
- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager {
    return YES;
}


- (BOOL)isInterested:(AtkDragAndDropManager *)manager {
    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *tagValue = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    NSString *pasteboardString = pastebaord.string;
    
    return [tagValue isEqualToString:pasteboardString];
}



- (void)dragStarted:(AtkDragAndDropManager *)manager {
    self.savedBackgroundColor = self.backgroundColor;
    if ([((LyricsDragSource*)[manager getDataSource]) getInText]) {
        ((LyricsDragSource*)[manager getDataSource]).hidden = YES;
    }
}

- (void)dragEnded:(AtkDragAndDropManager *)manager {
    drawPointer = false;
    [self performSelector:@selector(delayEnd) withObject:nil afterDelay:0.4];
}

- (void)delayEnd {
    self.backgroundColor = self.savedBackgroundColor;
}

- (void)dragEntered:(AtkDragAndDropManager *)manager point:(CGPoint)point {
    drawPointer = true;
    NSString* someKey = [[NSString alloc] init];
    someKey = [((LyricsDragSource*)[manager getDataSource]) getMetadata];
    if (![((LyricsDragSource*)[manager getDataSource]) likeChord]) {
        drawPointer = false;
    }
    pointerPosition = point;
}

- (void)dragExited:(AtkDragAndDropManager *)manager point:(CGPoint)point {
    drawPointer = false;
}

- (void)dragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point {
    pointerPosition = point;
    [self setNeedsDisplay];
}

-(void)clearAllChords{
    
    for (int i = 0; i < performChords.count; i++) {
        [[performChords objectAtIndex:i] removeFromSuperview];
    }
}


- (void)dragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point {
    drawPointer = false;
    BOOL canDrop = true;
    {
        NSString* someKey = [[NSString alloc] init];
        someKey = [((LyricsDragSource*)[manager getDataSource]) getMetadata];
        if (![((LyricsDragSource*)[manager getDataSource]) likeChord]) {
            canDrop = false;
        } else {
            canDrop = true;
        }
        if (canDrop) {
            isChanged = true;
            CGRect screenBound = [[UIScreen mainScreen] bounds];
            CGSize screenSize = screenBound.size;
            
            int screenHeight_ = screenSize.height;
            time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
            float newRowY = (roundf((([manager getLocation].y - screenHeight_/10)+25)/60)*MINIMUM_LINE_HEIGHT)+Y_OFFSET;
            newRowY +=  (roundf(((UIScrollView*)self.superview).contentOffset.y/ (screenHeight/10))*screenHeight/10);

            newRowY -= (screenHeight/10)/2;
            if ([manager getLocation].x >= (self.frame.size.width - 50)) {
                NSLog(@"Need remove");
            }
            
            
            
            float areaWidth = AREA_WIDTH;
            NSString *chordMod = [(LyricsDragSource*)[manager getDataSource] getModifierForChord];
            if (chordMod == nil || [chordMod isEqualToString:@""]) {
                chordMod = @"";
            } else {
                
                CGSize stringSize = [chordMod sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];//[chordMod sizeWithFont:[UIFont systemFontOfSize:15]];
                
                CGFloat width = stringSize.width;
                areaWidth += width+30;
                
            }
            
            NSDictionary *dc = @{@"y":[NSString stringWithFormat:@"%f",newRowY],
                                 @"x":[NSString stringWithFormat:@"%f",[manager getLocation].x-self.frame.origin.x],
                                 @"key_char":[(LyricsDragSource*)[manager getDataSource] getMetadata] ,
                                 @"metadata":chordMod,
                                 @"uniqueId":[NSString stringWithFormat:@"%ld",unixTime],
                                 @"index":[NSString stringWithFormat:@"%d",[((LyricsDragSource*)[manager getDataSource]) getChordIndex]],
                                 @"custom":[NSString stringWithFormat:@"%hhd",[(LyricsDragSource*)[manager getDataSource] chordIsCustom]]
                                 };
            [someChords addObject:dc];
            
            LyricsDragSource *chordView = [[LyricsDragSource alloc] initWithFrame:CGRectMake([manager getLocation].x-self.frame.origin.x, newRowY, areaWidth, AREA_HEIGHT)];

            [chordView checkLikeChord];
            [chordView setChordRow:(int)(newRowY/MAXIMUM_LINE_HEIGHT)+ 1];
            if ([(LyricsDragSource*)[manager getDataSource] chordIsCustom]) {
                [chordView makeCustom];
            }
            [chordView setChordIndex:[((LyricsDragSource*)[manager getDataSource]) getChordIndex]];
            [chordObjects addObject:chordView];
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
            [self addSubview:chordView];
            [chordView refreshText];
        }
    }
    NSArray *mySubViews = [self subviews];
    if ([mySubViews count] != 0)
        for (NSObject* chord in mySubViews) {
            if ([chord isKindOfClass:[LyricsDragSource class]]){
                if ([(LyricsDragSource*)chord isShouldRemove]){
                    if (((LyricsDragSource*)chord).tag == REMOVABLE_TAGE){
                        NSString* idForRemoving = [(LyricsDragSource*)chord getMyId];
                        for (int i = 0; i < someChords.count; i++) {
                            NSDictionary *dcForRemoving = [someChords objectAtIndex:i];
                            if ([dcForRemoving[@"uniqueId"] isEqualToString:idForRemoving]) {
                                NSLog(@"Remove chord %@",dcForRemoving);
                                [someChords removeObjectAtIndex:i];
                            }
                        }
                        for (int i = 0; i < chordObjects.count; i++) {
                            if (((LyricsDragSource*)[chordObjects objectAtIndex:i]).isShouldRemove == YES) {
                                [chordObjects removeObjectAtIndex:i];
                            }
                        }
                        [(LyricsDragSource*)chord removeFromSuperview];
                    }
                }
            }
        }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
   
    float rows = roundf( (self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom) / MINIMUM_LINE_HEIGHT );
    
    if (drawPointer) {
        [[UIColor lightTextColor] setFill];
        
        float newRowY =  (roundf(((pointerPosition.y - screenHeight/10)+TEXT_FONT_SIZE)/60)*MINIMUM_LINE_HEIGHT)+Y_OFFSET;
        newRowY -= (screenHeight/10)/2;
        if ((pointerPosition.y > (newRowY+5)) && (pointerPosition.y < newRowY-5)) {
            newRowY = pointerPosition.y;
        }
        newRowY +=  (roundf(((UIScrollView*)self.superview).contentOffset.y/ (screenHeight/10))*screenHeight/10);
        CGRect drawingRect = CGRectMake( pointerPosition.x - (screenWidth/8+(screenWidth/8)/2)+50,  newRowY , AREA_WIDTH, AREA_HEIGHT);
        [UIView animateWithDuration:1.5 animations:^{
            UIRectFill(CGRectInset(drawingRect, 0, 0));
        }];
        
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, - 10, -10);
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
                    if ([[partsArray objectAtIndex:c] intValue] == vr && vr > 0){
                        CGContextMoveToPoint(context, self.bounds.origin.x + 10,(vr*102.4));
                        CGContextAddLineToPoint(context, self.bounds.size.width - screenWidth/8, ((vr*102.4)));
                    }
                }
            }
        }
        
    }
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    
    
}


@end