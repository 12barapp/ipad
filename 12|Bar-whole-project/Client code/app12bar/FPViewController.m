//
//  FPViewController.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/20/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "FPViewController.h"

@interface FPViewController ()
@property (nonatomic) id<UITableViewDataSource> FBdelegate;
@property (nonatomic, retain) IBOutlet UITableView *tableView2;
@end

@implementation FPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.FBdelegate = self.tableView.dataSource;
    self.tableView.dataSource = self;
    [self loadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.FBdelegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.FBdelegate tableView:tableView numberOfRowsInSection:section];
}


/*!
 @abstract
 Tells the delegate that data has been loaded.
 
 @discussion
 The <FBFriendPickerViewController> object's `tableView` property is automatically
 reloaded when this happens. However, if another table view, for example the
 `UISearchBar` is showing data, then it may also need to be reloaded.
 
 @param friendPicker        The friend picker view controller whose data changed.
 */
- (void)friendPickerViewControllerDataDidChange:(FBFriendPickerViewController *)friendPicker{
    
}

/*!
 @abstract
 Tells the delegate that the selection has changed.
 
 @param friendPicker        The friend picker view controller whose selection changed.
 */
- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker{
    
}

/*!
 @abstract
 Asks the delegate whether to include a friend in the list.
 
 @discussion
 This can be used to implement a search bar that filters the friend list.
 
 If -[<FBGraphObjectPickerDelegate> graphObjectPickerViewController:shouldIncludeGraphObject:]
 is implemented and returns NO, this method is not called.
 
 @param friendPicker        The friend picker view controller that is requesting this information.
 @param user                An <FBGraphUser> object representing the friend.
 */
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user{
    return YES;
}

/*!
 @abstract
 Tells the delegate that there is a communication error.
 
 @param friendPicker        The friend picker view controller that encountered the error.
 @param error               An error object containing details of the error.
 */
- (void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                       handleError:(NSError *)error{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
