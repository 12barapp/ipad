//
//  PerformSetController.h
//  app12bar
//
//  Created by Alex on 7/25/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "FXBlurView.h"
#import "NotesSetView.h"
#import "UIView+Animation.h"
#import "NewChordDialog.h"
#import "ChartInfo.h"
#import "DBManager.h"
#import "Utils&Helpers/JsonChordHelper.h"
#import "Utils&Helpers/JsonSetHelper.h"
#import "Classes/ServerUpdater.h"
#import "Utils&Helpers/JsonChordHelper.h"
#import "HomeViewController.h"
#import "LyricsTextEditorViewController.h"
#import "CustomButton.h"
#import "JsonSetHelper.h"


@class PerformSetController;
@protocol PerformSetControllerDelegate

-(void)redrawChords;
-(void)showChartInfo:(UITableViewCell *)cell;
-(void)launchChordChart:(UITableViewCell *)cell;
-(void)showAddNewChart:(UITableViewCell *)cell;

@end

@interface PerformSetController : UIViewController<NotesSetDelegate,UITableViewDataSource,UITableViewDelegate, NewChordDialogDelegate, PerformSetControllerDelegate, ChartInfoDelegate>{
    UIView *newChordDialog;
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSIndexPath *indexPath;
    NSMutableArray *chordsId;

    
}
@property (assign)                     BOOL isPerform;
@property (assign)                    id <PerformSetControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *smallSetTitle;
@property (strong, nonatomic) IBOutlet UILabel *setAuthor;
@property (strong, nonatomic) IBOutlet UILabel *setDate;
@property (strong, nonatomic) IBOutlet UILabel *setLocation;
@property (strong, nonatomic) IBOutlet UILabel *mainSetTitle;
@property (strong, nonatomic) IBOutlet UIButton *notesBtnView;



@property (strong, nonatomic)          ServerUpdater *serverUpdater;
@property (strong, nonatomic)          User* currentUser;
@property (strong, nonatomic) IBOutlet UITableView *chordsTable;
@property (strong, nonatomic) IBOutlet UIView*head;
@property (strong, nonatomic)          NSMutableArray *dataArray;

-(void)setToPerformMode;

@end
