//
//  SearchSetDialog.m
//  app12bar
//
//  Created by Alex on 7/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "SearchSetDialog.h"

@implementation SearchSetDialog

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (id) setSearchDialog:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"SearchSetDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    SearchSetDialog *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    [me.searchField becomeFirstResponder];
    return me;
    
}
- (IBAction)searchByLocation:(id)sender {
    [self.delegate searchSetByLocation:self.searchField.text];
}


- (IBAction)searchByTitle:(id)sender {
    [self.delegate searchSetByTitle:self.searchField.text];
}

- (IBAction)searchByAuthor:(id)sender {
    [self.delegate searchSetByAuthor:self.searchField.text];
}

- (IBAction)searchByDate:(id)sender {
    [self.delegate searchSetByDate:self.searchField.text];
}



- (IBAction)done:(id)sender {
    [self.delegate closeSetSearch];
}

@end
