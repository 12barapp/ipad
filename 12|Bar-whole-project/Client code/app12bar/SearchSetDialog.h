//
//  SearchSetDialog.h
//  app12bar
//
//  Created by Alex on 7/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchSetDialog;
@protocol SearchSetDialogDelegate

-(void)searchSetByAuthor:(NSString*)searchText;
-(void)searchSetByTitle:(NSString*)searchText;
-(void)searchSetByDate:(NSString*)searchText;
-(void)searchSetByLocation:(NSString*)searchText;


-(void)closeSetSearch;


@end
@interface SearchSetDialog : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

@property (assign) id<SearchSetDialogDelegate> delegate;
- (IBAction)done:(id)sender;
+ (id) setSearchDialog:(id)pickDelegate;
@end
