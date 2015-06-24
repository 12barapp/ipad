//
//  SharedNotifierViewController.h
//  app12bar
//
//  Created by Vasiliy Alifanov on 9/2/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ServerUpdater.h"
#import "DBManager.h"
#import "Utils&Helpers/ColorHelper.h"

@class SharedNotifierViewController;
@protocol SharedNotifierDelegate

-(void)updatedDataAfterSharing;

@end


@interface SharedNotifierViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *sharedDataTable;
@property (strong, nonatomic)          NSMutableArray *sharedCharts;
@property (strong, nonatomic)          NSMutableArray *sharedSets;
@property (assign, nonatomic)          CGFloat screenWidth;
@property (assign, nonatomic)          CGFloat screenHeight;
@property (strong, nonatomic) IBOutlet UIView* colorView;
@property (strong, nonatomic) IBOutlet UILabel* bigTitle;
@property (strong, nonatomic) IBOutlet UILabel* smallTitle;
@property (strong, nonatomic) IBOutlet UILabel* smallAuthor;
@property (strong, nonatomic) IBOutlet UILabel* smallBpm;
@property (strong, nonatomic) IBOutlet UILabel* smallGenre;
@property (strong, nonatomic) IBOutlet UILabel* chordOtherInfo;
@property (strong, nonatomic) IBOutlet UIButton* dismissBtn;
@property (strong, nonatomic) IBOutlet UIButton* acceptBtn;
@property (strong, nonatomic)          NSString* sharedFromId;
@property (assign)                     int selectedRow;
@property (strong, nonatomic)          User* currentUser;
@property (assign)                     id<SharedNotifierDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

-(void)updateForData:(NSDictionary*)data andShared:(NSString*)sh;
-(void)showSharedCharts:(NSMutableArray*)charts andSets:(NSMutableArray*)sets;

@end
