//
//  NotesSetView.h
//  app12bar
//
//  Created by Alex on 8/9/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotesSetView;
@protocol NotesSetDelegate
-(void)saveNotes:(NSString*)notes;
@end
@interface NotesSetView : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (strong, nonatomic) IBOutlet UITextView *notesText;
@property (strong, nonatomic) IBOutlet UIImageView *noteIcon;
@property (strong, nonatomic) IBOutlet UIButton *notesIcoBtn;


@property (strong, nonatomic)          id<NotesSetDelegate> delegate;
+ (id) notesDialog:(id)pickDelegate;
-(void)showNotes:(NSString*)notes;

@end
