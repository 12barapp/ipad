//
//  LyricsDragSource.m
//  app12bar
//
//  Created by Alex on 7/29/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "LyricsDragSource.h"

@implementation LyricsDragSource
@synthesize  metadata, chordModifier;


#pragma mark Delegate

-(void)setKeyTile:(NSString*)tileText {

    metadata = tileText;
    NSArray *views = [self subviews];
    if ([chordModifier isEqualToString:@""] || chordModifier == nil)
        chordModifier = @"";
    [(UILabel*)[views objectAtIndex:1] setText:[NSString stringWithFormat:@"%@%@",tileText, chordModifier]];
}

-(void)setKeyModifier:(NSString*)tileText{
    [self.chordLabel setText:[NSString stringWithFormat:@"%@%@",metadata, tileText]];
}

-(void)setMetadataForChord:(NSString*)mData{
    metadata = mData;
}

-(BOOL)chordIsCustom{
    return isCustom;
}

-(void)makeCustom{
    isCustom = true;
}

-(void)setChordModifier:(NSString*)modifier{
    chordModifier = modifier;
}

-(void)setBgColor:(NSString*)color{
    
}

-(NSString*)getMetadata{
    return metadata;
}

-(NSString*)getModifierForChord{
    return chordModifier;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (self.chordLabel == nil) {
            self.chordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25.0f, 25.0f)];
            self.chordLabel.textAlignment = NSTextAlignmentCenter;
            self.chordLabel.textColor = [UIColor grayColor];
            self.chordLabel.font = [UIFont systemFontOfSize:13.0f];
            isChord = false;
            isCustom = false;
            index = -1;
            [self addSubview:self.chordLabel];
        }
    }
    return self;
}

-(void)setTextAligment:(NSTextAlignment)aligment{
    self.chordLabel.textAlignment = aligment;
}

-(void)setTitleColor:(UIColor*)color{
    self.chordLabel.textColor = color;
}

-(void)setChordIndex:(int)idx{
    index = idx;
}

-(void)moveRow:(int)rowNum{
    self.row = self.row+rowNum;
}

-(void)setChordRow:(int)rowNum{
    self.row = rowNum;
}
-(int)getChordRow{
    return self.row;
}


-(int)getChordIndex{
    return index;
}

-(BOOL)likeChord{
    return isChord;
}

-(void)checkLikeChord{
    isChord = true;
}

-(void)setTitlePosition:(CGRect)rect{
    self.chordLabel.frame = rect;
}

-(void)setTitleText:(NSString*)text{
    [self.chordLabel setText:text];
}

-(void)refreshText{
    float areaWidth = 25.0f;
    NSString *chordMod = chordModifier;
    if (chordMod == nil || [chordMod isEqualToString:@""]) {
        chordMod = @"";
        self.chordLabel.frame = CGRectMake(0, 0, 25.0f, 25.0f);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, areaWidth, 25.0f);
    } else {
        CGSize stringSize = [chordMod sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];//[chordMod sizeWithFont:[UIFont systemFontOfSize:15]];
        CGFloat width = stringSize.width;
        areaWidth += width+30;
        self.chordLabel.frame = CGRectMake(0, 0, areaWidth, 25.0f);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, areaWidth, 25.0f);
    }
    [self.chordLabel setText:[NSString stringWithFormat:@"%@%@",metadata,chordModifier]];
}

-(void)pressStarted:(AtkDragAndDropManager *)manager{
    NSLog(@"Press started from source");
}

- (void)dragWillStart:(AtkDragAndDropManager *)manager {
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.tag];

    if ([self.superview isKindOfClass:[LyricsTextEditor class]]||[self.superview isKindOfClass:[LyricsEditorTextView class]]){
        shouldRemove = true;
        self.tag = 100;
    } else{
        shouldRemove = false;
    }
  
}

-(void)setMyId:(NSString*)sId{
    uniqueId = sId;
}

-(NSString*)getMyId{
    return uniqueId;
}

-(BOOL)isShouldRemove{
    return shouldRemove;
}

-(void)setInText:(BOOL)inTxt{
    inText = inTxt;
}

-(BOOL)getInText{
    return inText;
}

-(void)closeKeyDialog{
    
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
