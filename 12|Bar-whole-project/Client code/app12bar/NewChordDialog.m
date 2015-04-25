//
//  NewChordDialog.m
//  app12bar
//
//  Created by Alex on 7/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "NewChordDialog.h"


@implementation NewChordDialog
@synthesize delegate = _delegate, titleText, artistText;

- (void)baseInit {
    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
        self.titleText.delegate = self;
        self.artistText.delegate = self;
        
        UITextField *lagFreeField = [[UITextField alloc] init];
        [self.window addSubview:lagFreeField];
        [lagFreeField becomeFirstResponder];
        [lagFreeField resignFirstResponder];
        [lagFreeField removeFromSuperview];
    }
    return self;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 0;
}

-(void)doneNewChord:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes{
    
}

- (IBAction)chordDone:(id)sender {
  
    if (isEditing == false){
        if([self validateData])
        [self.delegate doneNewChord:self.titleText.text artist:self.artistText.text key:self.keyPick.titleLabel.text time_sig:self.timePick.titleLabel.text genre:self.genrePick.titleLabel.text bpm:self.bpmPick.titleLabel.text notes:@""];
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill required data." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    } else {
        NSArray* allChords = [[NSArray alloc] initWithObjects:@"C",
                              @"C#",
                              @"D",
                              @"Eb",
                              @"E",
                              @"F",
                              @"F#",
                              @"G",
                              @"Ab",
                              @"A",
                              @"Bb",
                              @"B", nil];
        int prevChordIndex = -1;
        int currentChordIndex = -1;
        int transposeIndex = 0;
        
        if (![self.prevChord isEqualToString:self.keyPick.titleLabel.text]) {
            transposeIndex = 1;
        }
        
        for (int i = 0; i < allChords.count; i++) {
            if ([self.prevChord isEqualToString:[allChords objectAtIndex:i]]) {
                prevChordIndex = i;
            }
            if ([self.keyPick.titleLabel.text isEqualToString:[allChords objectAtIndex:i]]) {
                currentChordIndex = i;
            }
        }
        if (currentChordIndex > prevChordIndex) {
            transposeIndex = currentChordIndex - prevChordIndex;
        }else if (currentChordIndex < prevChordIndex){
            transposeIndex = -1*(prevChordIndex - currentChordIndex);
        } else {
            transposeIndex = 0;
        }
        transposeIndex *= -1;
        [self.delegate updateExistingChordWith:self.titleText.text artist:self.artistText.text  key:self.keyPick.titleLabel.text time_sig:self.timePick.titleLabel.text genre:self.genrePick.titleLabel.text bpm:self.bpmPick.titleLabel.text notes:@"" transposeIndex:transposeIndex];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.titleText) {
        [self.artistText becomeFirstResponder];
    } else if(textField == self.artistText) {
        [self.artistText resignFirstResponder];
        //[self showKeyPicker:self.timePick];
        //[self chordDone:nil];
    }
    return YES;
}

- (BOOL)validateData {
    bool ch = false;
    if ((self.titleText.text.length > 0) && self.titleText.text != nil && [self.titleText.text isEqual:@""] == FALSE){
        ch = true;
    } else {
        ch = false;
        return ch;
    }
    
    if ((self.artistText.text.length > 0) && self.artistText.text != nil && [self.artistText.text isEqual:@""] == FALSE){
        ch = true;
    } else {
        return false;
    }
    if (self.keyPick.titleLabel.text.length > 0 && self.keyPick.titleLabel.text != nil && [self.keyPick.titleLabel.text isEqual:@""] == FALSE) {
        ch = true;
    } else {
        return false;
    }
    
    if (self.timePick.titleLabel.text.length > 0 && self.timePick.titleLabel.text != nil && [self.timePick.titleLabel.text isEqual:@""] == FALSE) {
        ch = true;
    } else {
        return false;
    }
    if (self.genrePick.titleLabel.text.length > 0 && self.genrePick.titleLabel.text != nil && [self.genrePick.titleLabel.text isEqual:@""] == FALSE) {
        ch = true;
    } else {
        return false;
    }
    if (self.bpmPick.titleLabel.text.length > 0 && self.bpmPick.titleLabel.text != nil && [self.bpmPick.titleLabel.text isEqual:@""] == FALSE) {
        ch = true;
    } else {
        return false;
    }
    
    
    
   /* if ([self.setDate.text length] > 0 || self.setDate.text != nil || [self.setDate.text isEqual:@""] == FALSE){
        return false;
    }if ([self.setLocation.text length] > 0 || self.setLocation.text != nil || [self.setLocation.text isEqual:@""] == FALSE){
        return false;
    }*/
    return ch;
}

-(void)setDataForEDiting:(NSString*)title
                  artist:(NSString*)artist
                     key:(NSString*)key
                time_sig:(NSString*)time_sig
                   genre:(NSString*)genre
                     bpm:(NSString*)bpm
                   notes:(NSString*)notes
{
    isEditing = true;
    self.titleText.text = title;
    self.artistText.text = artist;
    
    self.prevChord = key;
    [self.keyPick setTitle:key forState:(UIControlStateNormal)];
    [self.genrePick setTitle:genre forState:(UIControlStateNormal)];
    [self.timePick setTitle:time_sig forState:(UIControlStateNormal)];
    [self.bpmPick setTitle:bpm forState:(UIControlStateNormal)];
}

- (IBAction)cancelNewChord:(id)sender {
    [self.delegate closeInfo];
}

-(void)setSelectedValue:(NSString*)value{
    [self.popuperView dismissPopoverAnimated:YES];
    if (selectedField >= 0){
        switch (selectedField) {
            case 0:
                [self.keyPick setTitle:value forState:UIControlStateNormal];
                //[self showGenrePicker:nil];
                break;
            case 1:
                [self.genrePick setTitle:value forState:UIControlStateNormal];
                //[self showTimeSigPicker:nil];
                break;
            case 2:
                [self.bpmPick setTitle:value forState:UIControlStateNormal];
                break;
            case 3:
                [self.timePick setTitle:value forState:UIControlStateNormal];
                //[self showBPMPicker:nil];
                break;
            default:
                break;
        }
    }
    selectedField = -1;
}

- (IBAction)showKeyPicker:(id)sender {
    [self.titleText resignFirstResponder];
    [self.artistText resignFirstResponder];
    selectedField = 0;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    SignaturePickerViewController *controller = (SignaturePickerViewController*)[mainStoryboard
                                                                                 instantiateViewControllerWithIdentifier: @"SignaturePicker"];
    controller.delegate = self;
    self.popuperView = [[UIPopoverController alloc]initWithContentViewController:controller];
    [self.popuperView setDelegate:self];
    self.popuperView.popoverContentSize = CGSizeMake(150, 210);
    
    [self.popuperView presentPopoverFromRect:self.keyPick.frame inView:self.dialogContainer permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [controller reloadForKey:self.keyPick.titleLabel.text];
}

- (IBAction)showGenrePicker:(id)sender {
    [self.titleText resignFirstResponder];
    [self.artistText resignFirstResponder];
    
    selectedField = 1;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    SignaturePickerViewController *controller = (SignaturePickerViewController*)[mainStoryboard
                                                                                 instantiateViewControllerWithIdentifier: @"SignaturePicker"];
    controller.delegate = self;
    self.popuperView = [[UIPopoverController alloc]initWithContentViewController:controller];
    [self.popuperView setDelegate:self];
    
    self.popuperView.popoverContentSize = CGSizeMake(250, 210);
    [self.popuperView presentPopoverFromRect:self.genrePick.frame inView:self.dialogContainer permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [controller reloadForGenre:self.genrePick.titleLabel.text];
}

- (IBAction)showBPMPicker:(id)sender {
    [self.titleText resignFirstResponder];
    [self.artistText resignFirstResponder];
    
    selectedField = 2;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    SignaturePickerViewController *controller = (SignaturePickerViewController*)[mainStoryboard
                                                                                 instantiateViewControllerWithIdentifier: @"SignaturePicker"];
    controller.delegate = self;
    self.popuperView = [[UIPopoverController alloc]initWithContentViewController:controller];
    [self.popuperView setDelegate:self];
   
    [self.popuperView presentPopoverFromRect:self.bpmPick.frame inView:self.dialogContainer permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [controller reloadForBpm:self.bpmPick.titleLabel.text];
}

- (IBAction)showTimeSigPicker:(id)sender {
    [self.titleText resignFirstResponder];
    [self.artistText resignFirstResponder];
    
    selectedField = 3;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    SignaturePickerViewController *controller = (SignaturePickerViewController*)[mainStoryboard
                                                       instantiateViewControllerWithIdentifier: @"SignaturePicker"];
    controller.delegate = self;
    self.popuperView = [[UIPopoverController alloc]initWithContentViewController:controller];
    [self.popuperView setDelegate:self];
    self.popuperView.popoverContentSize = CGSizeMake(150, 210);

    [self.popuperView presentPopoverFromRect:self.timePick.frame inView:self.dialogContainer permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [controller reloadForTime:self.timePick.titleLabel.text];

}

+ (id) newChordDialog:(id)pickDelegate{
   
;

    UINib *nib = [UINib nibWithNibName:@"NewChordDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    NewChordDialog *me = [nibArray objectAtIndex: 0];
 
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    me.genrePick.titleLabel.adjustsFontSizeToFitWidth = YES;
    me.genrePick.titleLabel.lineBreakMode = NSLineBreakByClipping;
    return me;
}




@end
