//
//  NewSetDialog.h
//  app12bar
//
//  Created by Alex on 7/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"

@class NewSetDialog;
@protocol NewSetDialogDelegate

-(void)doneNewSet:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location;
-(void)updateExistingSet:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location;
-(void)setCancel;
@end

@interface NewSetDialog : UIView<UIPopoverControllerDelegate, UITextFieldDelegate, DatePickerViewDelegate>{
    bool isEditing;
}
@property(assign)id<NewSetDialogDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (strong, nonatomic) IBOutlet UITextField *setTitle;
@property (strong, nonatomic) IBOutlet UITextField *setArtist;
@property (strong, nonatomic) IBOutlet UITextField *setDate;
@property (strong, nonatomic) IBOutlet UITextField *setLocation;
@property (strong, nonatomic)          UIPopoverController *popuperView;
@property (strong, nonatomic) IBOutlet UIButton *datePickerBtn;

+(id)newSetDialog:(id)pickDelegate;
-(void)setDataForEDiting:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location;
@end
