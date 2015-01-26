//
//  OrderSetsDialog.m
//  app12bar
//
//  Created by Alex on 7/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "OrderSetsDialog.h"

@implementation OrderSetsDialog

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)orderDone:(id)sender {
    [self.delegate orderSetsDone];
}
-(void)orderSetsDone{};
+ (id) orderSetsDialog:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"OrderSetsDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    OrderSetsDialog *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    return me;
}

- (IBAction)orderSetByTitle:(id)sender {
    [self.delegate orderSetByTitle];
}
- (IBAction)orderByArtist:(id)sender {
    [self.delegate orderSetByAuthor];
}
- (IBAction)orderByDate:(id)sender {
    [self.delegate orderSetByDate];
}
- (IBAction)orderByLocation:(id)sender {
    [self.delegate orderSetByLocation];
}

@end
