//
//  LyricsTextEditorViewController.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "LyricsTextEditorViewController.h"
#import "HelpViewController.h"
#import "TutorialsView.h"


#define TEXT_FONT_SIZE 22.0
#define Y_OFFSET 8
#define PARTS_Y_OFFSET 8
#define LINE_HEIGHT_MULTIPLE 102.4F
#define MAXIMUM_LINE_HEIGHT 51.0F
#define MINIMUM_LINE_HEIGHT 51.200001F

@interface LyricsTextEditorViewController ()
{
    IBOutlet FXBlurView *blurView;
        NSString *JsonForEditing;
        NSString *songKeyOf;
        NSDictionary *editedJson;
        CGFloat screenWidth;
        CGFloat screenHeight;
        NSArray *staticColors;
        NSArray *darkColors;
        NSArray *redColors;
        NSArray *vWords;
        NSMutableArray *vKeys;
        NSArray *chordsTitles;
        UIView *somePopup;
        NSMutableArray *parts;
        NSMutableDictionary* allLyrics;
        UIActivityIndicatorView *spinner;
        TransposeChordHelper *transposer;
    
    DBManager *db;
    CoreSettings *setting;
    int textLenght;
    int colorIndex;
    bool textChanged;
}

@end



@implementation LyricsTextEditorViewController
@synthesize countOfParts, leftPartsContainer, prefTextHeight, serverUpdater;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.inSet = NO;
    }
    return self;
}

- (void)removeOneTile { }
- (void)addOneTile { }
- (void)droppedView:(int)pos { }
- (void)typeInNextEditor:(NSInteger *)textViewNumber { }
- (void)deleteView:(int)pos { }
- (void)deletePart:(UITapGestureRecognizer *)sender { }
- (void)refreshDrawArea { }


- (void)viewDidLoad {
    [super viewDidLoad];
    colorIndex = 0;
    transposer = [[TransposeChordHelper alloc] init];
    parts = [[NSMutableArray alloc] init];
    blurView.hidden = YES;
    parts = [[NSMutableArray alloc] init];
    db = [DBManager sharedManager];
    setting = [CoreSettings sharedManager];
    [setting loadSetting];
    textLenght = 0;
    textChanged = false;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth_ = screenSize.width;
    CGFloat screenHeight_ = screenSize.height;
    screenHeight = screenHeight_;
    screenWidth = screenWidth_;
    
    if (self.isPerformMode)
    {
        self.textEditor = [[LyricsEditorTextView alloc] initWithFrame:CGRectMake(screenWidth/8, Y_OFFSET, ((screenWidth/8)*8-(screenWidth/8)), (screenHeight - (screenHeight/10)))];
        self.lyricsScrollView.frame = CGRectMake(0, 0, screenWidth, ((screenHeight/10)*7));
        if ([setting isLightTheme]) {
            self.lyricsScrollView.backgroundColor = [UIColor whiteColor];
        } else {
            self.lyricsScrollView.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:@"#4d4d4d"];
//            self.lyricsScrollView.backgroundColor = [UIColor whiteColor];
        }
        self.lyricsWrapper.frame = CGRectMake(0, screenHeight/10, screenWidth, screenHeight );
        [self.textEditor setPerformMode];
    }
    else {
        self.textEditor = [[LyricsEditorTextView alloc] initWithFrame:CGRectMake(screenWidth/8, Y_OFFSET, ((screenWidth/8)*8-(screenWidth/8)), (screenHeight/10)*7)];
        self.lyricsScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight - ((screenHeight/10)*2));
        self.lyricsScrollView.backgroundColor = [UIColor whiteColor];
    }
    self.textEditor.delegate = self;
    self.textEditor.layoutManager.delegate = self;
    [self.lyricsScrollView addSubview:self.textEditor];
    self.textEditor.layoutManager.allowsNonContiguousLayout = NO;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.maximumLineHeight = (screenHeight/10)/2.0f ;
    paragraphStyle.minimumLineHeight = (screenHeight/10)/2.0f ;
    NSDictionary *attribute = @{NSParagraphStyleAttributeName : paragraphStyle};
    
    [self.textEditor setFont:[UIFont fontWithName:@"Helvetica Neue" size:TEXT_FONT_SIZE]];
    
    self.textEditor.attributedText  = [[NSAttributedString alloc] initWithString:@"" attributes:attribute];
    
    self.currentUser = [User sharedManager];
    
    if (self.inSet){
        editedJson = [db getChartById:[self.chordIds objectAtIndex:self.chordToPerform]];
        [self.currentUser setChartId:[self.chordIds objectAtIndex:self.chordToPerform]];
        self.currentUser.selectedChord = [NSNumber numberWithInt:[[self.chordIds objectAtIndex:self.chordToPerform] intValue]];
    } else {
        editedJson = [db getChartById:[self.currentUser chartId]];
    }
    [self initArrays];
    [self loadTitles];
    self.dragAndDropManager = [[AtkDragAndDropManager alloc] init];
    self.countOfParts = 8;
    [self lyricsPreview];
    
    if (!self.isPerformMode) {
        [self initTabs];
    } else {
        self.tabsContainer.hidden = YES;
    }
    [self initBlur];
    [self.textEditor setNeedsDisplay];
    self.headWrapper.frame = CGRectMake(0, 0, screenWidth, screenHeight/10);
    
    
    if (self.inSet) {
        NSLog(@"Set swipe gesture recognizer");
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHandler:)];
        [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self.view addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHandler:)];
        [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self.view addGestureRecognizer:swipeRight];
    }

    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnBlurView)];
    tapGest.numberOfTapsRequired = 1;
    
    [blurView.underlyingView addGestureRecognizer:tapGest];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"tutsCharts_firstLaunch"])
    {
        // On first launch, this block will execute
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HelpViewController *viewController = (HelpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"help"];
        [viewController setHelpFile:@"tuts_charts"];
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)); // 1
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ // 2
            
            //[self presentViewController:viewController animated:YES completion:nil];
            [self recallTutsWithOptions:TutorialSetCharts];
        });
        
        // Set the "hasPerformedFirstLaunch" key so this block won't execute again
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutsCharts_firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)recallTutsWithOptions:(TutorialSet) set {
    [self animateModalPaneOut:somePopup];
    
    somePopup = nil;    blurView.hidden = NO;
    somePopup = [TutorialsView tutorials:set];
    [[(TutorialsView *)somePopup scrollView] setDelegate:self];
    
    [self animateModalPaneIn:somePopup];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    CGFloat pageWidth = screenSize.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    NSLog(@"page number %ld",(long)page);
    
    [(TutorialsView *)somePopup pageControl].currentPage = page;
}

- (void)handleTapOnBlurView
{
    if ([somePopup class] == [NotesDlg class]) {
        
        [self saveNotes:[(NotesDlg*)somePopup notesText].text];
    }
    else {
        blurView.hidden = YES;
        [self animateModalPaneOut:somePopup];
        somePopup = nil;
    }
}
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 0.0f; // For really wide spacing; pick your own value
}

-(void)setTextChanged{
    textChanged = true;
}

-(void)loadTitles{
    if (editedJson == nil && self.inSet)
        editedJson = [db getChartById:[self.chordIds objectAtIndex:self.chordToPerform]];
    [self.sontTitle setText:editedJson[@"cTitle"]];
    self.headSongTitle.text = editedJson[@"cTitle"];
    self.songAuthor.text = editedJson[@"artist"];
    @try {
        songKeyOf = editedJson[@"key"];
        self.songInfo.text = [NSString stringWithFormat:@"%@ • %@ • %@",songKeyOf,editedJson[@"time_sig"],editedJson[@"bpm" ]];
        self.songGenre.text = editedJson[@"genre"];
    }
    @catch (NSException *exception) {
        self.songInfo.text = @" ";
        self.songGenre.text = @" ";
    }
    @finally {
        
    }

}


-(IBAction)swipeLeftHandler:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"get gesture right");
        [self perform:1];
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"get gesture Left");
        [self perform:0];
    }
   
}

-(void) pop {
    NSLog(@"Pop");
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)setIds:(NSMutableArray*)ids{
    self.chordIds = ids;
}

- (void)perform:(int)direction {
    
    UIView *currentView = self.view;
    // get the the underlying UIWindow, or the view containing the current view
    UIView *theWindow = [currentView superview];
    
    UIView *newView = self.view;
    [currentView removeFromSuperview];
    [theWindow addSubview:newView];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionMoveIn];
    
    CATransition *animationCurl = [CATransition animation];
    [animationCurl setDuration:0.75];
    [animationCurl setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animationCurl setRemovedOnCompletion:NO];
    
    
    if (direction == 0)
    {
        [animation setSubtype:kCATransitionFromRight];
        [animationCurl setSubtype:kCATransitionFromTop];
        animationCurl.fillMode = kCAFillModeForwards;
        animationCurl.type = @"pageCurl";
        
        self.chordToPerform++;
        if (self.chordToPerform >= self.chordIds.count ) {
            self.chordToPerform = 0;
        }
    }
    else
    {
        [animation setSubtype:kCATransitionFromLeft];
        [animationCurl setSubtype:kCATransitionFromTop];
        animationCurl.fillMode = kCAFillModeBackwards;
        animationCurl.type = @"pageUnCurl";
        
        self.chordToPerform--;
        if (self.chordToPerform < 0 ) {
            self.chordToPerform = (int)(self.chordIds.count - 1);
        }

    }
    
    [self.textEditor clearAllChords];
    editedJson = [db getChartById:[self.chordIds objectAtIndex:self.chordToPerform]];
    [self.currentUser setChartId:[self.chordIds objectAtIndex:self.chordToPerform]];
    self.currentUser.selectedChord = [NSNumber numberWithInt:[[self.chordIds objectAtIndex:self.chordToPerform] intValue]];
    
    [self loadTitles];
   
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [[theWindow layer] addAnimation:animation forKey:@"SwitchToView2"];
    //[[theWindow layer] addAnimation:animationCurl forKey:@"SwitchToView2"];
    
    [self lyricsPreview];
    
    [self.textEditor setNeedsDisplay];
    [self calcTextHeight];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LyricsTextEditorViewController *viewController = (LyricsTextEditorViewController *)[storyboard instantiateViewControllerWithIdentifier:@"editor"];
    //viewController.isPerformMode = YES;
    
    [viewController imInSet:self.chordToPerform];
    [viewController setIds:self.chordIds];
    [viewController activatePerformMode];
    [viewController customInit];
    [viewController setIsPerformMode:YES];
    
    [self presentViewController:viewController animated:NO completion:^{
    
    }];

    [self dismissViewControllerAnimated:NO completion:nil];
    
}


-(void)setNewSongKey:(NSString*)key{
    textChanged = true;
    NSArray* allChords = [[NSArray alloc] initWithObjects:@"A",
                          @"Bb",
                          @"B",
                          @"C",
                          @"C#",
                          @"Db",
                          @"D",
                          @"Eb",
                          @"E",
                          @"F",
                          @"F#",
                          @"Gb",
                          @"G",
                          @"Ab", nil];
    
    int prevKeyIndex = (int)[allChords indexOfObject:songKeyOf];
    int currentKeyIndex = (int)[allChords indexOfObject:key];
    int transposeIndex = 0;
    
    if (prevKeyIndex < currentKeyIndex) {
        transposeIndex = currentKeyIndex - prevKeyIndex;
    }
    if (prevKeyIndex > currentKeyIndex) {
        transposeIndex = currentKeyIndex - prevKeyIndex;
    }
   
    vKeys = [transposer getViewForKey:key];
    if (transposer == nil) {
        transposer = [[TransposeChordHelper alloc] init];
    }
    
    
    NSMutableArray* lyricsNotes = [self.textEditor getChordsForUpdate];
    for (int i = 0; i < lyricsNotes.count; i++) {
        
        NSString *newMeta = [transposer chordTranspose:[(LyricsDragSource*)[lyricsNotes objectAtIndex:i] getMetadata] fromKey:songKeyOf toKey:key];
        NSArray *subst = [newMeta matches:RX(@"[^b#][#b]?")];
        [(LyricsDragSource*)[lyricsNotes objectAtIndex:i] setMetadata:[subst objectAtIndex:0]];
        
        [self.textEditor updateChordWithTitle:[subst objectAtIndex:0] index:i];
        
        if (![(LyricsDragSource*)[lyricsNotes objectAtIndex:i] chordIsCustom]){
            
            NSString *mod = @"";
            if ([subst count] ==2 ) {
                mod = [subst objectAtIndex:1];
            }
                [(LyricsDragSource*)[lyricsNotes objectAtIndex:i] setChordModifier:mod];
            
        }
        [(LyricsDragSource*)[lyricsNotes objectAtIndex:i] refreshText];
      //  }//[[vKeys objectAtIndex:cIndex] valueForKey:@"chord"]
        //[transposer transpose:[(LyricsDragSource*)[lyricsNotes objectAtIndex:i] getMetadata] amount:transposeIndex]
    }
   
    songKeyOf = key;
    NSArray *viewsToRemove = [self.secondTabContainer subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [self fillChordsTilesForTab];
    self.songInfo.text = [NSString stringWithFormat:@"%@ • %@ • %@",songKeyOf,editedJson[@"time_sig"],editedJson[@"bpm" ]];
    
    //Update chart metadata with new key
    
    if (!self.isPerformMode) {
        
        NSMutableArray* lyricsForSaving = [[NSMutableArray alloc] init];
        NSString* lyrics = [[self.textEditor getSelfText] stringByReplacingOccurrencesOfString:@"\n" withString:@"|!|"];
        lyrics = [lyrics stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
        lyrics = [lyrics stringByReplacingOccurrencesOfString:@"\"" withString:@"%!%"];
        lyrics = [self escapeString:lyrics];
        NSMutableArray* lyricsNotes = [self.textEditor getSelfChords];
        NSMutableDictionary* lnT = [[NSMutableDictionary alloc] init];
        [lnT setObject:lyrics forKey:@"txt"];
        [lnT setObject:lyricsNotes forKey:@"cordinates"];
        NSMutableArray* values = [[NSMutableArray alloc] init];
        for (int i = 0; i < countOfParts; i++) {
            [values addObject:[[(LyricsDropZone*)[parts objectAtIndex:i] getSelfValue] stringByReplacingOccurrencesOfString:@"\n" withString:@"|!|"]];
        }
        [lnT setObject:values forKey:@"chorus"];
        [lyricsForSaving addObject:lnT];
        [db updateLyrics:lyricsForSaving forChartId:[self.currentUser chartId]];

        NSDictionary *mArr = [db getChartById:[self.currentUser chartId]];
        NSString *notesText = [mArr[@"notes"] stringByReplacingOccurrencesOfString:@"%!%" withString:@"\n"];
        notesText = [notesText stringByReplacingOccurrencesOfString:@"*!*" withString:@"\""];
        
        [db updateChart:self.sontTitle.text
                 artist:self.songAuthor.text
                    key:songKeyOf
               time_sig:editedJson[@"time_sig"]
                  genre:self.songGenre.text
                    bpm:editedJson[@"bpm"]
                  notes:notesText
                 lyrics:lyricsForSaving
                chartId:[self.currentUser chartId]];
        
        if ([self.currentUser getUsedMode] == MODE_FB){
            if (textChanged || [self.textEditor wasEdited]) {
                self.serverUpdater = [ServerUpdater sharedManager];
                [self.serverUpdater updateChart:[self dictionaryToString:[db getChartById:[self.currentUser chartId]]]
                                        chartId:[self.currentUser chartId]];
            }
        }
    }
}

-(void)drawSongParts:(NSMutableArray*)lyrics andParts:(int)pCount{
    if (leftPartsContainer == nil){
        leftPartsContainer = [[UIView alloc] initWithFrame:CGRectMake(0, PARTS_Y_OFFSET, screenWidth/8, pCount*(screenHeight/10))];
        [self.lyricsScrollView addSubview:leftPartsContainer];
    } else {
        for(UIView *subview in [leftPartsContainer subviews]) {
            [subview removeFromSuperview];
        }
    }
    NSString* songText = [[NSString alloc] init];
    NSMutableArray *partsArray = [[NSMutableArray alloc] init];
    if (lyrics.count > 0){
        NSDictionary *dc = [lyrics objectAtIndex:0];
        if ([dc valueForKey:@"chorus"] != nil) {
            partsArray = [lyrics objectAtIndex:0][@"chorus"];
        }
    }
    for (int i = 0; i < pCount; i++) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, i*(screenHeight/10), screenWidth/8, screenHeight/10)];
        v.backgroundColor = [UIColor whiteColor];
        LyricsDropZone *dropZone = [[LyricsDropZone alloc] initWithFrame:CGRectMake(0, 0, screenWidth/8, screenHeight/10)];
        dropZone.editorDelegate  = (id)self.textEditor;
        dropZone.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:staticColors[colorIndex]];
        colorIndex++;
        if (colorIndex > 7) {
            colorIndex = 0;
        }
        [dropZone initForChordsContainer:NO];
        [dropZone setZonePosition:i];
        if (self.isPerformMode) {
            [dropZone setPerformMode];
        }
        [v addSubview:dropZone];
        [parts addObject:dropZone];
        if (partsArray.count > i){
            @try {
                NSString* partTitle = [partsArray objectAtIndex:i];
                if ((partTitle != nil) && (![partTitle isEqualToString:@""])) {
                    [dropZone addLyticsPartWithTitle:[partTitle stringByReplacingOccurrencesOfString:@"|!|" withString:@"\n"]];
                    [self.textEditor droppedView:i];
                }
                
            }
            @catch (NSException *exception) {
                // ignore all errors
            }
            @finally {
                // ignore all errors
            }
        }
        
        [self setContent:v forTextView:nil andText:songText dropZone:nil andPosition:i];
        
       // dropZone = nil;
        //v = nil;
    }
}

-(void)setContent:(UIView*)v forTextView:(UITextView*)text andText:(NSString*)string dropZone:(LyricsDropZone*)zone andPosition:(int)pos{
    zone.editorDelegate  = (id)self.textEditor;
    [zone setZonePosition:pos];
    [v addSubview:zone];
    [leftPartsContainer addSubview:v];
}

-(void)initBlur {
    blurView.blurRadius = 10.913934f;
    [blurView updateAsynchronously:YES completion:nil];
    
}

-(void)initArrays{
    staticColors = @[@"#979797",@"#979797",@"#C1C1C1",@"#C1C1C1",@"#979797",@"#979797",@"#C1C1C1",@"#C1C1C1"];
    darkColors = @[@"#4C4C4E", @"#626366", @"#76787A", @"#898B8E", @"#9D9FA1"];
    //redColors = @[@"#fd2732", @"#e3363e", @"#e15a5d", @"#df7c7e", @"#ec9c9d"];
    redColors = @[@"#EA465A", @"#EE6B7B", @"#F07E8C", @"#F2909C", @"#F4A2AC"];
    vWords = @[@"Intro",@"V1",@"V2",@"V3",@"V4",@"V5",@"V6",@"Pre\nChorus",@"Chorus",@"Bridge",@"Instrumental",@"Outro",@"Custom",@"Custom"];
    vKeys = [transposer getViewForKey:editedJson[@"key"]];
    
}

-(void)lyricsPreview {
    NSDictionary* chart = [db getChartById:[self.currentUser chartId]];
    [self loadLyrics:chart[@"lyrics"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.textEditor setNeedsDisplay];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardRect;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    self.keyboardHeight = keyboardRect.size.height;
    [UIView animateWithDuration:1 animations:^{
        self.lyricsScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight - (keyboardRect.size.height + screenHeight/10));
        
    }];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    self.keyboardHeight = 0.0f;
    [UIView animateWithDuration:1 animations:^{
        self.lyricsScrollView.frame = CGRectMake(0, 0, screenWidth, ((screenHeight/10)*7)+10);
        
    }];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.isPerformMode || [setting showLyrics]) {
        [self calcTextHeight];
    }else {
        
        [self.lyricsScrollView setContentSize:CGSizeMake(screenWidth, self.textEditor.frame.size.height+((screenHeight/10)))];
         self.leftPartsContainer.frame = CGRectMake(0, PARTS_Y_OFFSET, self.leftPartsContainer.frame.size.width, self.textEditor.frame.size.height+screenHeight/10);
    }
    
    [self.dragAndDropManager start];
    [blurView updateAsynchronously:YES completion:nil];
    NSLog(@"%f",self.textEditor.font.lineHeight);
    [self.textEditor setNeedsDisplay];
    
    self.lyricsWrapper.backgroundColor = [UIColor whiteColor];
    self.lyricsScrollView.backgroundColor = [UIColor whiteColor];
    self.textEditor.backgroundColor = [UIColor whiteColor];
    self.leftPartsContainer.backgroundColor = [UIColor whiteColor];

    self.lyricsWrapper.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lyricsScrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.textEditor.layer.borderColor = [UIColor whiteColor].CGColor;
    self.leftPartsContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //self.lyricsScrollView.backgroundColor = [UIColor grayColor];
}

-(void)calcTextHeight{
    CGRect frame;
    frame = self.textEditor.frame;
    if (self.textEditor.contentSize.height < ((screenHeight/10)*7))
        frame.size.height  = ((screenHeight/10)*7);
    else
        frame.size.height = self.textEditor.contentSize.height-5;

    // frame.origin.y = -1;
    //self.textEditor.frame = frame; //TODO: some weird bug with frame fot text editor
    prefTextHeight = self.textEditor.contentSize.height;
    [self.lyricsScrollView setContentSize:CGSizeMake(screenWidth, frame.size.height+screenHeight/10)];
    int leftPartHeight = frame.size.height;
    if (leftPartHeight < ((screenHeight/10)*7))
        leftPartHeight = ((screenHeight/10)*7);
    self.leftPartsContainer.frame = CGRectMake(0, PARTS_Y_OFFSET, self.leftPartsContainer.frame.size.width, leftPartHeight+(screenHeight/10));
    
    [self.lyricsScrollView setContentSize:CGSizeMake(screenWidth, leftPartHeight+(screenHeight/10))];
    self.textEditor.frame = CGRectMake(screenWidth/8, Y_OFFSET, ((screenWidth/8)*8-(screenWidth/8)), leftPartHeight+(screenHeight/10));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.dragAndDropManager stop];
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadLyrics:(NSMutableArray*)lyrics{
    self.textEditor.textContainer.lineFragmentPadding = 0.0f;
    self.textEditor.textContainerInset = UIEdgeInsetsZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.headIndent = 0.0f;
    paragraphStyle.maximumLineHeight = MAXIMUM_LINE_HEIGHT;
   // paragraphStyle.lineHeightMultiple = (screenHeight/10.0f);
    paragraphStyle.minimumLineHeight = MAXIMUM_LINE_HEIGHT;
    paragraphStyle.paragraphSpacing = 0.0f;
    paragraphStyle.paragraphSpacingBefore = 0.0f;
    paragraphStyle.tailIndent = 0.0f;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if (![version hasPrefix:@"7."]) {
       self.textEditor.textContainer.layoutManager.usesFontLeading = NO;
    }
    
    NSDictionary *attribute = @{NSParagraphStyleAttributeName : paragraphStyle};
    NSString* txt = @" ";
    if ([lyrics count] > 0) {
        NSDictionary * tmp = [lyrics objectAtIndex:0];
        txt = [[tmp valueForKey:@"txt"] stringByReplacingOccurrencesOfString:@"|!|" withString:@"\n"];
        txt = [txt stringByReplacingOccurrencesOfString:@"%!%" withString:@"\""];
    }
    if (txt == nil){
        txt = @" ";
    }
    textLenght = (int)txt.length;
    [self.textEditor setFont:[UIFont fontWithName:@"Helvetica Neue" size:TEXT_FONT_SIZE]];
    self.textEditor.textColor = [UIColor grayColor];
    NSDictionary*dc = [[NSDictionary alloc] init];
    if (lyrics.count > 0)
        dc = [lyrics objectAtIndex:0];
    if (self.isPerformMode) {
        [self.textEditor setPerformMode];
        self.textEditor.editable = NO;
    }
    [self.textEditor setFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE]];
    [self.lyricsScrollView addSubview:self.textEditor];
    [self.textEditor setNeedsDisplay];
    

    if (self.isPerformMode) {
        if ([setting showLyrics]) {
            NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:txt attributes:attribute];
            CGRect paragraphRect =
            [attrS boundingRectWithSize:CGSizeMake(screenWidth/8, CGFLOAT_MAX)
                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                context:nil];
            self.textEditor.attributedText  = [[NSAttributedString alloc] initWithString:txt attributes:attribute];
            if (paragraphRect.size.height > ((screenHeight/10)*7)){
                
                countOfParts = ceilf(paragraphRect.size.height/(screenHeight/10));
                CGRect frame;
                frame = self.textEditor.frame;
                frame.size.height = self.textEditor.contentSize.height;
                self.textEditor.frame = frame;
                prefTextHeight = self.textEditor.contentSize.height;
                [self.lyricsScrollView setContentSize:CGSizeMake(screenWidth, self.textEditor.contentSize.height)];
                [self.textEditor setNeedsDisplay];
            } else {
                countOfParts = 10;
            }
            
        } else {
            countOfParts = 10;
        }
        if ([setting showChords]) {
            if (lyrics.count > 0)
                if ([dc[@"cordinates"] count] > 0) {
                    [self.textEditor addExistingChords:dc[@"cordinates"] andTitle:@"13333 e3 43232 2"];
                }
            
            
        }
    } else {
         [self.textEditor setFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE]];
        NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:txt attributes:attribute];
       
        CGRect paragraphRect =
        [attrS boundingRectWithSize:CGSizeMake(screenHeight/8, CGFLOAT_MAX)
                            options:(NSStringDrawingUsesLineFragmentOrigin)
                            context:nil];
        
        if (paragraphRect.size.height > ((screenHeight/10)*7)){
            countOfParts = ceilf(paragraphRect.size.height/(screenHeight/10));
            CGRect frame;
            frame = self.textEditor.frame;
            frame.size.height = self.textEditor.contentSize.height;
            self.textEditor.frame = frame;
            prefTextHeight = self.textEditor.contentSize.height;
            [self.lyricsScrollView setContentSize:CGSizeMake(screenWidth, self.textEditor.contentSize.height)];
        } else {
            countOfParts = 8;
        }
        self.textEditor.attributedText  = attrS;
       // self.textEditor.text = txt;
        [self.textEditor changeToLightTheme];
        if (![setting isLightTheme] && self.isPerformMode) {
            [self.textEditor changeToDarkTheme];
            self.headWrapper.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:@"#4d4d4d"];
            [self.textEditor changeToDarkTheme];
            self.textEditor.textColor = [UIColor lightGrayColor];
        }
        if (lyrics.count > 0)
            if ([dc[@"cordinates"] count] > 0)
                [self.textEditor addExistingChords:dc[@"cordinates"] andTitle:@"13333 e3 43232 2"];
      //  [self.textEditor setFont:[UIFont fontWithName:@"Helvetica Neue" size:22.0]];
    }
    [self drawSongParts:lyrics andParts:countOfParts];
    
    [self.textEditor setFont:[UIFont fontWithName:@"Helvetica Neue" size:TEXT_FONT_SIZE]];
    [self.textEditor changeToLightTheme];
    if (![setting isLightTheme] && self.isPerformMode) {
        [self.textEditor changeToDarkTheme];
        self.headWrapper.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:@"#4d4d4d"];
        [self.textEditor changeToDarkTheme];
        self.textEditor.textColor = [UIColor lightGrayColor];
    }
   
}

-(void)initTabs{
    self.tabsContainer.frame = CGRectMake(0,  screenHeight-((screenHeight/10)*2), screenWidth, (screenHeight/10)*2);
    self.firstTabContainer.frame = CGRectMake(screenWidth/8, 0, screenWidth-(screenWidth/8), (screenHeight/10)*2);
    self.secondTabContainer.frame = CGRectMake(screenWidth/8, 0, screenWidth-(screenWidth/8), (screenHeight/10)*2);
    self.tabBtn1.frame = CGRectMake(0, 0, screenWidth/8, screenHeight/10);
    self.tabBtn2.frame = CGRectMake(0, screenHeight/10, screenWidth/8, screenHeight/10);
    self.tabBtn2.backgroundColor = [UIColor lightGrayColor];
    self.tabBtn1.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:redColors[0]];
    self.firstTabContainer.backgroundColor = [UIColor yellowColor];
    self.secondTabContainer.backgroundColor = [UIColor orangeColor];
    self.secondTabContainer.hidden = YES;
    self.lyricsWrapper.frame = CGRectMake(0, screenHeight/10, screenWidth, ((screenHeight/10)*7)+10);
    self.lyricsScrollView.frame = CGRectMake(0, 0, screenWidth, ((screenHeight/10)*7)+10);
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(screenWidth/8 + 5, screenHeight/10-2, screenWidth-2*(screenWidth/8)-5,1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.headWrapper.layer addSublayer:bottomBorder];
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, 10.0f, 1.0f,screenHeight/10 - 15);
    leftBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.notesBtn.layer addSublayer:leftBorder];
    
    self.notesBtn.frame = CGRectMake(screenWidth - ((screenWidth/8)*2), 0, screenWidth/8, screenHeight/ 10 - 2);
    
    [self fillVersusesTilesForTab];
    [self fillChordsTilesForTab];
}

-(void)fillChordsTilesForTab{
    int wordNum = 0;
    int chordNum = 0;
    for (int y = 0; y < 2; y++) {
        for (int x = 0; x < 7; x++) {
             if (x == 0 && y == 0) {
                 UIView *keyOf = [[UIView alloc] initWithFrame:CGRectMake(((screenWidth/8)*x), y*(screenHeight/10), screenWidth/8, screenHeight/10)];
                 keyOf.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:@"#929292"];
                 [self.secondTabContainer addSubview:keyOf];
                 UILabel *songKey = [[UILabel alloc] initWithFrame:CGRectMake(0, keyOf.frame.size.height-30, screenWidth/8-10, 30)];
                 songKey.text = [NSString stringWithFormat:@"Key of %@", songKeyOf];
                 songKey.textAlignment = NSTextAlignmentRight;
                 songKey.textColor = [UIColor whiteColor];
                 songKey.font = [UIFont systemFontOfSize:13.0];
                 UITapGestureRecognizer *single_tap_recognizer;
                 single_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeysEditor:)];
                 [single_tap_recognizer setNumberOfTapsRequired:1];
                 [keyOf addGestureRecognizer:single_tap_recognizer];
                 [keyOf addSubview:songKey];
             }else if (x == 3 && y == 0){
                 UIView *keyOf = [[UIView alloc] initWithFrame:CGRectMake(((screenWidth/8)*x), y*(screenHeight/10), screenWidth/8, screenHeight/10)];
                 keyOf.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:@"#CCCCCC"];
                 [self.secondTabContainer addSubview:keyOf];
                 
             } else {
                 LyricsDragSource *dSource = [[LyricsDragSource alloc] initWithFrame:CGRectMake(((screenWidth/8)*x), y*(screenHeight/10), screenWidth/8, screenHeight/10)];
                 dSource.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:[[vKeys objectAtIndex:chordNum] valueForKey:@"color"]];
                 UIButton *dotsButton = [[UIButton alloc] initWithFrame:CGRectMake(dSource.frame.size.width-50, 10, 35, 10)];
                 dotsButton.titleLabel.text = @"";
                 [dotsButton setBackgroundImage:[UIImage imageNamed:@"dots_icon"] forState:(UIControlStateNormal)];
                 [dotsButton setAlpha:0.5f];
                 [dotsButton addTarget:self action:@selector(showChordsModifier:) forControlEvents:(UIControlEventTouchDown)];
                 [dSource addSubview:dotsButton];
                 [dSource setTitlePosition:CGRectMake(0, dSource.frame.size.height-30, screenWidth/8-10, 30)];
                            
                 if (![[[vKeys objectAtIndex:chordNum] valueForKey:@"modifier"] isEqualToString:@""]) {
                     [dSource setTitleText:[NSString stringWithFormat:@"%@%@",[[vKeys objectAtIndex:chordNum] valueForKey:@"chord"],[[vKeys objectAtIndex:chordNum] valueForKey:@"modifier"]]];
                 }else
                 [dSource setTitleText:[[vKeys objectAtIndex:chordNum] valueForKey:@"chord"]];
                 [dSource setMetadata:[[vKeys objectAtIndex:chordNum] valueForKey:@"chord"]];
                 [dSource setChordModifier:[[vKeys objectAtIndex:chordNum] valueForKey:@"modifier"]];
                 [dSource checkLikeChord];
                 [dSource setChordIndex:chordNum];
                 [dSource setTextAligment:NSTextAlignmentRight];
                 [dSource setTitleColor:[UIColor whiteColor]];
                 chordNum++;
                 [self.secondTabContainer addSubview:dSource];
             }
            wordNum++;
        }
    }
}

-(void)fillVersusesTilesForTab{
    int wordNum = 0;
    for (int y = 0; y < 2; y++) {
        for (int x = 0; x < 7; x++) {
            LyricsDragSource *dSource = [[LyricsDragSource alloc] initWithFrame:CGRectMake(((screenWidth/8)*x), y*(screenHeight/10), screenWidth/8, screenHeight/10)];
            
            dSource.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:redColors[arc4random()%redColors.count]];
            CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
            NSString* wordForTitle = [NSString stringWithFormat:@"%@",[vWords objectAtIndex:wordNum]] ;
            [dSource setMetadata:wordForTitle];
            CGSize size = [wordForTitle sizeWithFont:[UIFont systemFontOfSize:20.0f] constrainedToSize:maximumLabelSize];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(dSource.frame.size.width-size.width-5,
                                                                            dSource.frame.size.height-size.height-5,
                                                                            size.width,
                                                                            size.height)];
            [titleLabel setText:[vWords objectAtIndex:wordNum]];
            wordNum++;
            titleLabel.textAlignment = NSTextAlignmentRight;
            [titleLabel setNumberOfLines:0];
            titleLabel.font = [UIFont systemFontOfSize:13.0f];
            titleLabel.tag = 1;
            titleLabel.textColor = [UIColor whiteColor];
            [dSource addSubview:titleLabel];
            [self.firstTabContainer addSubview:dSource];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
    CGRect frame;
    frame = self.textEditor.frame;
    if (self.textEditor.contentSize.height <= screenHeight - ((screenHeight/10)*3)) {
        frame.size.height = screenHeight;
    }else
        frame.size.height = self.textEditor.contentSize.height;
    self.textEditor.frame = frame;
    [self.lyricsScrollView setContentSize:CGSizeMake(screenWidth, self.textEditor.contentSize.height)];
    [self.textEditor setContentOffset:CGPointZero animated:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    CGRect frame;
    frame = self.textEditor.frame;
    if (self.textEditor.contentSize.height <= screenHeight - ((screenHeight/10)*3)) {
        frame.size.height = screenHeight;
    }else
        frame.size.height = self.textEditor.contentSize.height;
    self.textEditor.frame = frame;
    [self.lyricsScrollView setContentSize:CGSizeMake(screenWidth, self.textEditor.contentSize.height)];
    [self.textEditor setContentOffset:CGPointZero animated:NO];
    
    
    if([text isEqualToString:@"\n"] || [text isEqualToString:@""]) {
        int direction = 1;
        bool shouldMoveUp = true;
        if ([text isEqualToString:@""]){
            direction = -1;
        }
        NSRange cursorPosition = [self.textEditor selectedRange];
        
        
            
            
            NSString *prevStr = @"\n";
            int countOfRows = 0;
            if (cursorPosition.location < 2) {
                prevStr = @"\n";
                countOfRows = 0;
            } else {
                prevStr = [self.textEditor.text substringWithRange:NSMakeRange(0, cursorPosition.location - 1)];
                countOfRows = (int)[[prevStr componentsSeparatedByString:@"\n"] count] ;
            }
            if (countOfRows < 0) {
                countOfRows = 0;
            }
        
            CGPoint cursorPoint = CGPointMake(0, 0);
            cursorPoint.y = countOfRows * ((screenHeight/10)/2) - 8;

        if (cursorPoint.y > self.textEditor.contentSize.height - 190 && self.textEditor.contentSize.height > self.lyricsScrollView.bounds.size.height) {
            CGPoint bottomOffset = CGPointMake(0, self.lyricsScrollView.contentSize.height - (self.lyricsScrollView.bounds.size.height-40));
            [self.lyricsScrollView  setContentOffset:bottomOffset];
        }

            if (cursorPosition.location < 2) {
                prevStr = @"\n";
                if (direction < 0) {
                    shouldMoveUp = false;
                }
                
                
            } else
                prevStr = [self.textEditor.text substringWithRange:NSMakeRange(cursorPosition.location - 2,2)];
        
        if (shouldMoveUp) {
            if ([prevStr isEqualToString:@"\n"] || [prevStr isEqualToString:@"\n "] || [prevStr isEqualToString:@" "] || [prevStr hasSuffix:@"\n"]) {
                NSMutableArray* lyricsNotes = [self.textEditor getChordsForUpdate];
                for (int i = 0; i < [lyricsNotes count]; i++) {
                    
                    
                        NSLog(@"%f %f",((LyricsDragSource*)[lyricsNotes objectAtIndex:i]).frame.origin.y, cursorPoint.y);
                        if (((LyricsDragSource*)[lyricsNotes objectAtIndex:i]).frame.origin.y >= cursorPoint.y){
                            [self.textEditor updateChordWithY:((LyricsDragSource*)[lyricsNotes objectAtIndex:i]).frame.origin.y + ((LINE_HEIGHT_MULTIPLE/2) *direction) index:[((LyricsDragSource*)[lyricsNotes objectAtIndex:i]) getMyId]];
                            ((LyricsDragSource*)[lyricsNotes objectAtIndex:i]).frame = CGRectMake(((LyricsDragSource*)[lyricsNotes objectAtIndex:i]).frame.origin.x, ((LyricsDragSource*)[lyricsNotes objectAtIndex:i]).frame.origin.y + ((LINE_HEIGHT_MULTIPLE/2) *direction), ((LyricsDragSource*)[lyricsNotes objectAtIndex:i]).frame.size.width, ((LyricsDragSource*)[lyricsNotes objectAtIndex:i]).frame.size.height);
                        }
                    
                }
            }
        }
        shouldMoveUp = true;
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    CGRect frame;
    frame = self.textEditor.frame;
    if (self.textEditor.contentSize.height <= screenHeight - ((screenHeight/10)*3)) {
        frame.size.height = screenHeight;
    }else
        frame.size.height = self.textEditor.contentSize.height;
    self.textEditor.frame = frame;
    [self.lyricsScrollView setContentSize:CGSizeMake(screenWidth, self.textEditor.contentSize.height)];
    [self.textEditor setContentOffset:CGPointZero animated:NO];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    
    CGRect frame;
    frame = self.textEditor.frame;
    
    if (self.textEditor.contentSize.height <= screenHeight - ((screenHeight/10)*3)) {
        frame.size.height = screenHeight;
    }else
        frame.size.height = self.textEditor.contentSize.height;
    self.textEditor.frame = frame;
    [self.lyricsScrollView setContentSize:CGSizeMake(screenWidth, self.textEditor.contentSize.height)];
    [self.textEditor setContentOffset:CGPointZero animated:NO];
    [self updateForHeight:self.textEditor.contentSize.height];
    [self.textEditor setNeedsDisplay];
    textChanged = true;
    
    
}

-(void)updateForHeight:(int)height{
    int heightForLeftSide = height;
    if ((prefTextHeight < height) && (height  > screenHeight - ((screenHeight/10)*3))) {
        prefTextHeight = height;
        if (self.countOfParts <= (height/(screenHeight/10))){
            NSLog(@"%f",((height/(screenHeight/10)))-self.countOfParts);
            if ((height/(screenHeight/10))-self.countOfParts < 1) {
                // add 1 tile
                heightForLeftSide+= screenHeight/10;
                [self addMoreParts:1];
                self.countOfParts++;
                NSLog(@"Add :  1");
            } else {
                heightForLeftSide+= ceilf((height/(screenHeight/10))-self.countOfParts );
                [self addMoreParts:ceilf((height/(screenHeight/10))-self.countOfParts )];
                self.countOfParts+=ceilf((height/(screenHeight/10))-self.countOfParts );
                NSLog(@"Added :  %f  ----",ceilf((height/(screenHeight/10))-self.countOfParts ));
                // how many tiles we should add
            }
        }
        NSLog(@"%f",(height/(screenHeight/10)));
        self.leftPartsContainer.frame = CGRectMake(0, PARTS_Y_OFFSET, self.leftPartsContainer.frame.size.width, heightForLeftSide);
    }
}

-(void)addMoreParts:(int)countOfnewParts{
    for (int i = 0; i < countOfnewParts; i++) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, i*(screenHeight/10)+(countOfParts*(screenHeight/10)), screenWidth/8, screenHeight/10)];
        v.backgroundColor = [UIColor whiteColor];
        LyricsDropZone *dropZone = [[LyricsDropZone alloc] initWithFrame:CGRectMake(0, 0, screenWidth/8, screenHeight/10)];
        dropZone.editorDelegate  = (id)self.textEditor;
        dropZone.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:staticColors[colorIndex]];
        colorIndex++;
        if (colorIndex > 7) {
            colorIndex = 0;
        }
        [dropZone setZonePosition:countOfParts+i];
        [dropZone initForChordsContainer:NO];
        if (self.isPerformMode) {
            [dropZone setPerformMode];
        }
        [v addSubview:dropZone];
        v.layer.zPosition = 99;
        [self setContent:v forTextView:nil andText:@"s" dropZone:nil andPosition:(self.countOfParts+i)+1];
        [parts addObject:dropZone];
    }
}

-(void)setJson:(NSDictionary*)json{
    
}
-(void)imInSet:(int)pos{
    self.chordToPerform = pos;
    self.inSet = true;
}

-(void)activatePerformMode{
    self.isPerformMode = true;
}


-(void)customInit{
    
}

-(void)saveNotes:(NSString*)notes{
    notes = [notes stringByReplacingOccurrencesOfString:@"\n" withString:@"%!%"];
    notes = [notes stringByReplacingOccurrencesOfString:@"\"" withString:@"*!*"];
    [db updateNotes:notes forChartId:[self.currentUser chartId]];
    blurView.hidden = YES;
    //[somePopup removeWithZoomOutAnimation:0.1 option:(UIViewAnimationOptionShowHideTransitionViews)];
    [self animateModalPaneOut:somePopup];
}


- (IBAction)showSecondTab:(id)sender {
    [blurView updateAsynchronously:YES completion:nil];
    self.secondTabContainer.hidden = NO;
    self.firstTabContainer.hidden = YES;
    ((UIButton*)sender).backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:redColors[0]];
    self.tabBtn1.backgroundColor = [UIColor lightGrayColor];
    [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"tab2_active"] forState:(UIControlStateNormal)];
    [self.tabBtn1 setBackgroundImage:[UIImage imageNamed:@"tab1_inactive"] forState:(UIControlStateNormal)];
}

- (IBAction)showFirstTab:(id)sender {
    [blurView updateAsynchronously:YES completion:nil];
    self.secondTabContainer.hidden = YES;
    self.firstTabContainer.hidden = NO;
    ((UIButton*)sender).backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:redColors[0]];
    [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"tab1_active"] forState:(UIControlStateNormal)];
    [self.tabBtn2 setBackgroundImage:[UIImage imageNamed:@"tab2_inactive"] forState:(UIControlStateNormal)];
    self.tabBtn2.backgroundColor = [UIColor lightGrayColor];
}

-(void)showChordsModifier:(UIButton*)chord{
    [blurView updateAsynchronously:YES completion:nil];
    somePopup = [ModifyChordsView modifyChordsDialog:(LyricsDragSource*)chord.superview andSecondDelegate:self];
    blurView.hidden = NO;
    //[self.view addSubviewWithZoomInAnimation:somePopup duration:0.1 option:(UIViewAnimationOptionCurveEaseInOut)];

    [self animateModalPaneIn:somePopup];
}

-(void)showKeysEditor:(UITapGestureRecognizer*)sender{
    [blurView updateAsynchronously:YES completion:nil];
    somePopup = [ChangeKeysView changeKeysDialog:self andSecondDelegate:self];
    
    blurView.hidden = NO;
//    [self.view addSubviewWithZoomInAnimation:somePopup duration:0.1 option:(UIViewAnimationOptionCurveEaseInOut)];
    [self animateModalPaneIn:somePopup];
}

-(void)closeKeyDialog {
    blurView.hidden = YES;
    //[somePopup removeWithZoomOutAnimation:0.1 option:(UIViewAnimationOptionCurveEaseInOut)];
    [self animateModalPaneOut:somePopup];
    
    somePopup = nil;
}

- (IBAction)showNotes:(id)sender {
    [blurView updateAsynchronously:YES completion:nil];
    blurView.hidden = NO;
    somePopup = [NotesDlg notesDialog:self];
    NSDictionary *mArr = [db getChartById:[self.currentUser chartId]];
    NSString *txt = [mArr[@"notes"] stringByReplacingOccurrencesOfString:@"%!%" withString:@"\n"];
    txt = [txt stringByReplacingOccurrencesOfString:@"*!*" withString:@"\""];
    [(NotesDlg*)somePopup showNotes:txt];

    //    [self.view addSubviewWithZoomInAnimation:somePopup duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneIn:somePopup];
}

- (NSString *) escapeString:(NSString *)string {
    NSRange range = NSMakeRange(0, [string length]);
    return [string stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:range];
}

- (IBAction)finishEditing:(id)sender {
   if (!self.isPerformMode) {
       
       NSMutableArray* lyricsForSaving = [[NSMutableArray alloc] init];
       NSString* lyrics = [[self.textEditor getSelfText] stringByReplacingOccurrencesOfString:@"\n" withString:@"|!|"];
       lyrics = [lyrics stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
       lyrics = [lyrics stringByReplacingOccurrencesOfString:@"\"" withString:@"%!%"];
       lyrics = [self escapeString:lyrics];
       NSMutableArray* lyricsNotes = [self.textEditor getSelfChords];
       NSMutableDictionary* lnT = [[NSMutableDictionary alloc] init];
       [lnT setObject:lyrics forKey:@"txt"];
       [lnT setObject:lyricsNotes forKey:@"cordinates"];
       NSMutableArray* values = [[NSMutableArray alloc] init];
       for (int i = 0; i < countOfParts; i++) {
           [values addObject:[[(LyricsDropZone*)[parts objectAtIndex:i] getSelfValue] stringByReplacingOccurrencesOfString:@"\n" withString:@"|!|"]];
       }
       [lnT setObject:values forKey:@"chorus"];
       [lyricsForSaving addObject:lnT];
       [db updateLyrics:lyricsForSaving forChartId:[self.currentUser chartId]];
       
       if ([self.currentUser getUsedMode] == MODE_FB){
           if (textChanged || [self.textEditor wasEdited]) {
               self.serverUpdater = [ServerUpdater sharedManager];
               [self.serverUpdater updateChart:[self dictionaryToString:[db getChartById:[self.currentUser chartId]]] chartId:[self.currentUser chartId]];
           }
       }
      }
    [self dismissViewControllerAnimated:YES completion:^{
        self.serverUpdater = [ServerUpdater sharedManager];
        [self.serverUpdater continueCheck];
        
    }];
}

-(NSString*)dictionaryToString:(NSDictionary*)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

-(NSString*)mutableArrayToString:(NSMutableArray*)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (void)animateModalPaneIn:(UIView *)viewToAnimate
{
    CATransition *trans = [CATransition animation];
    trans.duration = 0.15;
    trans.type = kCATransitionMoveIn;
    trans.subtype = kCATransitionFromLeft;
    
    [viewToAnimate.layer addAnimation:trans forKey:nil];
    [self.view addSubview:viewToAnimate];
}

- (void)animateModalPaneOut:(UIView *)viewToAnimate
{
    //    CATransition *trans = [CATransition animation];
    //    trans.duration = 0.2;
    //    trans.type = kCATransitionPush;
    //    trans.subtype = kCATransitionFromLeft;
    //
    //
    //    [viewToAnimate.layer addAnimation:trans forKey:nil];
    
    CGRect temp = viewToAnimate.frame;
    temp.origin.x = [[UIScreen mainScreen] bounds].size.width ;
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         viewToAnimate.frame = temp;
                     }completion:^(BOOL finished){
                         [viewToAnimate removeFromSuperview];
                     }];
}


@end



