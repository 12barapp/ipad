//
//  SearchChordDialog.h
//  app12bar
//
//  Created by Alex on 7/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchChordDialog;
@protocol SearchChordDialogDelegate

-(void)searchByAuthor:(NSString*)searchText;
-(void)searchByTitle:(NSString*)searchText;
-(void)searchByKey:(NSString*)searchText;
-(void)searchByLyrics:(NSString*)searchText;
-(void)searchByTime:(NSString*)searchText;
-(void)searchByBpm:(NSString*)searchText;
-(void)searchByGenre:(NSString*)searchText;

-(void)closeSearch;


@end
@interface SearchChordDialog : UIView

@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (assign) id<SearchChordDialogDelegate> delegate;
- (IBAction)done:(id)sender;
+ (id) chordSearchDialog:(id)pickDelegate;
@end
