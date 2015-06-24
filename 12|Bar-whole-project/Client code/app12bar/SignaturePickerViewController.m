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

@synthesize doneButton = _doneButton;

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
    self.doneButton.hidden = YES;
}

- (IBAction)valueChanged:(UISlider*)sender {
    self.sliderUpd.text = [NSString stringWithFormat:@"%.f",[sender value]];
//    self.sliderValue.text = [NSString stringWithFormat:@"%.f",[sender value]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self donePicker:nil];
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

-(void)reloadForTime:(NSString *)timeToSet
{
    [self reloadForTime];
    
    [self.signaturePick selectRow:[self findIndexValue:timeToSet
                                               inArray:self.timeSigs]
                      inComponent:0
                         animated:YES];
}

-(void)reloadForTime{
    //self.preferredContentSize = CGSizeMake(250, 410);
    self.timeSigs = nil;
   self.timeSigs = [[NSArray alloc] initWithObjects:@"2/2",@"4/2",@"3/4",@"4/4",@"3/8",@"5/8",@"6/8",@"7/8", nil];
    [self.signaturePick reloadAllComponents];
    
    self.doneButton.hidden = YES;
    
};

-(void)reloadForGenre:(NSString *)genreToSet
{
    [self reloadForGenre];
    
    [self.signaturePick selectRow:[self findIndexValue:genreToSet
                                               inArray:self.timeSigs]
                      inComponent:0
                         animated:YES];
}

-(void)reloadForGenre{
    //self.preferredContentSize = CGSizeMake(250, 410);
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
    
    self.doneButton.hidden = YES;
}

-(NSInteger)findIndexValue:(NSString *)value inArray:(NSArray *)array
{
    NSInteger index = -1;
    
    for (int i = 0; i < array.count; ++i)
    {
        if ([[array objectAtIndex:i] isEqualToString:value])
        {
            index = i;
            break;
        }
    }
    
    NSLog(@"String %@ Value %ld", value, (long)index);
    
    return index;
}

-(void)reloadForKey:(NSString *)keyToSet
{
    [self reloadForKey];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.signaturePick selectRow:[self findIndexValue:keyToSet
                                                   inArray:self.timeSigs]
                          inComponent:0
                             animated:YES];
    });
}

-(void)reloadForKey{
    //self.preferredContentSize = CGSizeMake(250, 410);
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
    
    self.doneButton.hidden = YES;
};

-(void)reloadForBpm:(NSString *)bpmToSet
{
    [self reloadForBpm];
    
    [self.sliderUpd setText:bpmToSet];
    [self.slider setValue:[bpmToSet floatValue]];
}

-(void)reloadForBpm{
    self.pickerContainer.hidden = YES;
    //self.preferredContentSize = CGSizeMake(250, 410);
    isBpm = true;
    self.sliderContainer.hidden = NO;
    
    self.doneButton.hidden = NO;
   
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
