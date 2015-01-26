//
//  NewSetDialog.m
//  app12bar
//
//  Created by Alex on 7/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "NewSetDialog.h"

@implementation NewSetDialog

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.setTitle.delegate = self;
        self.setArtist.delegate = self;
        self.setLocation.delegate = self;
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.setTitle) {
        [self.setArtist becomeFirstResponder];
    } else if(textField == self.setArtist) {
        [self.setArtist resignFirstResponder];
        [self showDatePicker:self.datePickerBtn];
    }else if(textField == self.setLocation) {
        [self.setLocation resignFirstResponder];
        [self.setTitle becomeFirstResponder];
    }
    return YES;
}

-(void)setDateForSet:(NSString*)date{
    [self.popuperView dismissPopoverAnimated:YES];
    [self.datePickerBtn setTitle:date forState:(UIControlStateNormal)];
}

+(id)newSetDialog:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"NewSetDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    NewSetDialog *me = [nibArray objectAtIndex: 0];
    me.setTitle.delegate = me;
    me.setArtist.delegate = me;
    me.setLocation.delegate = me;
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];

    
    me.delegate = pickDelegate;
    
    return me;
}
- (IBAction)showDatePicker:(id)sender {
    [self.setTitle resignFirstResponder];
    [self.setLocation resignFirstResponder];
    [self.setArtist resignFirstResponder];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    DatePickerViewController *controller = (DatePickerViewController*)[mainStoryboard
                                                                                 instantiateViewControllerWithIdentifier: @"DatePickerView"];
    controller.delegate = self;
    self.popuperView = [[UIPopoverController alloc]initWithContentViewController:controller];
    [self.popuperView setDelegate:self];
    
    [self.popuperView presentPopoverFromRect:self.datePickerBtn.frame inView:self.dialogContainer permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.popuperView.popoverContentSize = CGSizeMake(250, 210);
}

-(void)setDataForEDiting:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location{
    isEditing = true;
    self.setTitle.text = title;
    self.setArtist.text = artist;
    [self.datePickerBtn  setTitle:date forState:(UIControlStateNormal)];
 //   NSLog(@"%@",date);
    self.setLocation.text = location;
}

-(void)doneNewSet:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location{
    
}
- (IBAction)newSetDone:(id)sender {
    if(!isEditing){
        if ([self validateData])
            [self.delegate doneNewSet:self.setTitle.text artist:self.setArtist.text date:self.datePickerBtn.titleLabel.text location:self.setLocation.text];
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill required data." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    } else {
        if ([self validateData]) {
            [self.delegate updateExistingSet:self.setTitle.text artist:self.setArtist.text date:self.datePickerBtn.titleLabel.text location:self.setLocation.text];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill required data." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}
- (IBAction)newSetCancel:(id)sender {
    [self.delegate setCancel];
}


- (BOOL)validateData {
    bool ch = false;
    if ([self.setTitle.text length] > 0 && self.setTitle.text != nil && [self.setTitle.text isEqual:@""] == FALSE){
        ch = true;
    } else {
        ch = false;
        return false;
    }
    if ([self.setArtist.text length] > 0 && self.setArtist.text != nil && [self.setArtist.text isEqual:@""] == FALSE){
        ch = true;
    } else {
        ch = false;
        return false;
    }
    
    if ([self.datePickerBtn.titleLabel.text length] > 0 && self.datePickerBtn.titleLabel.text != nil && [self.datePickerBtn.titleLabel.text isEqual:@""] == FALSE){
        ch = true;
    } else {
        ch = false;
        return false;
    }
    if ([self.setLocation.text length] > 0 && self.setLocation.text != nil && [self.setLocation.text isEqual:@""] == FALSE){
        ch = true;
    } else {
        ch = false;
        return false;
    }
    return ch;
}


@end
