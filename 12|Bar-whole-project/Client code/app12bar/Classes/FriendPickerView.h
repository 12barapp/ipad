//
//  FriendPickerView.h
//  app12bar
//
//  Created by Alex on 7/24/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendPickerView;
@protocol FriendPickerDelegate

-(void)cancel;
-(void)shareWithFriends;

@end
@interface FriendPickerView : UIView<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *arOptions;
}

@property (strong, nonatomic) IBOutlet UIView *header;


@property (assign) id<FriendPickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *friendsTable;
@property (nonatomic, strong)          NSMutableArray *arOptions;
+ (id) friendPicker:(id)pickDelegate;
@end
