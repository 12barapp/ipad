//
//  ParseHelper.m
//  app12bar
//
//  Created by Noah Labhart on 3/1/15.
//  Copyright (c) 2015 Vasilkoff LTD. All rights reserved.
//

#import "ParseHelper.h"

#import <Parse/Parse.h>

#define PARSE_APP_ID        @"GBH1BF9vzfja29StJGHlkot7X9CONtQMNGEKMk4G"
#define PARSE_CLIENT_KEY    @"QdGlAkWXkUmHFaGKBHAVKagu6Fw3h5TyVR5BlWGo"

@implementation ParseHelper

+ (void)initialize
{
    [Parse setApplicationId:PARSE_APP_ID
                  clientKey:PARSE_CLIENT_KEY];
}

+ (void)registerInstallationforPushNotifications:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

+ (void)registerInstallationforPushNotifications:(NSData *)deviceToken
                                  withFacebookID:(NSString *)facebookID
{
    if (facebookID && deviceToken) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setDeviceTokenFromData:deviceToken];
        [currentInstallation setObject:facebookID forKey:@"facebookID"];
        [currentInstallation saveInBackground];
    }
}

+ (void)registerInstallationforFacebookID:(NSString *)facebookID
{
    if(facebookID) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:facebookID forKey:@"facebookID"];
        [currentInstallation saveInBackground];
    }
}

+ (void)sendPushNotification:(NSString *)message
{
    NSDictionary *data = @{
                           @"alert" : message,
                           @"badge" : @"Increment"
                           };
    
    PFPush *push = [[PFPush alloc] init];
    [push setData:data];
    [push sendPushInBackground];
}

+ (void)sendPushNotification:(NSString *)message
             withFacebookIDs:(NSString *)facebookIDs
{
    NSArray *fIDs = [facebookIDs componentsSeparatedByString:@","];
    
    for (NSString *fid in fIDs)
    {
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"facebookID" equalTo:fid];
        
        NSDictionary *data = @{
                               @"alert" : message,
                               @"badge" : @"Increment"
                               };
        
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery];
        [push setData:data];
        [push sendPushInBackground];

    }
}

+ (void)handlePush:(NSDictionary *)userData
{
    [PFPush handlePush:userData];
}

@end
