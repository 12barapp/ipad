//
//  User.m
//  app12bar
//
//  Created by Alex on 7/7/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize realID, chartId, deviceToken;

- (id)init
{
    if((self = [super init]))
    {
    }
    [self setAppIsLoaded:FALSE];
    return self;
}

+ (id)sharedManager {

    static User *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.latestCreateChartDate = @"";
        sharedMyManager.latestCreatedSetDate = @"";
        sharedMyManager.latestUpdatedChartDate = @"";
        sharedMyManager.latestUpdatedSetDate = @"";

    });
    return sharedMyManager;
}

-(NSString*)getUserRealID{
    return self.realID;
}

-(void)setLatestCreatedDateForSet:(NSString*)date{
    self.latestCreatedSetDate = date;
}

-(NSString*)getLatestCreatedDateForSet{
    return self.latestCreatedSetDate;
}

-(void)setLatestUpdateDateForSet:(NSString*)date{
    self.latestUpdatedSetDate = date;
}

-(NSString*)getLatestUpdateDateForSet{
    return self.latestUpdatedSetDate;
}

-(void)setLatestUpdateDateForChart:(NSString*)date{
    self.latestUpdatedChartDate = date;
}
-(NSString*)getLatestUpdateDateForChart{
    return self.latestUpdatedChartDate;
}

-(void)setLatesDateForChart:(NSString*)date{
    self.latestCreateChartDate = date;
}

-(NSString*)getLatestDateForChart{
    return self.latestCreateChartDate;
}

-(int)getUsedMode{
    return self.usedMode;
}

-(void)setIdForUser:(NSString*)uId{
    if (self.userId == nil)
        self.userId = [[NSString alloc] init];
    self.userId = uId;
}

-(NSString*)getIdForUser{
    return self.userId;
}

-(void)setFBName:(NSString*)name{
    self.userFbName = name;
}
-(NSString*)getFBName{
    return self.userFbName;
}

@end
