//
//  PerformSetController.m
//  app12bar
//
//  Created by Alex on 7/25/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "PerformSetController.h"
#import "HelpViewController.h"

@interface PerformSetController (){
    IBOutlet FXBlurView *blurView;
    
}


@end

@implementation PerformSetController


bool setWasEdited;
static DBManager *db;
- (IBAction)doneClicked:(id)sender {
    
//    NSString *version = [[UIDevice currentDevice] systemVersion];
    if (setWasEdited && [self.currentUser getUsedMode] == MODE_FB) {
        
    //    [[[JsonSetHelper alloc] init] passEditedSetToUsers];
        if (self.serverUpdater == nil){
            self.serverUpdater = [ServerUpdater sharedManager];
        }
        [self.serverUpdater updateSet:[db getSetWithId:[self.currentUser setId]]  setId:[self.currentUser setId]];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateParent" object:self];
    }];
}
         
 -(NSString*)dictionaryToString:(NSDictionary*)dict{
     NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     return jsonString;
 }


-(void)saveNotes:(NSString*)notes{
    blurView.hidden = YES;
    setWasEdited = true;
   
    /*NSMutableArray * chordForUpdate = [self.currentUser.mainJson[@"sets"] mutableCopy];
    NSDictionary* mArr = [[chordForUpdate objectAtIndex:[self.currentUser.selectedSet intValue]] mutableCopy];
    [mArr setValue:[notes stringByReplacingOccurrencesOfString:@"\n" withString:@"|!|"]forKey:@"notes"];
    [chordForUpdate replaceObjectAtIndex:[self.currentUser.selectedSet intValue] withObject:mArr];
    NSMutableArray *mutableJson = [self.currentUser.mainJson mutableCopy];
    [mutableJson setValue:chordForUpdate forKey:@"sets"];
    self.currentUser.mainJson = mutableJson;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.currentUser.mainJson options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [db updateJson:jsonString]; */
    notes = [notes stringByReplacingOccurrencesOfString:@"\n" withString:@"|!|"];
    [db updateNotes:notes forSetWithId:[self.currentUser setId]];
   
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:(UIViewAnimationOptionCurveEaseInOut)];
    [self animateModalPaneOut:newChordDialog];
    newChordDialog = nil;
    
    /*if ([self.currentUser getUsedMode] == MODE_FB)
        [self.serverUpdater updatePersonalDataForFb:[self.currentUser getIdForUser] andData:jsonString];
    [[[JsonSetHelper alloc] init] updateSet:mArr];
    if ([self.currentUser getUsedMode] == 1)
        [self.serverUpdater updatePersonalDataForEmail:[self.currentUser getIdForUser] andData:jsonString];
*/
    [blurView updateAsynchronously:YES completion:^{
        
    }];
}
- (IBAction)showNotesDialog:(id)sender {
   [blurView updateAsynchronously:YES completion:nil];
      blurView.hidden = NO;
    newChordDialog = [NotesSetView notesDialog:self];
    NSDictionary* sets =[db getSetWithId:[self.currentUser setId]];
    [(NotesSetView*)newChordDialog showNotes:[sets[@"notes"] stringByReplacingOccurrencesOfString:@"|!|" withString:@"\n"]];
//    [self.view addSubviewWithFadeAnimation:newChordDialog duration:0.5f option:(UIViewAnimationOptionTransitionCrossDissolve)];
    
    [self animateModalPaneIn:newChordDialog];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [User sharedManager];
    setWasEdited = false;
    db = [DBManager sharedManager];
    chordsId = [[NSMutableArray alloc] init];
    self.chordsTable.delegate = self;
    self.chordsTable.dataSource = self;
    self.dataArray = [db getChordsForSet:[self.currentUser setId]];
    self.editing = true;
    NSDictionary* set = [db getSetWithId:[self.currentUser setId]];
    self.mainSetTitle.text = set[@"title"];
    self.smallSetTitle.text = set[@"title"];
    self.setAuthor.text = set[@"artist"];
    self.setDate.text = set[@"date"];
    self.setLocation.text = set[@"location"];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    if (self.serverUpdater == nil) {
        self.serverUpdater = [ServerUpdater sharedManager];
    }
    self.head.frame = CGRectMake(0, 0, screenWidth, screenHeight/10);
    self.chordsTable.frame = CGRectMake(0, screenHeight/10, screenWidth, screenHeight - (screenHeight/10));
    [self.chordsTable setContentSize:CGSizeMake(screenWidth, screenHeight - (screenHeight/10))];
    [self initBlur];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnBlurView)];
    tapGest.numberOfTapsRequired = 1;
    
    [blurView.underlyingView addGestureRecognizer:tapGest];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"tutsSets_firstLaunch"])
    {
        // On first launch, this block will execute
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HelpViewController *viewController = (HelpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"help"];
        [viewController setHelpFile:@"tuts_sets"];
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)); // 1
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ // 2
            
            [self presentViewController:viewController animated:YES completion:nil];
        });
        
        // Set the "hasPerformedFirstLaunch" key so this block won't execute again
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutsSets_firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)handleTapOnBlurView
{
    if (![newChordDialog isKindOfClass:[LoginScreenView class]]) {
        blurView.hidden = YES;
        [self animateModalPaneOut:newChordDialog];
        newChordDialog = nil;
    }
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

-(void)setToPerformMode{
    self.isPerform = true;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSDictionary *item = [self.dataArray objectAtIndex:fromIndexPath.row];
    [self.dataArray removeObjectAtIndex:fromIndexPath.row];
    [self.dataArray insertObject:item atIndex:toIndexPath.row];
}

/*
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


 
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // do something here
}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)_indexPath {
	if (_indexPath.row == [self.dataArray count]) {
        [self showFormForNewChord];
    } else {
       int iP = _indexPath.row;
        @try {
            [self.currentUser setChartId:[self.dataArray objectAtIndex:iP][@"chordId"]];
           
            /*int idx = 0;
            NSString* chordId = [cell getUniqueId];
            for (NSMutableDictionary* chord in self.currentUser.mainJson[@"freeChords"]) {
                if ([chordId isEqualToString:chord[@"chordId"]])
                    self.currentUser.selectedChord = [NSNumber numberWithInt:idx] ;
                idx++;
            }*/
            
            self.currentUser.selectedChordJson = [db getChartById:[self.currentUser chartId]];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LyricsTextEditorViewController *viewController = (LyricsTextEditorViewController*)[storyboard instantiateViewControllerWithIdentifier:@"editor"];
            if (self.isPerform) {
                [viewController setIsPerformMode:YES];
                [viewController imInSet:iP];
                [viewController setIds:chordsId];
            }
            [self presentViewController:viewController animated:YES completion:NULL];
        }
        @catch (NSException *exception) {
            // ignore eny error
            NSLog(@"Exception: %@",exception.description);
        }
    }
}

-(void)editChordWithIndex:(int)index{
    newChordDialog = [NewChordDialog newChordDialog:self];
    NSDictionary* dc = [db getChartById:[self.currentUser chartId]];
    [(NewChordDialog*)newChordDialog setDataForEDiting:dc[@"cTitle"] artist:dc[@"artist"] key:dc[@"key"] time_sig:dc[@"time_sig"] genre:dc[@"genre"] bpm:dc[@"bpm"] notes:dc[@"notes"]];
//    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    [self animateModalPaneIn:newChordDialog];
}

-(void)doneNewChord:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes{
    setWasEdited = true;
    time_t linkedChordId = [[[JsonChordHelper alloc] init] doneNewChord:title
                                                                artist:artist
                                                                key:key
                                                                time_sig:time_sig
                                                                genre:genre
                                                                bpm:bpm
                                                                notes:@""
                                                                  setId:[self.currentUser setId]];
    
    [db addNewChart:title artist:artist key:key time_sig:time_sig genre:genre bpm:bpm notes:notes lyrics:[[NSMutableArray alloc] init] chartId:[NSString stringWithFormat:@"%ld",linkedChordId]owner:[self.currentUser getIdForUser]];
  
    [db addChart:[NSString stringWithFormat:@"%ld", linkedChordId] IntoSet:[self.currentUser setId]];
    if ([self.currentUser getUsedMode] == MODE_FB) {
        if (self.serverUpdater == nil) {
            self.serverUpdater = [ServerUpdater sharedManager];
        }
        [self.serverUpdater pauseCheck];
       // [self.serverUpdater passNewChartWithId:[NSString stringWithFormat:@"%ld",linkedChordId]];
       // [self.serverUpdater addChartIntoSet:[NSString stringWithFormat:@"%ld",linkedChordId] setId:[self.currentUser setId]];
        [self.serverUpdater addChartIntoSetWithData:[NSString stringWithFormat:@"%ld",linkedChordId] setId:[self.currentUser setId]];
      
    }
    blurView.hidden = YES;
//    [newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    newChordDialog = nil;
    [blurView updateAsynchronously:YES completion:nil];
    self.dataArray = [db getChordsForSet:[self.currentUser setId]];
  
    [self.chordsTable reloadData];
}

-(void)updateExistingChordWith:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes transposeIndex:(int)tIndex{
    blurView.hidden = YES;
    setWasEdited = true;
//    [newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    newChordDialog = nil;
    JsonChordHelper *chordHelper = [[JsonChordHelper alloc] init];
   
    [chordHelper updateExistingChordWith:title artist:artist key:key time_sig:time_sig genre:genre bpm:bpm notes:notes transposeIndex:tIndex];
    if([self.currentUser getUsedMode] == MODE_FB){
        if (self.serverUpdater == nil) {
            self.serverUpdater = [ServerUpdater sharedManager];
        }
        [self.serverUpdater updateChart:nil chartId:[self.currentUser chartId]];
    }
    self.dataArray = [db getChordsForSet:[self.currentUser setId]];
    [self.chordsTable reloadData];
    
}

-(void)closeInfo{
    blurView.hidden = YES;
//    [newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    newChordDialog = nil;
}

-(void)showFormForNewChord{
    [blurView updateAsynchronously:YES completion:nil];
    blurView.hidden = NO;
    newChordDialog = [NewChordDialog newChordDialog:self];
//    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    [self animateModalPaneIn:newChordDialog];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)rowIndex {
    CustomTableCell *cell;
    UIView *leftChordContainer;
    UILabel *chordAuthor;
    UILabel *chordOtherInfo;
    UILabel *chordGenre;
    UILabel *chordBigTitle;
    CustomButton *menuBtn;
    
    if (rowIndex.row == [self.dataArray count]) {
       static NSString *CellIdentifierAdd = @"addChordCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierAdd];
        if (self.isPerform) {
           // cell.hidden = YES;
        }
        if (cell == nil) {
            cell = [[CustomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierAdd];
        }
        
        leftChordContainer = [cell viewWithTag:1];
        leftChordContainer.frame = CGRectMake(0, 0, screenWidth/8, screenHeight/10);
    } else {
        
        static NSString *CellIdentifier = @"chordCell";
        
        
        cell = (CustomTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSString *linkedChordId = @"";
        if ([db getChordsForSet:[self.currentUser setId]] != 0) {

            linkedChordId = [[db getChordsForSet:[self.currentUser setId]] objectAtIndex:rowIndex.row][@"chordId"];
            
            chordBigTitle =(UILabel*)[cell viewWithTag:2];

            
            self.smallSetTitle = (UILabel*)[cell viewWithTag:5];
            chordAuthor = (UILabel*)[cell viewWithTag:6];
            chordOtherInfo = (UILabel*)[cell viewWithTag:7];
            chordGenre = (UILabel*)[cell viewWithTag:8];

                NSDictionary *oneChord = [db getChartById:linkedChordId];
                    [chordsId addObject:linkedChordId];
                    [cell setUniqueId:oneChord[@"chordId"]];
                    chordBigTitle.text = oneChord[@"cTitle"];
                    self.smallSetTitle.text =  oneChord[@"cTitle"];
                    chordAuthor.text = oneChord[@"artist"];
                    chordGenre.text = oneChord[@"genre"];
                    chordOtherInfo.text = [NSString stringWithFormat:@"%@ • %@ • %@",oneChord[@"key"],oneChord[@"time_sig"],oneChord[@"bpm"]];
            
            
            
        }
        leftChordContainer = [cell viewWithTag:1];
        menuBtn = (CustomButton*)[cell viewWithTag:10];
        [menuBtn setUniqueID:linkedChordId];
        if ([self.currentUser getUsedMode]==0) {
            menuBtn.hidden = YES;
        }
        
        if (self.isPerform) {
            menuBtn.hidden = YES;
        }
        menuBtn.frame = CGRectMake(screenWidth-screenWidth/8, 0, screenWidth/8, screenHeight/10);
        [menuBtn addTarget:self action:@selector(showInfoForChord:) forControlEvents:(UIControlEventTouchUpInside)];
        
        CALayer *bottomBorder = [CALayer layer];
        
        bottomBorder.frame = CGRectMake(0.0f, 5.0f, 1.0f, screenHeight/10-10);
        
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                         alpha:1.0f].CGColor;

        [menuBtn.layer addSublayer:bottomBorder];
        leftChordContainer.frame = CGRectMake(0, 0, screenWidth/8, screenHeight/10);
        if (cell == nil) {
            cell = [[CustomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(IBAction)showInfoForChord:(id)sender{
    [blurView updateAsynchronously:YES completion:nil];
    blurView.hidden = NO;
    CustomTableCell *cell = (CustomTableCell *)[[[sender superview] superview] superview];
    indexPath = [self.chordsTable indexPathForCell:cell];
        newChordDialog = [ChartInfo chartInfo:self];
    [self.currentUser setChartId:[(CustomButton*)sender getUniqueID]];
    NSDictionary* dc = [db getChartById:[(CustomButton*)sender getUniqueID]];
    [(ChartInfo*)newChordDialog showInfo:dc[@"cTitle"] author:dc[@"artist"] key:dc[@"key"] time:dc[@"time_sig"] bpm:dc[@"bpm"] genre:dc[@"genre"]];
    
//    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.1 option:(UIViewAnimationOptionCurveEaseIn)];
    [self animateModalPaneIn:newChordDialog];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return screenHeight/10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int moreSections = 1;
    if (self.isPerform) {
        moreSections = 0;
    }
    if ((screenHeight/10)*([self.dataArray count]+moreSections) < screenHeight - (screenHeight/10)){
        self.chordsTable.frame = CGRectMake(0, screenHeight/10, screenWidth, (screenHeight/10)*([self.dataArray count]+moreSections));
    }else
        self.chordsTable.frame = CGRectMake(0, screenHeight/10, screenWidth, screenHeight - (screenHeight/10));
    return [self.dataArray count]+moreSections;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBlur{
    //    blurView.hidden = YES;
    blurView.blurRadius = 10.913934f;
    blurView.tintColor = [UIColor clearColor];
    
}

#pragma mark Chord Info delegates

-(void)chordShare{
    blurView.hidden = YES;
//    [newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    newChordDialog = nil;
}

-(void)chordEdit{
//    [newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    newChordDialog = nil;
    newChordDialog = [NewChordDialog newChordDialog:self] ;
    NSDictionary* dc = [db getChartById:[self.currentUser chartId]];
    [(NewChordDialog*)newChordDialog setDataForEDiting:dc[@"cTitle"] artist:dc[@"artist"] key:dc[@"key"] time_sig:dc[@"time_sig"] genre:dc[@"genre"] bpm:dc[@"bpm"] notes:dc[@"notes"]];
    //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneIn:newChordDialog];
};

-(void)chordPerform{
//    [newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    newChordDialog = nil;
    blurView.hidden = YES;
    self.currentUser.selectedChordJson = [db getChartById:[self.currentUser chartId]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LyricsTextEditorViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"editor"];
    viewController.isPerformMode = YES;
    [viewController activatePerformMode];
    [viewController customInit];
    [self presentViewController:viewController animated:YES completion:NULL];
}

-(void)chordDelete{
    setWasEdited = true;
    [db removeChart:[self.currentUser chartId] fromSet:[self.currentUser setId]];
//    [newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    newChordDialog = nil;
    blurView.hidden = YES;
    if([self.currentUser getUsedMode] == MODE_FB){
        [self.serverUpdater removeChart:[self.currentUser chartId] fromSet:[self.currentUser setId]];
    }
    self.dataArray = [db getChordsForSet:[self.currentUser setId]];
    [self.chordsTable reloadData];
    
};


@end
