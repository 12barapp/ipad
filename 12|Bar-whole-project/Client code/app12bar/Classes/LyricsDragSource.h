//
//  LyricsDragSource.h
//  app12bar
//
//  Created by Alex on 7/29/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtkDragAndDrop.h"
#import "LyricsDropZone.h"
#import "ChangeKeysView.h"
#import "LyricsTextEditor.h"
#import "LyricsEditorTextView.h"

@interface LyricsDragSource : UIView<AtkDragSourceProtocol>{
    BOOL inText;
    BOOL shouldRemove;
    BOOL isChord;
    BOOL isCustom;
    int index;
    NSString* uniqueId;
    
}
@property (nonatomic)          NSString *chordModifier;
@property (nonatomic)          NSString *metadata;
@property (nonatomic, assign)  int row;
@property (nonatomic) IBOutlet UILabel* chordLabel;


-(void)setInText:(BOOL)inTxt;
-(void)moveRow:(int)rowNum;
-(void)setChordRow:(int)rowNum;
-(int)getChordRow;
-(BOOL)chordIsCustom;
-(void)makeCustom;
-(void)checkLikeChord;
-(BOOL)likeChord;
-(void)setTitlePosition:(CGRect)rect;
-(void)setTitleText:(NSString*)text;
-(void)setMetadataForChord:(NSString*)mData;
-(BOOL)getInText;
-(void)refreshText;
-(BOOL)isShouldRemove;
-(NSString*)getMetadata;
-(NSString*)getModifierForChord;
-(void)setMyId:(NSString*)sId;
-(NSString*)getMyId;
-(void)setChordIndex:(int)idx;
-(int)getChordIndex;
-(void)setBgColor:(NSString*)color;
-(void)setTitleColor:(UIColor*)color;
-(void)setTextAligment:(NSTextAlignment)aligment;

@end
