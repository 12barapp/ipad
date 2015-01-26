//
//  ChangeKeysView.h
//  app12bar
//
//  Created by Alex on 8/14/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChangeKeysView;
@protocol ChangeKeysDelegate

-(void)setKeyTile:(NSString*)tileText;
-(void)setNewSongKey:(NSString*)key;
-(void)closeKeyDialog;
@end

@interface ChangeKeysView : UIView

@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (assign)                     id<ChangeKeysDelegate> delegate;

+ (id) changeKeysDialog:(id)pickDelegate andSecondDelegate:(id)sDelegate;
@end
