//
//  ParseHelper.h
//  app12bar
//
//  Created by Noah Labhart on 3/1/15.
//  Copyright (c) 2015 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseHelper : NSObject

+ (void)initialize;

+ (void)registerInstallationforPushNotifications:(NSData *)deviceToken;
+ (void)registerInstallationforPushNotifications:(NSData *)deviceToken
                                  withFacebookID:(NSString *)facebookID;
+ (void)registerInstallationforFacebookID:(NSString *)facebookID;

+ (void)sendPushNotification:(NSString *)message;
+ (void)sendPushNotification:(NSString *)message
             withFacebookIDs:(NSString *)facebookIDs;

+ (void)handlePush:(NSDictionary *)userData;

@end
