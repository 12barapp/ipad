//
//  CoreSettings.h
//  app12bar
//
//  Created by Alex on 8/11/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreSettings : NSObject{

}
@property (assign, nonatomic) BOOL isLight;
@property (assign, nonatomic) BOOL soundActive;
@property (assign, nonatomic) BOOL showChords;
@property (assign, nonatomic) BOOL showLyrics;

+(CoreSettings*)sharedManager;

-(void)saveSetting;
-(void)loadSetting;

-(BOOL)isLightTheme;
-(BOOL)isSoundActive;
-(BOOL)isShowChords;
-(BOOL)isShowLyrics;


-(void)activeLightTheme:(BOOL)light;
-(void)activeShowChords:(BOOL)active;
-(void)activeShowLyrics:(BOOL)active;
-(void)activeSound:(BOOL)active;

@end
