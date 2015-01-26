//
//  User.h
//  app12bar
//
//  Created by Alex on 7/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {MODE_FREE = 0, MODE_EMAIL = 1, MODE_FB = 2} USED_MODES;

@interface User : NSObject {

}

@property (nonatomic) NSString *userFbName;
@property (nonatomic) NSString *userEmail;
@property (nonatomic) NSString *userFirstName;
@property (nonatomic) NSString *userSecondName;
@property (nonatomic) NSString *latestCreateChartDate;
@property (nonatomic) NSString *latestUpdatedChartDate;
@property (nonatomic) NSString *latestCreatedSetDate;
@property (nonatomic) NSString *latestUpdatedSetDate;
@property (nonatomic) NSString *chartId;
@property (nonatomic) NSString *setId;
@property (nonatomic) NSString *orderKeyForChart;
@property (nonatomic) NSString *orderKeyForSets;
@property (nonatomic) int usedMode;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *realID;
@property (nonatomic) NSString *mySecretKey;
@property (nonatomic) NSString *deviceToken;
@property (nonatomic) NSMutableArray *currentChords;
@property (nonatomic) NSDictionary *selectedChordJson;
@property (nonatomic) NSNumber* selectedSet;
@property (nonatomic) NSNumber* selectedChord;
@property (nonatomic) BOOL appIsLoaded;

+ (id)sharedManager;
-(int)getUsedMode;
-(void)setIdForUser:(NSString*)uId;
-(NSString*)getIdForUser;
-(void)setFBName:(NSString*)name;
-(NSString*)getFBName;
-(NSString*)getUserRealID;

-(void)setLatestCreatedDateForSet:(NSString*)date;
-(NSString*)getLatestCreatedDateForSet;


-(void)setLatestUpdateDateForSet:(NSString*)date;
-(NSString*)getLatestUpdateDateForSet;

-(void)setLatesDateForChart:(NSString*)date;
-(NSString*)getLatestDateForChart;

-(void)setLatestUpdateDateForChart:(NSString*)date;
-(NSString*)getLatestUpdateDateForChart;
@end
