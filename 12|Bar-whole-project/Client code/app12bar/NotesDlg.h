//
//  NotesDlg.h
//  app12bar
//
//  Created by Alex on 7/28/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotesDlg;
@protocol NotesDelegate
-(void)saveNotes:(NSString*)notes;
-(void)setTextChanged;
@end

@interface NotesDlg : UIView<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (nonatomic, assign)          id<NotesDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextView *notesText;
@property (strong, nonatomic) IBOutlet UIImageView *noteIcon;
@property (strong, nonatomic) IBOutlet UIButton *noteIcoBtn;

+ (id) notesDialog:(id)pickDelegate;
-(void)showNotes:(NSString*)notes;
@end
