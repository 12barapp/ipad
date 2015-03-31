//
//  AddChartTableViewCell.m
//  app12bar
//
//  Created by Noah Labhart on 3/27/15.
//  Copyright (c) 2015 Vasilkoff LTD. All rights reserved.
//

#import "AddChartTableViewCell.h"

@implementation AddChartTableViewCell

- (IBAction)showAddNewChart:(id)sender {
    [self.delegate showAddNewChart:self];
}
@end
