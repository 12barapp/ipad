//
//  CoreSettings.m
//  app12bar
//
//  Created by Alex on 8/11/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "CoreSettings.h"

@implementation CoreSettings

+ (id)sharedManager {
    static CoreSettings *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

-(void)saveSetting{
   /* NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:self.isLight forKey:@"theme"];
    [prefs setBool:self.showChords forKey:@"showChords"];
    [prefs setBool:self.showLyrics forKey:@"showLyrics"];
    [prefs setBool:self.soundActive forKey:@"soundActive"];
    //[prefs synchronize];
    [[NSUserDefaults standardUserDefaults] synchronize];*/
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // check if file exists
    NSString *plistPath = [self copyFileToDocumentDirectory:
                           @"Settings.plist"];
    
    BOOL isExist = [manager fileExistsAtPath:plistPath];
    // BOOL done = NO;
    
    if (!isExist) {
        // done = [manager copyItemAtPath:file toPath:fileName error:&error];
    }

    NSMutableDictionary *settingsForSave = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [settingsForSave setValue:[NSNumber numberWithBool:self.soundActive] forKey:@"soundActive"];
    [settingsForSave setValue:[NSNumber numberWithBool:self.isLight] forKey:@"themeLight"];
    [settingsForSave setValue:[NSNumber numberWithBool:self.showChords] forKey:@"showChords"];
    [settingsForSave setValue:[NSNumber numberWithBool:self.showLyrics] forKey:@"showLyrics"];
    
    [settingsForSave writeToFile:plistPath atomically:YES];
}

-(void)loadSetting{
  /*  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self activeSound:[prefs boolForKey:@"soundActive"]];
    [self activeLightTheme:[prefs boolForKey:@"theme"]];
    [self activeShowChords:[prefs boolForKey:@"showChords"]];
    [self activeShowLyrics:[prefs boolForKey:@"showLyrics"]];
    NSLog(@"Settings loaded");
    */
    // set file manager object
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // check if file exists
    NSString *plistPath = [self copyFileToDocumentDirectory:
                           @"Settings.plist"];
    
    BOOL isExist = [manager fileExistsAtPath:plistPath];
    // BOOL done = NO;
    
    if (!isExist) {
        // done = [manager copyItemAtPath:file toPath:fileName error:&error];
    }
    
    // get data from plist file
    NSDictionary * plistArray = [[NSDictionary alloc]
                                   initWithContentsOfFile:plistPath];
   // NSLog(@"loaded settings %@",plistArray);
    [self activeLightTheme:[[plistArray valueForKey:@"themeLight"] boolValue]];
    [self activeSound:[[plistArray valueForKey:@"soundActive"] boolValue]];
    [self activeShowChords:[[plistArray valueForKey:@"showChords"] boolValue]];
    [self activeShowLyrics:[[plistArray valueForKey:@"showLyrics"] boolValue]];
}


-(void)activeShowChords:(BOOL)active{
    self.showChords = active;
    [self saveSetting];
}
-(void)activeShowLyrics:(BOOL)active{
    self.showLyrics = active;
    [self saveSetting];
}

-(void)activeSound:(BOOL)active{
    self.soundActive = active;
    [self saveSetting];
}

-(BOOL)isLightTheme{
    return self.isLight;
}

-(BOOL)isSoundActive{
    return self.soundActive;
}

-(BOOL)isShowChords{
    return self.showChords;
}

-(BOOL)isShowLyrics{
    return self.showLyrics;
}

-(void)activeLightTheme:(BOOL)light{
    self.isLight = light;
    [self saveSetting];
}

- (NSString *)copyFileToDocumentDirectory:(NSString *)fileName {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *documentDirPath = [documentsDir
                                 stringByAppendingPathComponent:fileName];
    
    NSArray *file = [fileName componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle]
                          pathForResource:[file objectAtIndex:0]
                          ofType:[file lastObject]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:documentDirPath];
    
    if (!success) {
        success = [fileManager copyItemAtPath:filePath
                                       toPath:documentDirPath
                                        error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable txt file file with message \
                      '%@'.", [error localizedDescription]);
        }
    }
    
    return documentDirPath;
}


@end
