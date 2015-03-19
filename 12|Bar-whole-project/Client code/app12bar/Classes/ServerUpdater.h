//
//  ServerUpdater.h
//  app12bar
//
//  Created by Alex on 7/23/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class ServerUpdater;

@protocol ServerUpdaterDelegate
-(void)hideCover;
-(void)updateChart:(NSString*)chartId withServerId:(NSString*)serverId;
-(void)setMessageForWaiting:(NSString*)mes;
-(void)setUserData:(NSDictionary*)userData;
-(void)notifyAboutSharedData:(NSDictionary*)data andShared:(NSString*)shared;
-(void)notifyAboutUpdatedData:(NSDictionary*)data andShared:(NSString*)shared;
-(void)presentSharedViewController:(NSDictionary*)data andShared:(NSString*)shared;
-(void)backToLogin;
@end

@interface ServerUpdater : NSObject<UIAlertViewDelegate>

@property (nonatomic, retain) NSURL *serverUrl;
@property (nonatomic, retain) NSMutableURLRequest *serverRequest;
@property (nonatomic, retain) NSCondition *serverConnection;
@property (nonatomic, retain) User *currentUser;
@property (nonatomic, assign) int usrLoginWith;
@property (nonatomic, retain) NSTimer *taskTimer;
@property (nonatomic, assign) BOOL checkUpdates;
@property (nonatomic, assign) BOOL checkShare;
@property (nonatomic, retain) NSString *userEmail;
@property (assign)            id<ServerUpdaterDelegate> delegate;

+ (id)sharedManager;

-(void)acceptChart:(NSString*)chartId;
-(void)acceptChart:(NSString*)chartId completion:(void (^)(BOOL result))completionHandler;
-(void)acceptSet:(NSString*)setId;
-(void)acceptSet:(NSString*)setId completion:(void (^)(BOOL result))completionHandler;

-(void)declineChart:(NSString*)chartId;
-(void)declineChart:(NSString*)chartId completion:(void (^)(BOOL result))completionHandler;
-(void)declineSet:(NSString*)setId;
-(void)declineSet:(NSString*)setId completion:(void (^)(BOOL result))completionHandler;

-(void)removeSetForMe:(NSString*)setId;
-(void)removeSet:(NSString*)setId;
-(void)removeChart:(NSString*)chartId;
-(void)removeChartForMe:(NSString*)chartId;
-(void)addChartIntoSet:(NSString*)chartId setId:(NSString*)sId;

-(void)addChartIntoSetWithData:(NSString*)chartId setId:(NSString*)sId;

-(void)updateChart:(NSString*)data chartId:(NSString*)chartId;
-(void)updateSet:(NSDictionary*)data setId:(NSString*)setId;
-(void)shareChart:(NSString*)chartId withFriends:(NSString*)friends;
-(void)removeChart:(NSString*)chartId fromSet:(NSString*)setId;
-(void)passNewChartWithId:(NSString*)chartId;
-(void)passNewSetWithId:(NSString*)setId;
-(void)updateChord:(NSDictionary*)data withFriends:(NSString*)friends;

-(void)shareChord:(NSString*)data withFriends:(NSString*)friends;
-(void)shareSet:(NSString*)set withFriends:(NSString*)friends;

-(void)loginUserWithFb:(NSString*)userId;

-(void)getSharedData;
-(void)getSharedItemsCount:(void (^)(int))completionHandler;
-(void)getSharedItems:(void (^)(NSDictionary*))completionHandler;
-(void)pauseCheck;
-(void)continueCheck;
@end
