//
//  OrderSetsDialog.h
//  app12bar
//
//  Created by Alex on 7/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderChordsDialog;
@protocol OrderSetsDialogDelegate

-(void)orderSetByTitle;
-(void)orderSetByAuthor;
-(void)orderSetByDate;
-(void)orderSetByLocation;

-(void)orderSetsDone;

@end
@interface OrderSetsDialog : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (assign)                     id<OrderSetsDialogDelegate> delegate;

+ (id) orderSetsDialog:(id)pickDelegate;
@end
