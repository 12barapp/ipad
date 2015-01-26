//
//  NewChordDialog.h
//  app12bar
//
//  Created by Alex on 7/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SignaturePickerViewController.h"

@class NewChordDialog;
@protocol NewChordDialogDelegate

-(void)closeInfo;
-(void)updateExistingChordWith:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes transposeIndex:(int)tIndex;
-(void)doneNewChord:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes;
@end

@interface NewChordDialog : UIView<UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverControllerDelegate, SignaturePickerDelegate, UITextFieldDelegate>{
    bool isEditing;
    int selectedField;
}
@property (assign) id<NewChordDialogDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (strong, nonatomic) IBOutlet UITextField *titleText;
@property (strong, nonatomic) IBOutlet UITextField *artistText;
@property (strong, nonatomic) IBOutlet UIButton *timePick;
@property (strong, nonatomic) IBOutlet UIButton *keyPick;
@property (strong, nonatomic) IBOutlet UIButton *genrePick;
@property (strong, nonatomic) IBOutlet UIButton *bpmPick;
@property (nonatomic, retain)          NSString* prevChord;
@property (strong, nonatomic) IBOutlet UIPickerView *timeSigPicker;
@property (strong, nonatomic)          UIPopoverController *popuperView;


- (IBAction)chordDone:(id)sender;
+ (id) newChordDialog:(id)pickDelegate;
-(void)setDataForEDiting:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes;
@end


