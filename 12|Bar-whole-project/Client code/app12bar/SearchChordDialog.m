//
//  SearchChordDialog.m
//  app12bar
//
//  Created by Alex on 7/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "SearchChordDialog.h"

@implementation SearchChordDialog

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)searchByAuthor{};
-(void)searchByTitle{};
-(void)searchByKey{};
-(void)searchByLyrics{};
-(void)searchByTime{};
-(void)searchByBpm{};
-(void)searchByGenre{};

-(void)closeSearch{};

+ (id) chordSearchDialog:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"SearchChordDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    SearchChordDialog *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    [me.searchField becomeFirstResponder];
    me.delegate = pickDelegate;
    return me;

}

- (IBAction)done:(id)sender {
    [self.delegate closeSearch];
}
- (IBAction)searchTitle:(id)sender {
    [self.delegate searchByTitle:self.searchField.text];
}
- (IBAction)searchAuthor:(id)sender {
    [self.delegate searchByAuthor:self.searchField.text];
}
- (IBAction)searchKey:(id)sender {
    [self.delegate searchByKey:self.searchField.text];
}
- (IBAction)searchTime:(id)sender {
    [self.delegate searchByTime:self.searchField.text];
}
- (IBAction)searchBpm:(id)sender {
    [self.delegate searchByBpm:self.searchField.text];
}
- (IBAction)searchGenre:(id)sender {
    [self.delegate searchByGenre:self.searchField.text];
}
- (IBAction)searchLyrics:(id)sender {
    [self.delegate searchByLyrics:self.searchField.text];
}


@end
