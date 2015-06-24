//
//  LyricsDropZone.h
//  app12bar
//
//  Created by Alex on 7/29/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtkDragAndDrop.h"
#import "LyricsDragSource.h"
#import "LyricsDropZone.h"
#import "ChangeKeysView.h"
#import "ColorHelper.h"

@class LyricsDropZone;
@protocol LyricsDropZoneDelegate

-(void)typeInNextEditor:(NSInteger*)textViewNumber;

-(void)droppedView:(int)pos;
-(void)refreshDrawArea;
-(void)deleteView:(int)pos;
-(void)deletePart:(UITapGestureRecognizer*)sender;
@end

@interface LyricsDropZone : UIView<AtkDropZoneProtocol, UITextViewDelegate, ChangeKeysDelegate>{
    BOOL isChordsContainer;
    NSString *lyricsText;
    NSMutableArray *someChords;
    NSString* selfValue;
    NSArray *redColors;
    
    
}
@property (nonatomic, strong)         UIColor *savedBackgroundColor;
//@property (strong)                    NSString* selfValue;
@property (assign)                    id <LyricsDropZoneDelegate> delegate;
@property (assign)                    id <LyricsDropZoneDelegate> editorDelegate;
@property (nonatomic,strong) IBOutlet UITextView* txt;
@property (nonatomic, assign)         BOOL isPerform;
@property (assign)         int zonePosition;

-(void)initForChordsContainer:(BOOL)bl;
-(NSString*)getSelfLyric;
-(void)setSelfLyric:(NSString*)lyric;
-(void)addExistingChords:(NSMutableArray*)chordsArray andTitle:(NSString*)title;
-(NSMutableArray*)getChords;
-(void)setSelfTextEdtor:(UITextView*)textView;
-(void)setActiveTextEditor;
-(NSString*)getSelfValue;
-(void)setPerformMode;
-(void)addLyticsPartWithTitle:(NSString*)title;
@end
