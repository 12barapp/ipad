//
//  TextEditor.h
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorHelper.h"

#import "LyricsDragSource.h"
#import "LyricsDropZone.h"

@interface LyricsEditorTextView : UITextView {
    NSMutableArray *someChords;
    NSMutableArray *chordObjects;    
    NSMutableArray *partsArray;
    NSMutableArray *performChords;
    CGFloat screenWidth;
    CGFloat screenHeight;
    bool isChanged;
}

@property (nonatomic, strong)          UIColor *savedBackgroundColor;
@property (nonatomic, assign)          BOOL isPerformMode;
@property (assign)                     float prevWidth;
@property (strong, nonatomic) IBOutlet UIView* chordView;
-(void)deletePart:(UITapGestureRecognizer*)sender;
-(BOOL)wasEdited;
-(void)changeToLightTheme;
-(void)changeToDarkTheme;
-(void)setPerformMode;
-(void)droppedView:(int)pos;
-(void)refreshDrawArea;
-(void)setSelftText:(NSString*)text;
-(NSMutableArray*)getSelfChords;
-(NSMutableArray*)getChordsForUpdate;
-(NSString*)getSelfText;
-(void)updateChordWithY:(int)yPos index:(NSString*)idx;
-(void)updateChordWithTitle:(NSString*)title index:(int)idx;
-(void)addExistingChords:(NSMutableArray*)chordsArray andTitle:(NSString*)title;
-(void)clearAllChords;
@end
