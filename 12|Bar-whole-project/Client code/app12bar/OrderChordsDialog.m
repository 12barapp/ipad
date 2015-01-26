//
//  OrderChordsDialog.m
//  app12bar
//
//  Created by Alex on 7/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "OrderChordsDialog.h"

@implementation OrderChordsDialog

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id) orderDialog:(id)pickDelegate{
    
    UINib *nib = [UINib nibWithNibName:@"OrderChordsDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    OrderChordsDialog *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
//    [me.se becomeFirstResponder];
    return me;
}

-(void)orderByTitle{}
-(void)orderByBpm{}
-(void)orderByAuthor{}
-(void)orderByKey{}
-(void)orderByGenre{}
-(void)orderByTime{}
-(void)closeOrder{}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)titleOrder:(id)sender {
    [self.delegate orderByTitle];
}

- (IBAction)authorOrder:(id)sender {
    [self.delegate orderByAuthor];
}

- (IBAction)keyOrder:(id)sender {
    [self.delegate orderByKey];
}

- (IBAction)timeOrder:(id)sender {
    [self.delegate orderByTime];
}

- (IBAction)bpmOrder:(id)sender {
    [self.delegate orderByBpm];
}

- (IBAction)genreOrder:(id)sender {
    [self.delegate orderByGenre];
}

- (IBAction)orderDone:(id)sender {
    [self.delegate closeOrder];
}
@end
