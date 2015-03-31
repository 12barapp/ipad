//
//  CustomTableCell.h
//  app12bar
//
//  Created by Vasiliy Alifanov on 12/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "PerformSetController.h"

@interface CustomTableCell : UITableViewCell {
    NSString *uniqueID;
}

-(void)setUniqueId:(NSString*)uid;
-(NSString*)getUniqueId;

@property NSString *smallTitle;
@property NSString *author;
@property NSString *otherInfo;
@property NSString *genre;

@property BOOL isPerform;
@property (strong, nonatomic) UIViewController *parentVC;

@property(assign)id<PerformSetControllerDelegate> delegate;

- (IBAction)titleTappedForPerform:(id)sender;


@end
