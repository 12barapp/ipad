//
//  ViewController.h
//  app12bar
//
//  Created by Alex on 7/2/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "FXBlurView.h"
#import "NewChordDialog.h"
#import "NewSetDialog.h"
#import "ChartInfo.h"
#import "UIView+Animation.h"
#import "ChordsMenu.h"
#import "OrderChordsDialog.h"
#import "OrderSetsDialog.h"
#import "SearchChordDialog.h"
#import "SearchSetDialog.h"
#import "SettingsDialog.h"
#import "DBManager.h"
#import "ChordsGrid.h"
#import "SetsGrid.h"
#import "SetsMenu.h"
#import "User.h"
#import "SetInfo.h"
#import "FriendMail.h"
#import "About.h"
#import "ServerUpdater.h"
#import "LoginScreenView.h"
#import "FriendPickerView.h"
#import "PerformSetController.h"
#import "AtkDragAndDropManager.h"
#import "DGZone.h"
#import "DGChord.h"
#import "Classes/CoreSettings.h"
#import "EmailTyper.h"
#import "JsonChordHelper.h"
#import "JsonSetHelper.h"
#import <Crashlytics/Crashlytics.h>
#import "FacebookFriendsPickerController.h"
#import "FriendEmailTyper.h"
#import "SharedNotifierViewController.h"
#import "TransposeChordHelper.h"
#import "FPViewController.h"
#import <MessageUI/MessageUI.h>
#import "VFMailViewController.h"
#import "CustomButton.h"
#import "CustomLabel.h"
#import "Reachability.h"
#import "DGChord.h"


@interface HomeViewController : UIViewController<UIScrollViewDelegate,MFMailComposeViewControllerDelegate,FBViewControllerDelegate,FBFriendPickerDelegate,NewChordDialogDelegate, ChartInfoDelegate, ChordsMenuDelegate, OrderChordsDialogDelegate, SearchChordDialogDelegate, FBFriendPickerDelegate, ChordsGridDelegate, SetsMenuDelegate, NewSetDialogDelegate, OrderSetsDialogDelegate, SearchSetDialogDelegate, LoginScreenDelegate,DGZoneDelegate, FBLoginViewDelegate, UIAlertViewDelegate, ServerUpdaterDelegate, SharedNotifierDelegate, SetsGridDelegate>{
    UIView *newChordDialog;
    UIView *newSetDialog;
    
    IBOutlet UIView *setsMenuContainer;
    IBOutlet UIView *chartsMenuContainer;
    ChordsGrid *redTiles;
    SetsGrid *setsGrid;
    ChordsGrid *onenewChords;
    BOOL draggingChordDragging;
}
@property (retain, nonatomic)          JsonSetHelper *setHelper;
@property (retain, nonatomic)          JsonChordHelper *chordHelper;
@property (retain, nonatomic)          FBFriendPickerViewController* friendPickerController;

@property (strong, nonatomic)          NSString* allJson;
@property (nonatomic, retain)          ChordsGrid* redTiles;
@property (nonatomic, retain)          ChordsGrid *onenewChords;
@property (nonatomic, retain)          SetsGrid* setsGrid;
@property (nonatomic, retain)          UIActivityIndicatorView* spinner;
@property (nonatomic, retain)          NSMutableArray *chordsStorage;
@property (nonatomic, retain)          NSMutableArray *setsStorage;
@property (strong, nonatomic)          NSMutableArray *allSets;
@property (strong, nonatomic)          NSMutableArray *allChords;
@property (strong, nonatomic)          NSMutableArray *foundChords;
@property (strong, nonatomic)          NSMutableArray* foundSets;
@property (nonatomic, retain)          TransposeChordHelper* transposer;
@property (nonatomic, assign)          int chordPositionForSearch;
@property (nonatomic, assign)          int setPositionForSearch;
@property (nonatomic, assign)          int currentChordPage;
@property (nonatomic, assign)          int currentSetPage;
@property (nonatomic, assign)          int copyingIndex;
@property (nonatomic, assign)          float countOfPages;
@property (nonatomic, assign)          float countOfSetsPages;
@property (strong, nonatomic) IBOutlet UIScrollView *chordsPager;
@property (strong, nonatomic) IBOutlet UIScrollView *setsPager;
@property (strong, nonatomic)          FBLoginView *fbLoginView;
@property (nonatomic, strong)          AtkDragAndDropManager *dragAndDropManager;
@property (nonatomic, retain)          User* currentUser;
@property (nonatomic, retain)          ServerUpdater* serverUpdater;
@property (nonatomic, assign)          BOOL isChordsSearch;
@property (nonatomic, assign)          BOOL isSetSearch;
@property (nonatomic, assign)          BOOL isSetSharing;
@property (nonatomic, strong)          UIView *coverView;


-(void)redrawChords;

@end
