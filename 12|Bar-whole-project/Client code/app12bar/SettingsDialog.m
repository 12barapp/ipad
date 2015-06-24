//
//  SettingsDialog.m
//  app12bar
//
//  Created by Alex on 7/8/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "SettingsDialog.h"
#import "HelpViewController.h"
#import "UIView+MGBadgeView.h"
#import "ServerUpdater.h"
#import "User.h"
#import "SharedNotifierViewController.h"
#import "HomeViewController.h"

@implementation SettingsDialog {
    ServerUpdater *serverUpdater;
}


static CoreSettings *setting;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
+ (id) settingsDialog:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"SettingsDialog" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    SettingsDialog *me = [nibArray objectAtIndex: 0];
    
    [me.dialogContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [me.dialogContainer.layer setShadowOpacity:0.7];
    [me.dialogContainer.layer setShadowRadius:10.0];
    [me.dialogContainer.layer setShadowOffset:CGSizeMake(7.0, 7.0)];
    me.delegate = pickDelegate;
    
    me.parentController = pickDelegate;
    
    return me;
}

-(void)initSettings{
    self.currentUser = [User sharedManager];
    setting = [CoreSettings sharedManager];
    [setting loadSetting];
    
    soundActive = [setting isSoundActive];
    if ([setting isSoundActive]) {
        self.soundButton.backgroundColor = [self colorWithHexString:@"#29abe2"];
    } else {
        self.soundButton.backgroundColor = [UIColor darkGrayColor];
    }
    
    showLyrics = [setting isShowLyrics];
    if ([setting isShowLyrics]) {
        self.lyricsButton.backgroundColor = [self colorWithHexString:@"#f68d91"];
    } else {
        self.lyricsButton.backgroundColor =[UIColor darkGrayColor];
    }
    
    showChords = [setting isShowChords];
    if (showChords) {
        self.chordsButton.backgroundColor = [self colorWithHexString:@"#f68d91"];
    } else {
        self.chordsButton.backgroundColor = [self colorWithHexString:@"#b3b3b3"];
    }
    
    isLight = [setting isLightTheme];
    if ([setting isLightTheme]) {
        self.themeButton.backgroundColor = [self colorWithHexString:@"#b3b3b3"];
    } else {
        self.themeButton.backgroundColor = [self colorWithHexString:@"#666666"];
    }
    
    if ([self.currentUser getUsedMode] == MODE_FREE) {
        [self.loginButtonTitle setTitle:@"Login" forState:(UIControlStateNormal)];
    }
    
    self.tutsButton.backgroundColor = [self colorWithHexString:@"#b3b3b3"];
    
    [self.sharedButton.badgeView setBadgeValue:self.numberOfSharedItems];
    [self.sharedButton.badgeView setPosition:MGBadgePositionTopLeft];
    [self.sharedButton.badgeView setBadgeColor:[[[ColorHelper alloc] init] getBadgeRedColor]];
    [self.sharedButton.badgeView setOutlineWidth:0.75];
}

- (IBAction)closeSettings:(id)sender{
    [self.delegate closeSettings];
}
- (IBAction)setLightDark:(id)sender {
    
    NSLog(@"Change theme");
    if ([setting isLightTheme]) {
        ((UIButton*)sender).backgroundColor = [self colorWithHexString:@"#666666"];
        isLight = false;
        [setting activeLightTheme:isLight];
    } else {
        isLight = true;
        [setting activeLightTheme:isLight];
        ((UIButton*)sender).backgroundColor = [self colorWithHexString:@"#b3b3b3"];
    }
    
}
- (IBAction)setDisplayOnlyChords:(id)sender {
    if ([setting isShowChords]){
        showChords = false;
        if (![setting isShowLyrics]) {
            self.lyricsButton.backgroundColor = [self colorWithHexString:@"#f68d91"];
            showLyrics = true;
        }
        [setting activeShowLyrics:showLyrics];
        [setting activeShowChords:showChords];
        ((UIButton*)sender).backgroundColor = [self colorWithHexString:@"#b3b3b3"];
    } else {
        ((UIButton*)sender).backgroundColor = [self colorWithHexString:@"#f4767b"];
        showChords = true;
        [setting activeShowLyrics:showLyrics];
        [setting activeShowChords:showChords];
    }
    
}
- (IBAction)setDisplayOnlyLyrics:(id)sender {
    if ([setting isShowLyrics]){
        showLyrics = false;
        if (![setting isShowChords]){
            self.chordsButton.backgroundColor = [self colorWithHexString:@"#f68d91"];
            showChords = true;
        }
        [setting activeShowLyrics:showLyrics];
        [setting activeShowChords:showChords];
        ((UIButton*)sender).backgroundColor = [self colorWithHexString:@"#666666"];
    } else {
        ((UIButton*)sender).backgroundColor = [self colorWithHexString:@"#f68d91"];
        showLyrics = true;
        [setting activeShowLyrics:showLyrics];
        [setting activeShowChords:showChords];
    }
}

- (IBAction)setDisplayAll:(id)sender {
    [self.delegate showPrivacy];
}

- (IBAction)displaySharedCharts:(id)sender {
    [self.sharedButton.badgeView setBadgeValue:0];
    serverUpdater = [ServerUpdater sharedManager];
    
    if (![@"" isEqualToString:[self.currentUser mySecretKey]] && [self.currentUser mySecretKey] != nil){
        [serverUpdater getSharedItems:^(NSArray *sharedCharts, NSArray *sharedSets) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SharedNotifierViewController *viewController = (SharedNotifierViewController*)[storyboard
                                                                                           instantiateViewControllerWithIdentifier:@"notifierController"];
            [viewController showSharedCharts:[sharedCharts mutableCopy] andSets:[sharedSets mutableCopy] ];
            viewController.delegate = (HomeViewController *)self.parentController;
            [self.parentController presentViewController:viewController animated:YES completion:NULL];
            
        }];
    }
}

- (IBAction)switchSound:(id)sender {
    if ([setting isSoundActive]) {
        soundActive = false;
         [setting activeSound:soundActive];
        ((UIButton*)sender).backgroundColor = [UIColor darkGrayColor];
    } else {
        soundActive = true;
         [setting activeSound:soundActive];
        ((UIButton*)sender).backgroundColor = [self colorWithHexString:@"#29abe2"];
    }
}

- (IBAction)recallTuts:(id)sender {
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HelpViewController *viewController = (HelpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"help"];
//    [viewController setHelpFile:@"tuts_all"];
//    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)); // 1
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ // 2
//        
//        [self.parentController presentViewController:viewController animated:YES completion:nil];
//    });
    
    //[self.delegate closeSettings];
    
    [self.delegate recallTuts];
}

- (IBAction)logOut:(id)sender {
    [self.delegate logOut];
}

- (IBAction)tellAFriend:(id)sender {
    [self.delegate mailTofriend];
}

- (IBAction)showAbout:(id)sender {
    [self.delegate showAbout];
}

- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

@end
