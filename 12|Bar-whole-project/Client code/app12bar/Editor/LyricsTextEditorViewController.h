//
//  LyricsTextEditorViewController.h
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Animation.h"
#import "FXBlurView.h"
#import "AtkDragAndDropManager.h"
#import "LyricsDragSource.h"
#import "LyricsDropZone.h"
#import "DBManager.h"
#import "NotesDlg.h"
#import "LyricsTextEditor.h"
#import "CoreSettings.h"
#import "ChangeKeysView.h"
#import "ModifyChordsView.h"
#import "ServerUpdater.h"
#import "TransposeChordHelper.h"
#import "ColorHelper.h"
#import "LyricsEditorTextView.h"
#import "NSAttributedString+height.h"
#import "AnimationViewController.h"


@interface LyricsTextEditorViewController : AnimationViewController<UITextViewDelegate, LyricsEditorDelegate, LyricsDropZoneDelegate, NSLayoutManagerDelegate, UIScrollViewDelegate>{
}

// Outlets
@property (strong, nonatomic) IBOutlet UIScrollView *lyricsScrollView;
@property (strong, nonatomic) IBOutlet UIView *tabsContainer;
@property (strong, nonatomic) IBOutlet UIButton *tabBtn1;
@property (strong, nonatomic) IBOutlet UIButton *tabBtn2;
@property (strong, nonatomic) IBOutlet UIButton *notesBtn;
@property (strong, nonatomic) IBOutlet UIView *firstTabContainer;
@property (strong, nonatomic) IBOutlet UIView *secondTabContainer;
@property (strong, nonatomic) IBOutlet UIView *lyricsWrapper;
@property (strong, nonatomic) IBOutlet UIView *headWrapper;
@property (strong, nonatomic) IBOutlet UILabel *sontTitle;
@property (strong, nonatomic) IBOutlet UILabel *songInfo;
@property (strong, nonatomic) IBOutlet UILabel *songGenre;
@property (strong, nonatomic) IBOutlet UILabel *songAuthor;
@property (strong, nonatomic) IBOutlet UILabel *headSongTitle;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic)          UIView *leftPartsContainer;

//
@property (nonatomic, strong)          AtkDragAndDropManager *dragAndDropManager;
@property (nonatomic, strong)          ServerUpdater* serverUpdater;
@property (nonatomic)                  LyricsEditorTextView *textEditor;
@property (nonatomic, strong)          NSMutableArray* chordIds;
@property (strong, nonatomic)          User *currentUser;
@property (assign, nonatomic)          BOOL inSet;
@property (assign, nonatomic)          BOOL isPerformMode;
@property (nonatomic, assign)          int countOfParts;
@property (nonatomic, assign)          int prefTextHeight;
@property (nonatomic, assign)          int chordToPerform;
@property (nonatomic, assign)          float keyboardHeight;


-(void)setJson:(NSDictionary*)json;
-(void)imInSet:(int)pos;
-(void)activatePerformMode;
-(void)customInit;
-(void)setIds:(NSMutableArray*)ids;
@end
