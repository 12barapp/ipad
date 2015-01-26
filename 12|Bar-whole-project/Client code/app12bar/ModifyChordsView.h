//
//  ModifyChordsView.h
//  app12bar
//
//  Created by Alex on 8/14/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModifyChordsView;
@protocol ModifyChordsDelegate
-(void)closeKeyDialog;
-(void)setMetadataForChord:(NSString*)mData;
-(void)setChordModifier:(NSString*)modifier;
-(void)setKeyModifier:(NSString*)tileText;
-(void)makeCustom;

@end
@interface ModifyChordsView : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (strong)                     NSString *tempModifier;
@property (strong)                     UIButton *prevButton;
@property (assign)                     id<ModifyChordsDelegate> delegate;
@property (assign)                     id<ModifyChordsDelegate> delegate2;
+ (id) modifyChordsDialog:(id)pickDelegate andSecondDelegate:(id)sDelegate;
@end
