//
//  OrderChordsDialog.h
//  app12bar
//
//  Created by Alex on 7/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderChordsDialog;
@protocol OrderChordsDialogDelegate

-(void)orderByTitle;
-(void)orderByBpm;
-(void)orderByAuthor;
-(void)orderByKey;
-(void)orderByGenre;
-(void)orderByTime;
-(void)closeOrder;

@end
@interface OrderChordsDialog : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (assign) id<OrderChordsDialogDelegate> delegate;
- (IBAction)titleOrder:(id)sender;
- (IBAction)authorOrder:(id)sender;
- (IBAction)keyOrder:(id)sender;
- (IBAction)timeOrder:(id)sender;
- (IBAction)bpmOrder:(id)sender;
- (IBAction)genreOrder:(id)sender;
- (IBAction)orderDone:(id)sender;

+ (id) orderDialog:(id)pickDelegate;
@end
