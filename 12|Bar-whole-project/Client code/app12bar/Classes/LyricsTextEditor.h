//
//  LyricsTextEditor.h
//  app12bar
//
//  Created by Alex on 8/8/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtkDragAndDrop.h"
#import "LyricsDragSource.h"
#import "LyricsDropZone.h"

@class LyricsTextEditor;
@protocol LyricsEditorDelegate

-(void)addOneTile;
-(void)removeOneTile;
-(void)updateForHeight:(int)height;
@end

@interface LyricsTextEditor : UITextView<AtkDropZoneProtocol, UITextViewDelegate>{
        NSMutableArray *someChords;
        BOOL isLight;
    NSMutableArray *partsArray;
}

@property (nonatomic, strong) UIColor *savedBackgroundColor;
@property (assign)            id<LyricsEditorDelegate> lyricsDelegate;
@property (nonatomic, assign) BOOL isPerformMode;

-(NSMutableArray*)getSelfChords;
-(NSString*)getSelfText;
-(void)addExistingChords:(NSMutableArray*)chordsArray andTitle:(NSString*)title;
-(void)setSelftText:(NSString*)text;
-(void)changeToLightTheme;
-(void)changeToDarkTheme;
-(void)updateLines;
-(void)setPerformMode;
-(void)droppedView:(int)pos;
-(void)calcHeight:(UITextView*)textView;
@end
