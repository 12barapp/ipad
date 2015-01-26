//
//  DatePickerViewController.h
//  app12bar
//
//  Created by Alex on 7/21/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerViewController;
@protocol DatePickerViewDelegate

-(void)setDateForSet:(NSString*)date;

@end
@interface DatePickerViewController : UIViewController
@property (assign)   id<DatePickerViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
