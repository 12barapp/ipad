//
//  AddChartTableViewCell.h
//  app12bar
//
//  Created by Noah Labhart on 3/27/15.
//  Copyright (c) 2015 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformSetController.h"

@interface AddChartTableViewCell : UITableViewCell <PerformSetControllerDelegate>

- (IBAction)showAddNewChart:(id)sender;

@property id <PerformSetControllerDelegate> delegate;

@end
