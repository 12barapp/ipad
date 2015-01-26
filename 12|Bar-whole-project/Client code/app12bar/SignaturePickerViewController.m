//
//  SignaturePickerViewController.m
//  app12bar
//
//  Created by Alex on 7/21/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "SignaturePickerViewController.h"

@interface SignaturePickerViewController ()

@end

@implementation SignaturePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(150, 210);
    //self.timeSigs = [[NSArray alloc] initWithObjects:@"2/2",@"4/2",@"3/4",@"4/4",@"3/8",@"5/8",@"6/8",@"7/8", nil];
    [self.signaturePick selectRow:3 inComponent:0 animated:YES];
}

- (IBAction)valueChanged:(UISlider*)sender {
    self.sliderUpd.text = [NSString stringWithFormat:@"%.f",[sender value]];
//    self.sliderValue.text = [NSString stringWithFormat:@"%.f",[sender value]];
}
- (IBAction)ch:(UITextField *)sender {
    self.slider.value = [sender.text floatValue];
}

- (IBAction)txtChanged:(id)sender {
    
}

- (IBAction)cancelPicker:(id)sender {
    
}

- (IBAction)donePicker:(id)sender {
    if (!isBpm)
    [self.delegate setSelectedValue:[self pickerView:self.signaturePick titleForRow:[self.signaturePick selectedRowInComponent:0] forComponent:0]];
    else
        [self.delegate setSelectedValue:self.sliderUpd.text];
}

-(void)reloadForTime{
    self.preferredContentSize = CGSizeMake(250, 410);
    self.timeSigs = nil;
   self.timeSigs = [[NSArray alloc] initWithObjects:@"2/2",@"4/2",@"3/4",@"4/4",@"3/8",@"5/8",@"6/8",@"7/8", nil];
    [self.signaturePick reloadAllComponents];
    
};

-(void)reloadForGenre{
    self.preferredContentSize = CGSizeMake(250, 410);
    self.timeSigs = nil;
    self.timeSigs = [[NSArray alloc] initWithObjects:@"Folk/Acoustic",
                     @"Alternative/Indie",
                     @"Blues",@"Children’s",
                     @"Classical/New Age",
                     @"Country",
                     @"Dance/Electronic",
                     @"R&B/Funk/Soul",
                     @"Gospel",
                     @"Rap/Hip Hop",
                     @"Instrumental",
                     @"Jazz",
                     @"Metal",
                     @"Pop",
                     @"Praise and Worship",
                     @"Punk",
                     @"Reggae",
                     @"Rock and Roll",
                     @"Americana/Roots",
                     @"World", nil];
    [self.signaturePick reloadAllComponents];
}

-(void)reloadForKey{
    self.preferredContentSize = CGSizeMake(250, 410);
    self.timeSigs = nil;
    self.timeSigs = [[NSArray alloc] initWithObjects:@"C",
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
    [self.signaturePick reloadAllComponents];
};

-(void)reloadForBpm{
    self.pickerContainer.hidden = YES;
    //self.preferredContentSize = CGSizeMake(250, 410);
    isBpm = true;
    self.sliderContainer.hidden = NO;
   
};

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return self.timeSigs.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.timeSigs objectAtIndex:row];
}

-(void) viewDidAppear:(BOOL)animated{

}

@end
