//
//  SettingsDialog.h
//  app12bar
//
//  Created by Alex on 7/8/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreSettings.h"
#import "User.h"
#import "ServerUpdater.h"

@class SettingsDialog;
@protocol SettingsDialogDelegate
-(void)closeSettings;
-(void)logOut;
-(void)mailTofriend;
-(void)showAbout;
-(void)showPrivacy;
-(void)recallTuts;

@end
@interface SettingsDialog : UIView {
    BOOL soundActive;
    BOOL showChords;
    BOOL showLyrics;
    BOOL isLight;
}
@property (strong, nonatomic) IBOutlet UIView *dialogContainer;
@property (strong, nonatomic) IBOutlet UIButton *loginButtonTitle;
@property (nonatomic, retain)          User* currentUser;
@property (strong, nonatomic) IBOutlet UIButton *chordsButton;
@property (strong, nonatomic) IBOutlet UIButton *lyricsButton;
@property (strong, nonatomic) IBOutlet UIButton *themeButton;
@property (strong, nonatomic) IBOutlet UIButton *soundButton;
@property (strong, nonatomic) IBOutlet UIButton *tutsButton;
@property (strong, nonatomic) IBOutlet UIButton *sharedButton;

@property NSInteger numberOfSharedItems;
@property UIViewController *parentController;
@property id <ServerUpdaterDelegate> parentDelegate;


@property(assign)id<SettingsDialogDelegate> delegate;
+ (id) settingsDialog:(id)pickDelegate;
-(void)initSettings;
- (IBAction)closeSettings:(id)sender;
@end
