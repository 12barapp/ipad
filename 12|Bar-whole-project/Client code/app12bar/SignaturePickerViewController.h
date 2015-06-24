
//
//  SignaturePickerViewController.h
//  app12bar
//
//  Created by Alex on 7/21/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SignaturePickerDelegate <NSObject>
@required
-(void)setSelectedValue:(NSString*)value;
@end

@interface SignaturePickerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{
    NSString *selectedValue;
    BOOL isBpm;
}
@property (strong, nonatomic) IBOutlet UIPickerView *signaturePick;
@property (strong, nonatomic) IBOutlet UITextField *sliderUpd;
@property (strong, nonatomic)          NSArray *timeSigs;
@property (strong, nonatomic) id<SignaturePickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *sliderContainer;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *sliderValue;
@property (strong, nonatomic) IBOutlet UIView *pickerContainer;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;


-(void)reloadForGenre;
-(void)reloadForGenre:(NSString *)genreToSet;
-(void)reloadForKey;
-(void)reloadForKey:(NSString *)keyToSet;
-(void)reloadForBpm;
-(void)reloadForBpm:(NSString *)bpmToSet;
-(void)reloadForTime;
-(void)reloadForTime:(NSString *)timeToSet;
@end
