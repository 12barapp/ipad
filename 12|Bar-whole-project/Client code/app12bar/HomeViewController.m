//
//  ViewController.m
//  app12bar
//
//  Created by Alex on 7/2/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "GMGridView.h"
#import "HelpViewController.h"
#import "ParseHelper.h"
#import "SJNotificationViewController.h"
#import "UIView+MGBadgeView.h"

#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>


#define NUMBER_ITEMS_ON_LOAD 36
#define NUMBER_ITEMS_ON_LOAD2 30

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ViewController (privates methods)
//////////////////////////////////////////////////////////////


@interface HomeViewController () {
    IBOutlet FXBlurView *blurView;
    
    IBOutlet UIView *gridContainer;
    IBOutlet UIView *setsContaine;
    
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    NSMutableDictionary *json;
    
    NSMutableArray *idForChords;
    NSMutableArray *colorsForChords;
    NSMutableArray *colorsForSets;
    NSMutableArray *idForSets;
    NSMutableArray *chords;
    NSMutableArray *sets;
    
    NSInteger _lastDeleteItemIndexAsked;
    __gm_weak NSMutableArray *_currentData;
    Reachability *internetReachable;
    Reachability *hostReachable;
    BOOL internetActive;
    BOOL hostActive;
    DBManager *db;
    CoreSettings *setting;
    
    NSMutableArray *chordsArray; // datasource for chords
    NSMutableArray *setsArray; // datasource for sets
    UIView *chartsMenu;
    UIView *setsMenu;
    
    NSTimer *timer;
}



@end

@implementation HomeViewController

@synthesize allJson, redTiles, setsGrid, onenewChords, setHelper, chordHelper, isChordsSearch, isSetSearch, foundChords, foundSets, chordPositionForSearch, setPositionForSearch, coverView, spinner, countOfPages, currentChordPage, countOfSetsPages, currentSetPage, copyingIndex;


/*
 * Event: Error during data fetch
 */
- (void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                       handleError:(NSError *)error
{
    NSLog(@"Error during data fetch.");
}

/*
 * Event: Data loaded
 */
- (void)friendPickerViewControllerDataDidChange:(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"Friend data loaded.");
}




/*
 * Event: Selection changed
 */
- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{

}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    FBFriendPickerViewController *friendPickerController = (FBFriendPickerViewController*)sender;
    NSArray * tempFriends = friendPickerController.selection;
    NSString* sharedID = [[NSString alloc] init];

    [ParseHelper initialize];
    
    for (int  i = 0; i < tempFriends.count; i++)
    {
//        NSLog(@"%@",[tempFriends objectAtIndex:i]);
        
        if (i == 0)
            sharedID = [tempFriends objectAtIndex:i][@"id"];
        else
            sharedID = [sharedID stringByAppendingString:
                        [NSString stringWithFormat:@",%@",[tempFriends objectAtIndex:i][@"id"]]];
    }
    [[sender presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    if (![sharedID isEqualToString:@""]){
        if (self.isSetSharing)
        {
            NSDictionary *tempSet = [db getSetWithId:[self.currentUser setId]];
            if ([@"0" isEqualToString:tempSet[@"serverId"]])
            {
                [self.serverUpdater passNewSetWithId:[self.currentUser setId]];
            }
            
            NSMutableArray * charts = [db getChordsForSet:[self.currentUser setId]];
            for (int i = 0; i < [charts count]; i++)
            {
                NSDictionary* chart = [db getChartById:[charts objectAtIndex:i][@"chordId"]];
                if ([@"0" isEqualToString:chart[@"serverId"]])
                {
                    [self.serverUpdater passNewChartWithId:chart[@"chordId"]];
                }
            }
            [self.serverUpdater shareSet:tempSet[@"setId"] withFriends:sharedID];
            [ParseHelper sendPushNotification:[NSString stringWithFormat:@"%@ shared a set with you!", [self.currentUser getFBName]]
                              withFacebookIDs:sharedID];
        }
        else
        {

            NSDictionary *tempChart = [db getChartById:[self.currentUser chartId]];
            if ([@"0" isEqualToString:tempChart[@"serverId"]]) {
                [self.serverUpdater passNewChartWithId:[self.currentUser chartId]];
            }
            [self.serverUpdater shareChart:tempChart[@"chordId"] withFriends:sharedID];
            [ParseHelper sendPushNotification:[NSString stringWithFormat:@"%@ shared a chart with you!", [self.currentUser getFBName]]
                              withFacebookIDs:sharedID];
        }
    }
    
    [self closeInfo];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [[sender presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)redrawChords{
    [self loadNormalChords];
}

#pragma mark Shared data delegate
-(void)updatedDataAfterSharing{
    [self loadNormalSets];
    [self loadNormalChords];
    [self.serverUpdater continueCheck];
    [self checkForSharedItems:nil];
    
    [self closeSettings];
    [self loadNormalChords];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1) {
        currentChordPage = (scrollView.contentOffset.x / scrollView.frame.size.width);
    } else {
        currentSetPage = (scrollView.contentOffset.x / scrollView.frame.size.width);
    }
    [blurView updateAsynchronously:YES completion:nil];
    
}

-(void)checkForSharedItems:(NSTimer*)timer
{
    if (![@"" isEqualToString:[self.currentUser mySecretKey]] && [self.currentUser mySecretKey] != nil) {
        NSLog(@"---- Checking for Shared Items ----");
        
        [self.serverUpdater getSharedItemsCount:^(int result) {
            NSLog(@"Count of Shared Items: %d", result);
            
            [self.settingsButton.badgeView setBadgeValue:result];
            [self.settingsButton.badgeView setPosition:MGBadgePositionTopLeft];
            [self.settingsButton.badgeView setBadgeColor:[UIColor redColor]];
            [self.settingsButton.badgeView setOutlineWidth:0.5];
        }];
    }
}

#pragma mark ServerUpdater delegates

-(void)updateChart:(NSString*)chartId withServerId:(NSString*)serverId{
    [db setServerId:serverId forChartWithId:chartId];
}


-(void)notifyAboutSharedData:(NSDictionary*)data andShared:(NSString*)shared
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SharedNotifierViewController *viewController = (SharedNotifierViewController*)[storyboard
                                                           instantiateViewControllerWithIdentifier:@"notifierController"];

    if ([data[@"freeChords"] count]> 0 || [data[@"sets"] count] > 0) {
        
        NSMutableArray *sharedCharts = [[NSMutableArray alloc] init];
        NSMutableArray *sharedSets = [[NSMutableArray alloc] init];
        NSMutableArray *updatedCharts = [[NSMutableArray alloc] init];
        NSMutableArray *updatedSets = [[NSMutableArray alloc] init];
        BOOL chartsWasUpdated = false;
        BOOL setsWasUpdated = false;
        for (int i = 0; i <  [data[@"freeChords"] count]; i++)
        {
            NSLog(@"%@", [data[@"freeChords"] objectAtIndex:i][@"cTitle"]);
            //if ([data[@"freeChords"] objectAtIndex:i][@"share_status"] != nil){
                
                //NSLog(@"%@",[data[@"freeChords"] objectAtIndex:i][@"share_status"]);
                
                if (![[data[@"freeChords"] objectAtIndex:i][@"share_status"] isEqual:[NSNull null]])
                {
                    NSLog(@"%@", [data[@"freeChords"] objectAtIndex:i][@"share_status"]);
                    if ([[data[@"freeChords"] objectAtIndex:i][@"share_status"] isEqualToString:@"1"]) {
                        NSLog(@"adding to shared charts");
                        [sharedCharts addObject:[data[@"freeChords"] objectAtIndex:i]];
                    } else {
                        NSLog(@"adding to updated charts");
                        chartsWasUpdated = true;
                        [updatedCharts addObject:[data[@"freeChords"] objectAtIndex:i]];
                    }
                }
                else {
                    chartsWasUpdated = true;
                    [updatedCharts addObject:[data[@"freeChords"] objectAtIndex:i]];
                }
            //}
        }
        
        for (int i = 0; i <  [data[@"sets"] count]; i++) {
            if ([[data[@"sets"] objectAtIndex:i][@"share_status"] isEqualToString:@"1"]) {
                [sharedSets addObject:[data[@"sets"] objectAtIndex:i]];
            } else {
                setsWasUpdated = true;
                [updatedSets addObject:[data[@"sets"] objectAtIndex:i]];
            }
        }
        
        if ([self.currentUser appIsLoaded] == YES)
        {
            if (chartsWasUpdated && setsWasUpdated) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your charts and sets have been updated." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                [db updateChartsWithServerData:updatedCharts];
                [db updateSetsWithServerData:updatedSets];
                [self loadNormalChords];
                [self loadNormalSets];
                [self.serverUpdater pauseCheck];
            } else if (setsWasUpdated) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your sets have been updated." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [db updateSetsWithServerData:updatedSets];
                [self loadNormalSets];
                [alert show];
                [self.serverUpdater pauseCheck];
            } else if (chartsWasUpdated) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your charts have been updated." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                [db updateChartsWithServerData:updatedCharts];
                [self loadNormalChords];
                [self.serverUpdater pauseCheck];
            }
        }
        
      
        if ([sharedSets count] > 0 || [sharedCharts count] > 0) {
//            [viewController showSharedCharts:sharedCharts andSets:sharedSets];
//            viewController.delegate = self;
//            [self presentViewController:viewController animated:YES completion:NULL];
//            
            int count = sharedSets.count + sharedCharts.count;
            
            [self.settingsButton.badgeView setBadgeValue:count];
            [self.settingsButton.badgeView setPosition:MGBadgePositionTopLeft];
            [self.settingsButton.badgeView setBadgeColor:[UIColor redColor]];
            [self.settingsButton.badgeView setOutlineWidth:0.5];
        }
       
    } else {
        [self.serverUpdater continueCheck];
    }
    [self.currentUser setAppIsLoaded:YES];
}

-(void)addCover {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    int screenWidth = screenSize.width;
    int screenHeight = screenSize.height;
    if (coverView == nil)
        coverView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    coverView.hidden = NO;
    coverView.backgroundColor = [UIColor blackColor];
    coverView.layer.opacity = 0.6f;
    [self.view addSubview:coverView];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    
    UIView *spinnerInfo = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2-100, screenHeight/2-50, 200, 140)];
    spinnerInfo.backgroundColor = [UIColor blackColor];
    spinnerInfo.layer.opacity = 0.3f;
    spinnerInfo.layer.cornerRadius = 5;
    UILabel *loadingText = [[UILabel alloc] initWithFrame:CGRectMake(65, 80, 100, 50)];
    loadingText.text = @"Loading...";
    loadingText.textColor = [UIColor whiteColor];
    spinner.frame = CGRectMake(screenWidth/2-150, screenHeight/2-150, 400, 400);
    spinner.hidesWhenStopped = YES;
    spinner.layer.zPosition = 999;
    spinner.center = self.view.center;
    // spinner.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:spinner];
     [coverView addSubview:spinnerInfo];
    [spinnerInfo addSubview:loadingText];
    [spinner startAnimating];
}

-(void)hideOnlyCover {
    if (coverView != nil) {
        coverView.hidden = YES;
        [spinner stopAnimating];
    }
    
    [setsArray removeAllObjects];
    [setsArray addObjectsFromArray:[self fiveOfA]];
    
    [redTiles reloadChordsWithData:setsArray];
    
    [chordsArray removeAllObjects];
    [chordsArray addObjectsFromArray:[self fiveOfA]];
    
    [setsGrid reloadChordsWithData:chordsArray];
    [self.currentUser setUsedMode:MODE_FREE];
}

-(void)hideCover{
    if (coverView != nil) {
        coverView.hidden = YES;
        [spinner stopAnimating];
    }
    
    [setsArray removeAllObjects];
    [setsArray addObjectsFromArray:[self fiveOfA]];
    
    [redTiles reloadChordsWithData:setsArray];
    
    [chordsArray removeAllObjects];
    [chordsArray addObjectsFromArray:[self fiveOfA]];
    
    [setsGrid reloadChordsWithData:chordsArray];
     [self startLoad];

}

-(void)setMessageForWaiting:(NSString*)mes{
    
}

-(void)setUserData:(NSDictionary*)userData{
    NSMutableArray *myLoadedCharts = userData[@"freeChords"];
    NSMutableArray *myLoadedSets = userData[@"sets"];
    
    NSMutableArray *nonSharedCharts = [[NSMutableArray alloc] init];
    for (NSDictionary *chart in myLoadedCharts) {
        if (![chart[@"share_status"]  isEqual: @"1"]) {
            [nonSharedCharts addObject:chart];
        }
    }
    
    NSMutableArray *nonSharedSets = [[NSMutableArray alloc] init];
    for (NSDictionary *set in myLoadedSets) {
        if (![set[@"share_status"]  isEqual: @"1"]) {
            [nonSharedSets addObject:set];
        }
    }
    
    
    [db updateChartsWithServerData:nonSharedCharts];
    [db updateSetsWithServerData:nonSharedSets];
}


#pragma mark Drag&Drop Delegates

#pragma mark Delegate methods

-(void)closeInfo{
    blurView.hidden = YES;
//    [newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
}

-(void)updateExistingSet:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location{
    blurView.hidden = YES;
    
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
   // [setHelper updateExistingSet:title artist:artist date:date location:location];
    NSDictionary *set = [db getSetWithId:[self.currentUser setId]];
    [db updateSet:title artist:artist date:date location:location notes:set[@"notes"] chords:set[@"chords"] withId:[self.currentUser setId]];
    [self reloadSets];
    if([self.currentUser getUsedMode] == MODE_FB){
         NSDictionary *set = [db getSetWithId:[self.currentUser setId]];
        [self.serverUpdater updateSet:set setId:[self.currentUser setId]];
    }
}

-(NSString*)dictionaryToString:(NSDictionary*)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

-(void)updateExistingChordWith:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes transposeIndex:(int)tIndex{
    blurView.hidden = YES;
    
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    [chordHelper updateExistingChordWith:title artist:artist key:key time_sig:time_sig genre:genre bpm:bpm notes:notes transposeIndex:tIndex];
    [self loadNormalChords];
    if ([self.currentUser getUsedMode] == MODE_FB) {
        [self.serverUpdater updateChart:[self dictionaryToString:[db getChartById:[self.currentUser setId]]] chartId:[self.currentUser chartId]];
    }
}



-(void)doneNewSet:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location{
    blurView.hidden = YES;
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    if(self.currentUser.selectedSet == nil){
        self.currentUser.selectedSet = 0;
        [self selectedSet:0];
    }
    NSString* linkedChordId = [setHelper doneNewSet:title artist:artist date:date location:location];
    [db addNewSet:title artist:artist date:date location:location notes:@"" chords:[[NSMutableArray alloc] init] withId:linkedChordId owner:[self.currentUser getIdForUser]];
    if ([self.currentUser getUsedMode] == MODE_FB) {
        [self.serverUpdater passNewSetWithId:linkedChordId];
    }
    [blurView updateAsynchronously:YES completion:nil];
    [self loadNormalSets];
};


-(void)doneNewChord:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes{
    time_t linkedChordId =[chordHelper doneNewChord:title artist:artist key:key time_sig:time_sig genre:genre bpm:bpm notes:notes setId:[NSString stringWithFormat:@"%d",0]];
   
    [db addNewChart:title artist:artist key:key time_sig:time_sig genre:genre bpm:bpm notes:@"" lyrics:[[NSMutableArray alloc] init] chartId:[NSString stringWithFormat:@"%ld",linkedChordId]owner:[self.currentUser getIdForUser]];
    blurView.hidden = YES;
    
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    [self loadNormalChords];
    if ([self.currentUser getUsedMode] == MODE_FB)
        [self.serverUpdater passNewChartWithId:[NSString stringWithFormat:@"%ld",linkedChordId]];
    [blurView updateAsynchronously:YES completion:nil];
    [self.serverUpdater pauseCheck];
}

-(void)orderCharts{
    blurView.hidden = NO;
    newChordDialog = [OrderChordsDialog orderDialog:self];
//    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    [self animateModalPaneIn:newChordDialog];
}


-(void)loadNormalSets{
    isSetSearch = false;
    [self reloadSets];
}

-(void)reloadSets {
    chordsArray = [NSMutableArray arrayWithArray:[self fiveOfA]];
    idForSets = [NSMutableArray arrayWithArray:[self fiveOfA]];
    NSArray* setsForRemove = [setsContaine subviews];
    for (UIView *v in setsForRemove) {
        [v removeFromSuperview];
    }
    [self.allSets removeAllObjects];
    countOfSetsPages = ceilf(([db countOfSets])/34.0f);
    if (countOfSetsPages == 0.0f) {
        countOfSetsPages = 1.0f;
    }
    self.allSets = [db getMySetsWithOrder:[self.currentUser orderKeyForSets]];
    [self.setsStorage removeAllObjects];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height-8;
    for (int i = 0; i < countOfSetsPages; i++) {
        setsGrid = [[SetsGrid alloc] initWithData:[self.allSets objectAtIndex:i][@"data"] andIds:[self.allSets objectAtIndex:i][@"id"] withFrame:CGRectMake((screenWidth*i), 0, screenWidth,(int)(screenHeight/2)+8) andContainer:setsContaine];
        setsGrid.delegate = self;
        [self.setsStorage addObject:setsGrid];
    }
    [blurView updateAsynchronously:YES completion:nil];
}

-(void)loadNormalChords{
    isChordsSearch = false;
    countOfPages = ceilf(([db countOfCharts] )/35.0f);
    if (countOfPages == 0.0f) {
        countOfPages = 1.0f;
    }
    [self.chordsStorage removeAllObjects];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height-8;
    NSArray *arr = [gridContainer subviews];
    for (UIView *v in arr) {
        [v removeFromSuperview];
    }
    self.allChords = [db getMyChartsWithOrder:[self.currentUser orderKeyForChart]];
    for (int  i = 0; i < countOfPages; i++) {
        redTiles = [[ChordsGrid alloc] initWithData:[self.allChords objectAtIndex:i][@"data"] andIds:[self.allChords objectAtIndex:i][@"id"]  withFrame:CGRectMake(screenWidth*i, 0, screenWidth,(int)(screenHeight/2)-4) andContainer:gridContainer owner:self];
        redTiles.delegate = self;
        
        [self.chordsStorage addObject:redTiles];
    }
    [self.chordsPager setContentSize:CGSizeMake(screenWidth*countOfPages, (screenHeight/2)-8)];
    [blurView updateAsynchronously:YES completion:nil];
}

-(void)searchCharts{
    blurView.hidden = NO;
    newChordDialog = [SearchChordDialog chordSearchDialog:self];
//    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    [self animateModalPaneIn:newChordDialog];
}

-(void)addChord{
    blurView.hidden = NO;
    newChordDialog = [NewChordDialog newChordDialog:self];
    
    //[self.view addSubviewWithFadeAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionTransitionFlipFromLeft];
    
    [self animateModalPaneIn:newChordDialog];
}

#pragma mark Friend Picker Delegates
-(void)cancel{
    blurView.hidden = YES;
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    
};

-(void)shareWithFriends{
    blurView.hidden = YES;
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    
    SJNotificationViewController *_notificationController = [[SJNotificationViewController alloc] initWithNibName:@"SJNotificationViewController" bundle:nil];
    [_notificationController setParentView:self.view];
    [_notificationController setNotificationTitle:@"Hello"];
    [_notificationController show];
    
};

#pragma Facebook Delegates
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {

}

- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {

        } else {
            NSLog(@"error %@", error.description);
        }
    }];
}


#pragma mark Login Screen Delegates
-(void)loginWithFacebook{
   
    if (self->internetActive == YES && self->hostActive == YES)
    {
        [self addCover];
        if (FBSession.activeSession.isOpen )
        {
            [self UserInformation];
            //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
            [self animateModalPaneOut:newChordDialog];
            
            setsArray = [NSMutableArray arrayWithArray:[self fiveOfA]];
            idForChords = [NSMutableArray arrayWithArray:[self fiveOfA]];
            [redTiles reloadChordsWithData:setsArray];
            [setsGrid reloadChordsWithData:setsArray];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self hideCover];
                
                if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
                    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];
                }
                
                [ParseHelper registerInstallationforFacebookID:[self.currentUser getIdForUser]];
                
                [self checkForSharedItems:nil];
                timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(checkForSharedItems:) userInfo:nil repeats:YES];
            });
            
            
            [self checkForFirstTimeLoad];
        }
        else
        {
            NSArray *permissions = [[NSArray alloc] initWithObjects:@"user_friends", nil];
            [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
             {
                 if(!error)
                 {
                     //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
                     [self animateModalPaneOut:newChordDialog];
                     
                     [self UserInformation];
                     
                     setsArray = [NSMutableArray arrayWithArray:[self fiveOfA]];
                     idForChords = [NSMutableArray arrayWithArray:[self fiveOfA]];
                     [redTiles reloadChordsWithData:setsArray];
                     [setsGrid reloadChordsWithData:setsArray];
                     
                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                         
                         [self hideCover];
                         
                         if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
                             [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];
                         }
                         
                         [ParseHelper registerInstallationforFacebookID:[self.currentUser getIdForUser]];
                         
                         [self checkForSharedItems:nil];
                         timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(checkForSharedItems:) userInfo:nil repeats:YES];
                     });
                     
                     [self checkForFirstTimeLoad];
                 }else
                 {
                     NSLog(@"inside error if");
                     [self hideOnlyCover];
                     //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
                     [self animateModalPaneOut:newChordDialog];
                     
                     [self showLoginScreen];
                 }
             }];
        }
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Sorry, we coldn't connect at this moment." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)UserInformation
{
     [FBRequestConnection startWithGraphPath:@"me" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error ){
                [[[FBSession activeSession] accessTokenData] accessToken];
                NSString *userName = [result objectForKey:@"name"];
                NSString *userid= [result objectForKey:@"id"];
                
                //NSLog(@"%@", userName);
                //NSLog(@"%@", userid);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:userName forKey:@"userFbName"];
                [defaults setObject:userid forKey:@"userFbID"];
                [defaults synchronize];
                
                [self.currentUser setUsedMode:MODE_FB];
                //self.serverUpdater = [ServerUpdater sharedManager];
                self.serverUpdater.delegate = self;
                [self.currentUser setIdForUser:userid];
                [self.currentUser setUserFbName:userName];
                [self.serverUpdater loginUserWithFb:userid];
                blurView.hidden = YES;
                
                //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
                [self animateModalPaneOut:newChordDialog];
                
                newChordDialog = nil;
                setsArray = [NSMutableArray arrayWithArray:[self fiveOfA]];
                idForChords = [NSMutableArray arrayWithArray:[self fiveOfA]];
                [redTiles reloadChordsWithData:setsArray];
                [setsGrid reloadChordsWithData:setsArray];
                
            }
            else {
                NSLog(@"%@",error);
            }
        }];
}

-(void)checkForFirstTimeLoad
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"tutsHome_firstLaunch"])
    {
        // On first launch, this block will execute
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HelpViewController *viewController = (HelpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"help"];
        [viewController setHelpFile:@"tuts_home"];
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)); // 1
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ // 2
            
            //[self presentViewController:viewController animated:YES completion:nil];
            [self recallTutsWithOptions:TutorialSetHome];
        });
        
        // Set the "hasPerformedFirstLaunch" key so this block won't execute again
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutsHome_firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)loginWithEmail{
    blurView.hidden = YES;
    
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    blurView.hidden = NO;
    newChordDialog = [EmailTyper emailTyper:self];
    
    //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    [self animateModalPaneIn:newChordDialog];
}

-(void)freeView{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (__bridge NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    NSLog(@"UDID: [%@]", uuidString);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:uuidString forKey:@"userUDID"];
    [defaults synchronize];
   
    blurView.hidden = YES;
    [self.currentUser setUsedMode:MODE_FREE];
    
    if ([defaults objectForKey:@"userFbID"]) {
        [self.currentUser setUserId:[defaults objectForKey:@"userFbID"]];
    }
    else [self.currentUser setUserId:@"free"];
    
    [timer invalidate];
    timer = nil;

    [self.settingsButton.badgeView setBadgeValue:0];
    
    setsArray = [NSMutableArray arrayWithArray:[self fiveOfA]];
    idForChords = [NSMutableArray arrayWithArray:[self fiveOfA]];
    [self startLoad];
    
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    
    [self checkForFirstTimeLoad];
}

#pragma Mark Email login delegates
-(void)cancelEmail{
    blurView.hidden = YES;
    [self.currentUser setUsedMode:MODE_FREE];
    
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    [self showLoginScreen];
}

-(void)loginWithEmail:(NSString*)email{
    [self addCover];
    
    self.serverUpdater = [ServerUpdater sharedManager];
  //  [self.serverUpdater loginUserWithEmail:email];
    self.serverUpdater.delegate = self;
    blurView.hidden = YES;
    
    setsArray = [NSMutableArray arrayWithArray:[self fiveOfA]];
    idForChords = [NSMutableArray arrayWithArray:[self fiveOfA]];
    [redTiles reloadChordsWithData:setsArray];
    [setsGrid reloadChordsWithData:setsArray];
    [self.currentUser setUsedMode:MODE_EMAIL];
    
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
}


#pragma mark About delegate
-(void)closeAbout{
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    blurView.hidden = NO;
    newChordDialog = [SettingsDialog settingsDialog:self];
    
    [(SettingsDialog*)newChordDialog setNumberOfSharedItems:self.settingsButton.badgeView.badgeValue];
    [(SettingsDialog*)newChordDialog initSettings];
    [(SettingsDialog*)newChordDialog setParentController:self];
    [(SettingsDialog*)newChordDialog setParentDelegate:self];
    
    //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    [self animateModalPaneIn:newChordDialog];
}

#pragma mark Tell a Friend delegates

-(void)cancelMail{
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    blurView.hidden = NO;
    newChordDialog = [SettingsDialog settingsDialog:self];
    
    //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    [self animateModalPaneIn:newChordDialog];
};

-(void)sendMail:(NSString*)to andMes:(NSString*)m{
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    blurView.hidden = NO;
    newChordDialog = [SettingsDialog settingsDialog:self];
    
//    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    [self animateModalPaneIn:newChordDialog];
};

#pragma mark Settings delegate methods
-(void)logOut{
    
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    [blurView updateAsynchronously:YES completion:nil];
    blurView.hidden = NO;
    [self.currentUser setUserId:@""];
    [self.allChords removeAllObjects];
    [self.allSets removeAllObjects];
    [foundChords removeAllObjects];
    [foundSets removeAllObjects];
    self.chordsStorage = [[NSMutableArray alloc] init];
    self.setsStorage  = [[NSMutableArray alloc] init];
    self.currentChordPage = 0;
    self.currentSetPage = 0;
    countOfPages = 0;
    countOfSetsPages = 0;
    [self.currentUser setLatesDateForChart:@""];
    [self.currentUser setLatestUpdateDateForChart:@""];
    [self.currentUser setLatestUpdatedSetDate:@""];
    [self.currentUser setLatestUpdateDateForSet:@""];
    [self.serverUpdater pauseCheck];
    setsArray = [NSMutableArray arrayWithArray:[self fiveOfA]];
    idForChords = [NSMutableArray arrayWithArray:[self fiveOfA]];
    
    if (self.currentUser.usedMode == 2) {
        [FBSession.activeSession closeAndClearTokenInformation];
        
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for(NSHTTPCookie *cookie in [storage cookies])
        {
            NSString *domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"facebook"];
            if(domainRange.length > 0)
            {
                [storage deleteCookie:cookie];
            }
        }
       
        [FBSession setActiveSession:nil];
    
    }
    
    [self.settingsButton.badgeView setBadgeValue:0];
    
    [self showLoginScreen];
}

-(void)showAbout{
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    blurView.hidden = NO;
    newChordDialog = [About about:self];
    
//    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneIn:newChordDialog];
}


-(void)showPrivacy{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = (UIViewController*)[storyboard instantiateViewControllerWithIdentifier:@"privacyController"];
    [self presentViewController:viewController animated:YES completion:NULL];
    
}

- (void)recallTuts {
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    blurView.hidden = NO;
    newChordDialog = [TutorialsView tutorials:TutorialSetAll];
    
    //    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneIn:newChordDialog];
    
}

- (void)recallTutsWithOptions:(TutorialSet) set {
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    blurView.hidden = NO;
    newChordDialog = [TutorialsView tutorials:set];
    
    [self animateModalPaneIn:newChordDialog];
}

-(void)mailTofriend{
      NSString *emailTitle = @"Check out 12Bar";
    // Email Content
    NSString *messageBody = @"Check out this app called 12Bar! It really is the easiest way to create and share charts and sets!";
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
   }


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark EmailShoring delegates

-(void)cancelEmailSharing{
    blurView.hidden = YES;
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneOut:newChordDialog];
    
}



#pragma mark Chart Info Delegates
-(void)chordShare{
    
    
    if ([self.currentUser getUsedMode] == MODE_EMAIL) {
        //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseIn];
        [self animateModalPaneOut:newChordDialog];
        
        blurView.hidden = NO;
        newChordDialog = [FriendEmailTyper emailFriend:self];
        
        //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
        
        [self animateModalPaneIn:newChordDialog];
        
    }else if ([self.currentUser getUsedMode] == MODE_FB){
        self.isSetSharing = false;
        [self sendRequest];
       
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login to share your chart."  delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
   
}

- (void)sendRequest {
   [self.navigationController setNavigationBarHidden:NO animated:NO];
    FBFriendPickerViewController *friendPickerController =
    [[FBFriendPickerViewController alloc] init];
    friendPickerController.delegate = self;

    // Set the friend picker title
    friendPickerController.navigationItem.title = @"Pick Friends";
    friendPickerController.userID = self.currentUser.getIdForUser;
    friendPickerController.session = FBSession.activeSession;
    friendPickerController.hidesBottomBarWhenPushed = NO;
    friendPickerController.doneButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Done"
                                         style:UIBarButtonItemStyleDone
                                         target:self
                                         action:@selector(facebookViewControllerDoneWasPressed:)];
    friendPickerController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                      initWithTitle:@"Done"
                                                      style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(facebookViewControllerDoneWasPressed:)];
    [friendPickerController loadData];
    [friendPickerController presentModallyFromViewController:self animated:YES handler:nil];
    
}

-(void)chordEdit{
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    newChordDialog = [NewChordDialog newChordDialog:self] ;
    NSDictionary* dc = [db getChartById:[self.currentUser chartId]];
    [(NewChordDialog*)newChordDialog setDataForEDiting:dc[@"cTitle"] artist:dc[@"artist"] key:dc[@"key"] time_sig:dc[@"time_sig"] genre:dc[@"genre"] bpm:dc[@"bpm"] notes:dc[@"notes"]];

//    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    [self animateModalPaneIn:newChordDialog];
};

-(void)chordPerform{
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    blurView.hidden = YES;
   
    self.currentUser.selectedChordJson = [self.currentUser.currentChords objectAtIndex:[self.currentUser.selectedChord intValue]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LyricsTextEditorViewController *viewController = (LyricsTextEditorViewController *)[storyboard instantiateViewControllerWithIdentifier:@"editor"];
    ((LyricsTextEditorViewController*)viewController).isPerformMode = YES;
    [(LyricsTextEditorViewController*)viewController activatePerformMode];
    [(LyricsTextEditorViewController*)viewController customInit];

    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:viewController animated:YES completion:NULL];
};

-(void)chordDelete
{
    UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Delete Chart"
                                                      message:@"Are you sure you want to delete this chart?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Delete", nil];
    confirm.tag = 1;
    [confirm show];

//    [db removeChartWithId:[self.currentUser chartId]];
//    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
//    [self animateModalPaneOut:newChordDialog];
//    
//    newChordDialog = nil;
//    blurView.hidden = YES;
//    if ([self.currentUser getUsedMode] == MODE_FB)
//    {
//        NSDictionary *chart = [db getChartById:[self.currentUser chartId]];
//        
//        if ([chart[@"owner"] isEqualToString:[self.currentUser getIdForUser]]) {
//            [self.serverUpdater removeChart:chart[@"chordId"]];
//        } else {
//            [self.serverUpdater removeChartForMe:chart[@"chordId"]];
//        }
//    }
//    
//    [blurView updateAsynchronously:YES completion:nil];
//    
//    [self loadNormalChords];
//    [self.serverUpdater removeChart:[self.currentUser chartId]];
}

#pragma mark Set Info Delegates

-(void)deleteSet
{
    UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Delete Set"
                                                      message:@"Are you sure you want to delete this set?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Delete", nil];
    confirm.tag = 2;
    [confirm show];
   
//    [db removeSetWithId:[self.currentUser setId]];
//    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
//    [self animateModalPaneOut:newChordDialog];
//    
//    newChordDialog = nil;
//    blurView.hidden = YES;
//    if ([self.currentUser getUsedMode] == MODE_FB)
//    {
//        NSDictionary *set = [db getSetWithId:[self.currentUser setId]];
//        if ([set[@"owner"] isEqualToString:[self.currentUser getIdForUser]]) {
//           [self.serverUpdater removeSet:[self.currentUser setId]];
//        } else {
//            [self.serverUpdater removeSetForMe:[self.currentUser setId]];
//        }
//    }
//    
//    [blurView updateAsynchronously:YES completion:nil];
//    
//    [self loadNormalSets];
//    [self.serverUpdater removeSet:[self.currentUser setId]];
    
};

-(void)editSet{
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    blurView.hidden = NO;
    newChordDialog = [NewSetDialog newSetDialog:self];
    NSDictionary* dc =[db getSetWithId:[self.currentUser setId]];
    [(NewSetDialog*)newChordDialog setDataForEDiting:dc[@"title"] artist:dc[@"artist"] date:dc[@"date"] location:dc[@"location"]];
    
//    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneIn:newChordDialog];
};

-(void)performSet{
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
    blurView.hidden = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PerformSetController *viewController = (PerformSetController *)[storyboard instantiateViewControllerWithIdentifier:@"performer"];
    [viewController setToPerformMode];
    
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:viewController animated:YES completion:nil];
    
};

-(void)shareSet{
    if ([self.currentUser getUsedMode] == MODE_EMAIL) {
        //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseIn];
        [self animateModalPaneOut:newChordDialog];
        
        blurView.hidden = NO;
        newChordDialog = [FriendEmailTyper emailFriend:self];
        [(FriendEmailTyper*)newChordDialog setSharingSet:YES];
        
        //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
        [self animateModalPaneIn:newChordDialog];
        
    }else if ([self.currentUser getUsedMode] == MODE_FB){
        self.isSetSharing = true;
        [self sendRequest];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login to share your set."  delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
};

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

#pragma mark Chords Grid delegates
- (void)selectedChord:(NSInteger)position withId:(NSString*)chordId{
    [self.currentUser setChartId:chordId];
}

-(void)startedDragging{
    self.chordsPager.scrollEnabled = NO;
    self.setsPager.scrollEnabled = NO;
}

-(void)canceledDragging{
    self.chordsPager.scrollEnabled = YES;
    self.setsPager.scrollEnabled = YES;
}

#pragma mark Sets grid delegates

- (void)copyChord:(int)chordId intoSet:(int)setId andUID:(NSString*)uId setId:(NSString *)setId_{
    [db addChart:uId IntoSet:setId_];
    
    if ([self.currentUser getUsedMode] == MODE_FB){
        [self.serverUpdater addChartIntoSet:uId setId:setId_];
    }
}

-(void)exchangeChordItemAtIndex:(NSString*)index1 withItemIndex:(NSString*)index2{
    [self.currentUser setOrderKeyForChart:@"order_number"];
    [db exchangeChart:index1 withChart:index2];
}

- (void) exchangeSetItemAtIndex:(NSString*)index1 withItemAtIndex:(NSString*)index2{
    [self.currentUser setOrderKeyForSets:@"order_number"];
    [db exchangeSet:index1 withChart:index2];
   
}

-(void)updateBlurImage{
    [blurView updateAsynchronously:YES completion:nil];
}

-(void)selectedSet:(NSInteger)position{
    if (isSetSearch) {
        self.currentUser.selectedSet = [foundSets objectAtIndex:position][@"foundIndex"];
    }else
        self.currentUser.selectedSet = [NSNumber numberWithInteger:position+(currentSetPage*34)];
    
    NSLog(@"Changed set number ned reload chords %d",[self.currentUser.selectedSet intValue]);
}

- (void)didTapSetLabelWithGesture:(UITapGestureRecognizer*)label{
    [self.currentUser setSetId:[(CustomButton*)label getUniqueID]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *viewController = (HomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"performer"];
    
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:viewController animated:YES completion:NULL];
    
};
- (void)showSetInfo:(UITapGestureRecognizer*)label
{
    blurView.hidden = NO;
    [self.currentUser setSetId:[(CustomButton*)label getUniqueID]];
    newChordDialog = [SetInfo setInfo:self];
    NSDictionary* dc =[db getSetWithId:[self.currentUser setId]];
    [(SetInfo*)newChordDialog showInfo:dc[@"title"] author:dc[@"artist"] date:dc[@"date"] location:dc[@"location"]];

    //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneIn:newChordDialog];
}

#pragma mark Order Set delegates
-(void)orderSetByTitle{
    [self.currentUser setOrderKeyForSets:@"title"];
    [self loadNormalSets];
    [self closeOrder];
};

-(void)orderSetByAuthor{
    [self.currentUser setOrderKeyForSets:@"artist"];
    [self loadNormalSets];
    [self closeOrder];
};

-(void)orderSetByDate{
    [self.currentUser setOrderKeyForSets:@"date"];
    [self loadNormalSets];
    [self closeOrder];
};

-(void)orderSetByLocation{
    [self.currentUser setOrderKeyForSets:@"location"];
    [self loadNormalSets];
    [self closeOrder];
}


#pragma mark Order Chord
// from order
-(void)closeOrder{ blurView.hidden = YES;
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
}

-(void)orderByTitle{
    [self.currentUser setOrderKeyForChart:@"title"];
    [self loadNormalChords];
    [self closeOrder];
};


-(void)orderByBpm{
    [self.currentUser setOrderKeyForChart:@"bpm"];
    [self loadNormalChords];
    [self closeOrder];
};
-(void)orderByAuthor{
    [self.currentUser setOrderKeyForChart:@"artist"];
    [self loadNormalChords];
    [self closeOrder];
};
-(void)orderByKey{
    [self.currentUser setOrderKeyForChart:@"key"];
    [self loadNormalChords];
    [self closeOrder];
};
-(void)orderByGenre{
    [self.currentUser setOrderKeyForChart:@"genre"];
    [self loadNormalChords];
    [self closeOrder];
};
-(void)orderByTime{
    [self.currentUser setOrderKeyForChart:@"time"];
    [self loadNormalChords];
    [self closeOrder];
}

-(void)orderChordsByKey:(NSString*)key{
    //[chordHelper orderChordsByKey:key];
   
    [redTiles reloadChordsWithData:setsArray];
[blurView updateAsynchronously:YES completion:nil];
    [self closeOrder];
}


// ------------------------------------------------
#pragma mark Search Set Dialog
-(void)searchSetByAuthor:(NSString*)searchText
{
    if (![searchText isEqualToString:@""])
    {
        isSetSearch = true;
        NSMutableArray* searchresult = [db findSetWithCriteria:@"author" andPhrase:searchText];
        [(SetsMenu*)setsMenu setSearchToGray];
        [self reloadSetsWithSearchResult:searchresult];
        [self closeSearch];
    }
}

-(void)searchSetByTitle:(NSString*)searchText{
    if (![searchText isEqualToString:@""])
    {
        isSetSearch = true;
        
        NSMutableArray* searchresult = [db findSetWithCriteria:@"title" andPhrase:searchText];

        [(SetsMenu*)setsMenu setSearchToGray];
        [self reloadSetsWithSearchResult:searchresult];
        [self closeSearch];
    }
}

-(void)searchSetByDate:(NSString*)searchText{
    if (![searchText isEqualToString:@""])
    {
        isSetSearch = true;
         NSMutableArray* searchresult = [db findSetWithCriteria:@"date" andPhrase:searchText];
        [(SetsMenu*)setsMenu setSearchToGray];
        [self reloadSetsWithSearchResult:searchresult];
        [self closeSearch];
    }
}

-(void)searchSetByLocation:(NSString*)searchText{
    if (![searchText isEqualToString:@""])
    {
        isSetSearch = true;
        NSMutableArray* searchresult = [db findSetWithCriteria:@"location" andPhrase:searchText];
        [(SetsMenu*)setsMenu setSearchToGray];
        [self reloadSetsWithSearchResult:searchresult];
        [self closeSearch];
    }
}

-(void)reloadSetsWithSearchResult:(NSMutableArray*)result{
    if (result.count > 0) {
        if (foundSets == nil)
            foundSets = [[NSMutableArray alloc] init];
        foundSets = result;
    }
    [setsArray removeAllObjects];
    [self.allSets removeAllObjects];
    self.allSets = result;
    countOfSetsPages = ceilf(([db lastSearchCiount] - 5.0f)/34.0f);
    if (countOfSetsPages == 0.0f) {
        countOfSetsPages = 1.0f;
    }
    NSArray* setsForRemove = [setsContaine subviews];
    for (UIView *v in setsForRemove) {
        [v removeFromSuperview];
    }
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height-8;
    [setsContaine setFrame:CGRectMake(0, 0, screenWidth*countOfSetsPages,(int)(screenHeight/2))];
    for (int i = 0; i < countOfSetsPages; i++) {
        setsGrid = [[SetsGrid alloc] initWithData:[self.allSets objectAtIndex:i][@"data"] andIds:[self.allSets objectAtIndex:i][@"id"] withFrame:CGRectMake((screenWidth*i), 0, screenWidth,(int)(screenHeight/2)+8) andContainer:setsContaine];
        setsGrid.delegate = self;
        [self.setsStorage addObject:setsGrid];
    }
}

#pragma mark Search Chord Dialog
///////////////  Search Chord Dialog Methods //////

-(void)reloadChordsWithSearchResult:(NSMutableArray*)result{
    if (result.count > 0) {
        if (foundChords == nil) {
            foundChords = [[NSMutableArray alloc] init];
        }
        foundChords = result;
    }
    countOfPages = ceilf(([db lastSearchCiount] )/35.0f);
    if (countOfPages == 0.0f) {
        countOfPages = 1.0f;
    }
    
    NSArray *arr = [gridContainer subviews];
    for (UIView *v in arr) {
        [v removeFromSuperview];
    }
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height-8;
    self.allChords = result;
    [self.chordsStorage removeAllObjects];
    for (int  i = 0; i < countOfPages; i++) {
        redTiles = [[ChordsGrid alloc] initWithData:[self.allChords objectAtIndex:i][@"data"] andIds:[self.allChords objectAtIndex:i][@"id"] withFrame:CGRectMake(screenWidth*i, 0, screenWidth,(int)(screenHeight/2)-4) andContainer:gridContainer owner:self];
        redTiles.delegate = self;
        
        [self.chordsStorage addObject:redTiles];
    }
    [self.chordsPager setContentSize:CGSizeMake(screenWidth*countOfPages, (screenHeight/2)-8)];
}

-(void)searchByAuthor:(NSString*)searchText{
    if (![searchText isEqualToString:@""])
    {
        isChordsSearch = true;
        NSMutableArray* searchresult = [db findChartWithCriteria:@"author" andPhrase:searchText];
        [(ChordsMenu*)chartsMenu setSearchToGray];
        [self reloadChordsWithSearchResult:searchresult];
        [self closeSearch];
    }
};
-(void)searchByTitle:(NSString*)searchText{
    if (![searchText isEqualToString:@""])
    {
        isChordsSearch = true;
        NSMutableArray* searchresult = [db findChartWithCriteria:@"title" andPhrase:searchText];
        [(ChordsMenu*)chartsMenu setSearchToGray];

        [self reloadChordsWithSearchResult:searchresult];
        [self closeSearch];
    }
};

-(void)searchByKey:(NSString*)searchText{
    if (![searchText isEqualToString:@""])
    {
        isChordsSearch = true;
        NSMutableArray* searchresult = [db findChartWithCriteria:@"key" andPhrase:searchText];
        [(ChordsMenu*)chartsMenu setSearchToGray];
        [self reloadChordsWithSearchResult:searchresult];
        
        [self closeSearch];
    }
}

-(void)searchByLyrics:(NSString*)searchText{
    if (![searchText isEqualToString:@""])
    {
        isChordsSearch = true;
        NSMutableArray* searchresult = [db findChartWithCriteria:@"lyrics" andPhrase:searchText];
        [(ChordsMenu*)chartsMenu setSearchToGray];
        [self reloadChordsWithSearchResult:searchresult];
        [self closeSearch];
    }
}

-(void)searchByTime:(NSString*)searchText{
    if (![searchText isEqualToString:@""])
    {
        isChordsSearch = true;
        NSMutableArray* searchresult = [db findChartWithCriteria:@"time" andPhrase:searchText];
        [(ChordsMenu*)chartsMenu setSearchToGray];
        [self reloadChordsWithSearchResult:searchresult];
        [self closeSearch];
    }
}

-(void)searchByBpm:(NSString*)searchText{
    if (![searchText isEqualToString:@""])
    {
        isChordsSearch = true;
       NSMutableArray* searchresult = [db findChartWithCriteria:@"bpm" andPhrase:searchText];
        [(ChordsMenu*)chartsMenu setSearchToGray];
        [self reloadChordsWithSearchResult:searchresult];
        [self closeSearch];
    }
}

-(void)searchByGenre:(NSString*)searchText{
    if (![searchText isEqualToString:@""])
    {
        isChordsSearch = true;
        NSMutableArray* searchresult = [db findChartWithCriteria:@"genre" andPhrase:searchText];
        [(ChordsMenu*)chartsMenu setSearchToGray];
        [self reloadChordsWithSearchResult:searchresult];
        [self closeSearch];
    }
};
-(void)closeSearch{
    blurView.hidden = YES;
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;};
//----------------------------------------
#pragma mark Sets Menu Delegate
////////////// Sets Menu Delegate methods
-(void)SetOrder{
    blurView.hidden = NO;
    newChordDialog = [OrderSetsDialog orderSetsDialog:self];
    
    //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneIn:newChordDialog];
};



-(void)SetSearch{
    blurView.hidden = NO;
    newChordDialog = [SearchSetDialog setSearchDialog:self];
    
    //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneIn:newChordDialog];
};

-(void)SetNew{
    blurView.hidden = NO;
    newChordDialog = [NewSetDialog newSetDialog:self];
    //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    
    [self animateModalPaneIn:newChordDialog];
};


//---------------------------------------

#pragma mark New Set Delegate
////////////// New Set Delegate methods

-(void)setCancel{
    blurView.hidden = YES;
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
};

//---------------------------------------


#pragma mark Order Set Delegate
////////////// Order Set Delegate methods
-(void)orderSetsDone{
    blurView.hidden = YES;
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
}

-(void)closeSetSearch{
    blurView.hidden = YES;
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
}

-(void)initBlur{
    blurView.blurRadius = 8.913934f;
}

-(void)showLoginScreen{
    blurView.hidden = NO;
    newChordDialog = nil;
    newChordDialog = [LoginScreenView loginScreen:self];
    
//    [self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneIn:newChordDialog];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 1)
    {
        NSDictionary *chart = [db getChartById:[self.currentUser chartId]];
        
        [db removeChartWithId:[self.currentUser chartId]];
        //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
        [self animateModalPaneOut:newChordDialog];
        
        newChordDialog = nil;
        blurView.hidden = YES;
        if ([self.currentUser getUsedMode] == MODE_FB)
        {
            if ([chart[@"owner"] isEqualToString:[self.currentUser getIdForUser]]) {
                [self.serverUpdater removeChart:chart[@"chordId"]];
            } else {
                [self.serverUpdater removeChartForMe:chart[@"chordId"]];
            }
        }
        
        [blurView updateAsynchronously:YES completion:nil];
        
        [self loadNormalChords];
        [self.serverUpdater removeChart:[self.currentUser chartId]];
    }
    else if (alertView.tag == 2 && buttonIndex == 1)
    {
        NSDictionary *set = [db getSetWithId:[self.currentUser setId]];
        
        [db removeSetWithId:[self.currentUser setId]];
        //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseInOut];
        [self animateModalPaneOut:newChordDialog];
        
        newChordDialog = nil;
        blurView.hidden = YES;
        if ([self.currentUser getUsedMode] == MODE_FB)
        {
            if ([set[@"owner"] isEqualToString:[self.currentUser getIdForUser]]) {
                [self.serverUpdater removeSet:[self.currentUser setId]];
            } else {
                [self.serverUpdater removeSetForMe:[self.currentUser setId]];
            }
        }
        
        [blurView updateAsynchronously:YES completion:nil];
        
        [self loadNormalSets];
        [self.serverUpdater removeSet:[self.currentUser setId]];
        
    }
    else
    {
        [self.serverUpdater continueCheck];
    }
}

-(void)backToLogin{
    [self hideOnlyCover];
    [self showLoginScreen];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentChordPage = 0;
    currentSetPage = 0;
    copyingIndex = -1;
    self.isSetSharing = false;
    isSetSearch = false;
    isChordsSearch = false;
    [self initBlur];
    setting = [CoreSettings sharedManager];
    [setting loadSetting];
    self.serverUpdater = [ServerUpdater sharedManager];
    [self.serverUpdater pauseCheck];
    setHelper = [[JsonSetHelper alloc] init];
    chordHelper = [[JsonChordHelper alloc] init];
    self.currentUser = [User sharedManager];
    AppDelegate *appdel=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.currentUser setDeviceToken:[appdel deviceToken]];
    [self.currentUser setOrderKeyForChart:@"order_number"];
    [self.currentUser setOrderKeyForSets:@"order_number"];
    db = [DBManager sharedManager];
    self.chordsStorage = [[NSMutableArray alloc] init];
    self.setsStorage = [[NSMutableArray alloc] init];
    self.allChords = [[NSMutableArray alloc] init];
    self.allSets = [[NSMutableArray alloc] init];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height-8;
    setsMenuContainer.frame = CGRectMake(0, ((screenHeight/10)*5)+8, (screenWidth/8)*5, screenHeight/10);
    setsMenuContainer.backgroundColor = [UIColor whiteColor];
    chartsMenu = [ChordsMenu chartMenu:self];
    [chartsMenu setFrame:CGRectMake(0, 0, (screenWidth/8)*5, screenHeight/10)];
    [chartsMenuContainer addSubview:chartsMenu];
    chartsMenuContainer.frame = CGRectMake(0, 0, (screenWidth/8)*5, screenHeight/10);
    chartsMenuContainer.backgroundColor = [UIColor whiteColor];
    setsMenu = [SetsMenu setsMenu:self];
    [setsMenuContainer addSubview:setsMenu];
    chordsArray = [NSMutableArray arrayWithArray:[self fiveOfA]];
    setsArray = [NSMutableArray arrayWithArray:[self fiveOfA]];
    idForChords = [NSMutableArray arrayWithArray:[self fiveOfA]];
    idForSets = [NSMutableArray arrayWithArray:[self fiveOfA]];
    
     self.dragAndDropManager = [[AtkDragAndDropManager alloc] init];
    [blurView updateAsynchronously:YES completion:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"updateParent" object:nil];
    [self.setsPager.panGestureRecognizer setMinimumNumberOfTouches:2];
    [self.chordsPager.panGestureRecognizer setMinimumNumberOfTouches:2];
    
    //blurView.underlyingView
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnBlurView)];
    tapGest.numberOfTapsRequired = 1;
    
    [blurView.underlyingView addGestureRecognizer:tapGest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkForSharedItems:)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
    
    [self showLoginScreen];
}

- (void)handleTapOnBlurView
{
    if (![newChordDialog isKindOfClass:[LoginScreenView class]] &&
        ![newChordDialog isKindOfClass:[NewChordDialog class]] &&
        ![newChordDialog isKindOfClass:[NewSetDialog class]]) {
        blurView.hidden = YES;
        [self animateModalPaneOut:newChordDialog];
        newChordDialog = nil;
    }
}

-(void)checkShare{
    if (![@"" isEqualToString:[self.currentUser mySecretKey]] && [self.currentUser mySecretKey] != nil){
        //[self.serverUpdater getSharedData];
        
        [self.serverUpdater getSharedItemsCount:^(int result) {
            NSLog(@"Count of Shared Items: %d",result);
        }];
    }
}

-(void)startLoad{
    
    self.currentUser.selectedSet = 0;
    self.currentUser.selectedChord = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height-8;          
    double f= (((NUMBER_ITEMS_ON_LOAD+5)/8.0f));
    if((f - (int)f) > 0.5f){
        f++;
        f = (int)f;
    } else {
        f = (int)f;
    }
    [self loadMainJson];
    
    gridContainer.frame = CGRectMake(0, 0, screenWidth*countOfPages,(int)(screenHeight/2)-4);
    NSArray *arr = [gridContainer subviews];
    for (UIView *v in arr) {
        [v removeFromSuperview];
    }
    for (int i = 0; i < countOfPages; i++) {
        redTiles = [[ChordsGrid alloc] initWithData:[self.allChords objectAtIndex:i][@"data"] andIds:[self.allChords objectAtIndex:i][@"id"] withFrame:CGRectMake(screenWidth*i, 0, screenWidth,(int)(screenHeight/2)-4) andContainer:gridContainer owner:self];
        redTiles.delegate = self;
        [self.chordsStorage addObject:redTiles];
    }
    NSArray* setsForRemove = [setsContaine subviews];
    for (UIView *v in setsForRemove) {
        [v removeFromSuperview];
    }
    [setsContaine setFrame:CGRectMake(0, 0, screenWidth*countOfSetsPages,(int)(screenHeight/2))];
    for (int i = 0; i < countOfSetsPages; i++) {
        setsGrid = [[SetsGrid alloc] initWithData:[self.allSets objectAtIndex:i][@"data"] andIds:[self.allSets objectAtIndex:i][@"id"] withFrame:CGRectMake((screenWidth*i), 0, screenWidth,(int)(screenHeight/2)+8) andContainer:setsContaine];
        setsGrid.delegate = self;
        [self.setsStorage addObject:setsGrid];
    }
    self.chordsPager.frame = CGRectMake(0, 0, screenWidth,(int)(screenHeight/2));
    self.setsPager.frame = CGRectMake(0, (int)(screenHeight/2)+8, screenWidth, screenHeight/2);
    self.chordsPager.pagingEnabled = YES;
    self.setsPager.pagingEnabled = YES;
    [blurView updateAsynchronously:YES completion:nil];
    [self.chordsPager setContentSize:CGSizeMake(screenWidth*countOfPages, (screenHeight/2)-8)];
    [self.setsPager setContentSize:CGSizeMake(screenWidth*countOfSetsPages, (screenHeight/2)-8)];
    
}

-(void)loadMainJson {
    [self.allChords removeAllObjects];
    [self.allSets removeAllObjects];
    self.allChords = [db getMyChartsWithOrder:[self.currentUser orderKeyForChart]];
    self.allSets = [db getMySetsWithOrder:[self.currentUser orderKeyForSets]];
    countOfSetsPages = ceilf(([db countOfSets])/34.0f);
    if (countOfSetsPages == 0.0f) {
        countOfSetsPages = 1.0f;
    }
    countOfPages = ceilf(([db countOfCharts] )/35.0f);
    if (countOfPages == 0.0f) {
        countOfPages = 1.0f;
    }
    [blurView updateAsynchronously:YES completion:nil];
}


-(NSArray*)fiveOfA {
    return @[@"A",@"A",@"A",@"A",@"A"];
}

- (IBAction)showSettings:(id)sender {
    blurView.hidden = NO;
    newChordDialog = [SettingsDialog settingsDialog:self];
    [(SettingsDialog*)newChordDialog setNumberOfSharedItems:self.settingsButton.badgeView.badgeValue];
    [(SettingsDialog*)newChordDialog initSettings];
    
    [self animateModalPaneIn:newChordDialog];
}

-(void)closeSettings{
    blurView.hidden = YES;
    //[newChordDialog removeWithZoomOutAnimation:0.1 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneOut:newChordDialog];
    
    newChordDialog = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dragAndDropManager start];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.dragAndDropManager stop];
    [self.serverUpdater pauseCheck];
    [super viewWillDisappear:animated];
   
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



- (IBAction)chordDone:(id)sender {
  //  [self.delegate doneNewChord];
}



- (void)didTapLabelWithGesture:(UITapGestureRecognizer*)label{
    CustomButton *clickedChart = (CustomButton*)label;
    [self.currentUser setChartId:[clickedChart getUniqueID]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LyricsTextEditorViewController *viewController = (LyricsTextEditorViewController *)[storyboard instantiateViewControllerWithIdentifier:@"editor"];
    
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:viewController animated:YES completion:NULL];
    
}

- (void)showInfo:(UITapGestureRecognizer*)label{
    blurView.hidden = NO;
    [self.currentUser setChartId:[(CustomButton*)label getUniqueID]];
    newChordDialog = [ChartInfo chartInfo:self];
    NSDictionary* dc = [db getChartById:[self.currentUser chartId]];
    [(ChartInfo*)newChordDialog showInfo:dc[@"cTitle"] author:dc[@"artist"] key:dc[@"key"] time:dc[@"time_sig"] bpm:dc[@"bpm"] genre:dc[@"genre"]];
   
    //[self.view addSubviewWithZoomInAnimation:newChordDialog duration:0.2 option:UIViewAnimationOptionCurveEaseIn];
    [self animateModalPaneIn:newChordDialog];
}

-(void)checkUpdatedData{
   // [self.serverUpdater getUpdatedData];
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self->internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self->internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self->internetActive = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self->hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self->hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self->hostActive = YES;
            
            break;
        }
    }
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"updateParent"]){
        [self loadNormalChords];
        [self.serverUpdater continueCheck];
    }
}



-(void) viewWillAppear:(BOOL)animated
{
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.facebook.com"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
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

- (void)animateViewControllerFlip:(UIViewController *)controller
{
    
}

@end



