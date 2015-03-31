//
//  ServerUpdater.m
//  app12bar
//
//  Created by Alex on 7/23/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "ServerUpdater.h"
#import "DBManager.h"
#import "AFNetworking.h"

#define SERVER_SET_STRING @"http://192.169.197.8/app12Bar/cms/set.php"
#define SERVER_CHART_STRING @"http://192.169.197.8/app12Bar/cms/chart.php"
#define SERVER_AUTHORIZATION_STRING @"http://192.169.197.8/app12Bar/cms/login_register.php"
#define SERVER_DATA_STRING @"http://192.169.197.8/app12Bar/cms/user_data.php"

@implementation ServerUpdater

@synthesize usrLoginWith, checkUpdates, checkShare;

- (void) shareChord:(NSString *)data withFriends:(NSString *)friends {
    NSLog(@"NOT REALIZED");
}

- (id)init {
    if((self = [super init])) {
        self.currentUser = [User sharedManager];
        //[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(bgTask:) userInfo:nil repeats:YES];
    }
    
    return self;
}

+ (id)sharedManager {
    static ServerUpdater *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)passNewSetWithId:(NSString*)setId{
    NSDictionary *oneSet = [[DBManager sharedManager] getSetWithId:setId];
    [self addNewSet:oneSet];
}

-(NSString*)dictionaryToString:(NSDictionary*)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
}

-(void)passNewChartWithId:(NSString*)chartId{
    NSDictionary *oneChord = [[DBManager sharedManager] getChartById:chartId];
    [self addNewChart:oneChord];
}

-(void)addChartIntoSetWithData:(NSString*)chartId setId:(NSString*)sId{
    NSDictionary *oneChord = [[DBManager sharedManager] getChartById:chartId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"data": [self dictionaryToString:oneChord],
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"insideSet",
                             @"setId":sId
                             };
    NSError *error;
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
       
        if (response != nil){
            if ([@"ok" isEqualToString:[response objectForKey:@"status"]]) {
                [self.currentUser setLatesDateForChart:[response objectForKey:@"latest_created_chart"]];
                [self.currentUser setLatestUpdateDateForChart:[response objectForKey:@"last_updated_chart"]];
                [self.currentUser setLatestUpdateDateForSet:[response objectForKey:@"last_updated_set"]];
            }
            [self continueCheck];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}



-(void)getSharedData {
    NSLog(@"\n\n ---------------- Searching updates on the server ----------------\n\n");
    [self getDataForFb];
}



-(void)updateSet:(NSDictionary*)data setId:(NSString*)setId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"data": [self dictionaryToString:data],
                             @"secret_key":[self.currentUser mySecretKey],
                             @"setId":setId,
                             @"method":@"update"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_SET_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        if (response != nil) {
            if ([@"ok" isEqualToString:[response objectForKey:@"status"]]) {
                [self.currentUser setLatestUpdateDateForSet:[response objectForKey:@"last_updated_set"]];
            }
            [self continueCheck];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)updateChart:(NSString*)data chartId:(NSString*)chartId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"data": data,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"chord_id":chartId,
                             @"method":@"update"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        if (response != nil) {
            if ([@"ok" isEqualToString:[response objectForKey:@"status"]]) {
                [self.currentUser setLatestUpdateDateForChart:[response objectForKey:@"last_updated_chart"]];
                [self.currentUser setLatestUpdateDateForSet:[response objectForKey:@"last_updated_set"]];
            }
            [self continueCheck];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)removeSetForMe:(NSString*)setId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"setId": setId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"remove"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_SET_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        NSLog(@"removeSetForMe: %@",response);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    [manager.operationQueue addOperation:operation];
    
}

-(void)removeSet:(NSString*)setId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"setId": setId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"removeSet"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_SET_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        NSLog(@"removeSet: %@",response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    [manager.operationQueue addOperation:operation];
}

-(void)removeChartForMe:(NSString*)chartId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"chord_id": chartId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"removeForUser"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        NSLog(@"removeChart: %@",response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    [manager.operationQueue addOperation:operation];
}

-(void)removeChart:(NSString*)chartId fromSet:(NSString*)setId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"chord_id": chartId,
                             @"setId":setId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"removeFromSet"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        NSLog(@"removeChart: %@",response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    [manager.operationQueue addOperation:operation];
}

-(void)removeChart:(NSString*)chartId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"chord_id": chartId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"remove"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        NSLog(@"removeChart: %@",response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    [manager.operationQueue addOperation:operation];
}

-(void)addChartIntoSet:(NSString*)chartId setId:(NSString*)sId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"chord_id": chartId,
                             @"setId":sId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"into"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        
        if (response != nil) {
            if ([@"ok" isEqualToString:[response objectForKey:@"status"]]) {
                [self.currentUser setLatestUpdateDateForSet:[response objectForKey:@"last_updated_set"]];
            }
            [self continueCheck];
        }
        NSLog(@"addChartIntoSet: %@",response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    [manager.operationQueue addOperation:operation];
}

-(void)addNewChart:(NSDictionary*)data{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"data": [self dictionaryToString:data],
                             @"chart_id":[data objectForKey:@"chordId"],
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"add"
                             };
    NSError *error;
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        if (response != nil) {
            if ([@"ok" isEqualToString:[response objectForKey:@"status"]]) {
                [self.currentUser setLatesDateForChart:[response objectForKey:@"latest_created_chart"]];
                [self.currentUser setLatestUpdateDateForChart:[response objectForKey:@"last_updated_chart"]];
                NSLog(@"addNewChart: %@",[operation responseString]);
                [self continueCheck];
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)addNewSet:(NSDictionary*)data{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"data": [self dictionaryToString:data],
                             @"setId":[data objectForKey:@"setId"],
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"add"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_SET_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        if (response != nil) {
            if ([@"ok" isEqualToString:[response objectForKey:@"status"]]) {
                [self.currentUser setLatestCreatedSetDate:[response objectForKey:@"latest_created_set"]];
                [self.currentUser setLatestUpdateDateForSet:[response objectForKey:@"last_updated_set"]];
                [self continueCheck];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)getDataForFb {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser realID],
                             @"secret_key":[self.currentUser mySecretKey],
                             @"last_created_date_chart":[self.currentUser latestCreateChartDate],
                             @"last_updated_date_chart":[self.currentUser latestUpdatedChartDate],
                             @"last_created_date_set":[self.currentUser latestCreatedSetDate],
                             @"last_updated_date_set":[self.currentUser latestUpdatedSetDate]
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET"
                                                                      URLString:SERVER_DATA_STRING
                                                                     parameters:params error:&error];
    
    //NSLog(@"%@",[request URL]);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                error:&error];
        if (response != nil)
        {
            if (![@"no data" isEqualToString:[response objectForKey:@"reason"]])
            {
                [self.currentUser setLatesDateForChart:[response objectForKey:@"latest_created_chart"]];
                [self.currentUser setLatestUpdateDateForChart:[response objectForKey:@"last_updated_chart"]];
                [self.currentUser setLatestCreatedDateForSet:[response objectForKey:@"latest_created_set"]];
                [self.currentUser setLatestUpdateDateForSet:[response objectForKey:@"last_updated_set"]];
                
                if (self.checkShare && checkUpdates)
                {
                    [self.delegate notifyAboutSharedData:[response objectForKey:@"data"] andShared:@""];
                }
                else
                {
                    //[self getSharedData];
                    [self.delegate setUserData:[response objectForKey:@"data"]];
                    [self.delegate notifyAboutSharedData:[response objectForKey:@"data"] andShared:@""];
                    [self.delegate hideCover];
                    [self continueCheck];
                }
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)getSharedItemsCount:(void (^)(int result))completionHandler {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *params = @{@"user_id": [self.currentUser realID],
//                             @"secret_key":[self.currentUser mySecretKey],
//                             @"last_created_date_chart":[self.currentUser latestCreateChartDate],
//                             @"last_updated_date_chart":[self.currentUser latestUpdatedChartDate],
//                             @"last_created_date_set":[self.currentUser latestCreatedSetDate],
//                             @"last_updated_date_set":[self.currentUser latestUpdatedSetDate]
//                             };
    NSDictionary *params = @{@"user_id": [self.currentUser realID],
                             @"secret_key":[self.currentUser mySecretKey],
                             @"last_created_date_chart":@"",
                             @"last_updated_date_chart":@"",
                             @"last_created_date_set":@"",
                             @"last_updated_date_set":@""
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET"
                                                                      URLString:SERVER_DATA_STRING
                                                                     parameters:params error:&error];
    
    //NSLog(@"%@",[request URL]);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        if (response != nil)
        {
            NSUInteger chordsShareCount = 0;
            NSUInteger setsShareCount = 0;
            
            if (![@"no data" isEqualToString:[response objectForKey:@"reason"]])
            {
                NSDictionary *data = [response objectForKey:@"data"];
                
                for (NSDictionary *chart in data[@"freeChords"]) {
                    if ([chart[@"share_status"]  isEqual: @"1"])
                         chordsShareCount++;
                }
                
                for (NSDictionary *set in data[@"sets"]) {
                    if ([set[@"share_status"]  isEqual: @"1"])
                        setsShareCount++;
                }

                
            }
            completionHandler((int)(chordsShareCount + setsShareCount));
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)getSharedItems:(void (^)(NSArray *charts, NSArray *sets))completionHandler {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *params = @{@"user_id": [self.currentUser realID],
//                             @"secret_key":[self.currentUser mySecretKey],
//                             @"last_created_date_chart":[self.currentUser latestCreateChartDate],
//                             @"last_updated_date_chart":[self.currentUser latestUpdatedChartDate],
//                             @"last_created_date_set":[self.currentUser latestCreatedSetDate],
//                             @"last_updated_date_set":[self.currentUser latestUpdatedSetDate]
//                             };
    
    NSDictionary *params = @{@"user_id": [self.currentUser realID],
                             @"secret_key":[self.currentUser mySecretKey],
                             @"last_created_date_chart":@"",
                             @"last_updated_date_chart":@"",
                             @"last_created_date_set":@"",
                             @"last_updated_date_set":@""
                             };
    
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET"
                                                                      URLString:SERVER_DATA_STRING
                                                                     parameters:params error:&error];
    
    NSLog(@"%@",[request URL]);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        if (response != nil)
        {
            if (![@"no data" isEqualToString:[response objectForKey:@"reason"]])
            {
                NSDictionary *data = [response objectForKey:@"data"];
                
                [self.currentUser setLatesDateForChart:[response objectForKey:@"latest_created_chart"]];
                [self.currentUser setLatestUpdateDateForChart:[response objectForKey:@"last_updated_chart"]];
                [self.currentUser setLatestCreatedDateForSet:[response objectForKey:@"latest_created_set"]];
                [self.currentUser setLatestUpdateDateForSet:[response objectForKey:@"last_updated_set"]];
                
//                [self.delegate notifyAboutSharedData:[response objectForKey:@"data"] andShared:@""];
                
                NSMutableArray *sharedCharts = [[NSMutableArray alloc] init];
                for (NSDictionary *chart in data[@"freeChords"]) {
                    if ([chart[@"share_status"]  isEqual: @"1"]) {
                        [sharedCharts addObject:chart];
                    }
                }
                
                NSMutableArray *sharedSets = [[NSMutableArray alloc] init];
                for (NSDictionary *set in data[@"sets"]) {
                    if ([set[@"share_status"]  isEqual: @"1"]) {
                        [sharedSets addObject:set];
                    }
                }
                
                completionHandler([sharedCharts copy], [sharedSets copy]);
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}


-(void)acceptChart:(NSString*)chartId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"chartId": chartId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"acceptChart"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successful acceptance of chart %@",chartId);
        
        
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)acceptChart:(NSString*)chartId  completion:(void (^)(BOOL result))completionHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"chartId": chartId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"acceptChart"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successful acceptance of chart %@",chartId);
        completionHandler(TRUE);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        completionHandler(FALSE);
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)acceptSet:(NSString*)setId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"setId": setId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"acceptSet"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_SET_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)acceptSet:(NSString*)setId completion:(void (^)(BOOL result))completionHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"setId": setId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"acceptSet"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_SET_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionHandler(true);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        completionHandler(false);
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)declineChart:(NSString*)chartId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"chartId": chartId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"declineChart"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
    
}

-(void)declineChart:(NSString*)chartId completion:(void (^)(BOOL result))completionHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"chartId": chartId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"declineChart"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionHandler(TRUE);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        completionHandler(FALSE);
    }];
    
    [manager.operationQueue addOperation:operation];
    
}

-(void)declineSet:(NSString*)setId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"setId": setId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"declineSet"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_SET_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)declineSet:(NSString*)setId  completion:(void (^)(BOOL result))completionHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"setId": setId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"declineSet"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_SET_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionHandler(TRUE);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        completionHandler(FALSE);
    }];
    
    [manager.operationQueue addOperation:operation];
}


-(void)updateChord:(NSDictionary*)data withFriends:(NSString*)friends{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"data": [self dictionaryToString:data],
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"update"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        if (response != nil) {
            if ([@"ok" isEqualToString:[response objectForKey:@"status"]]) {
                [self.currentUser setLatestUpdateDateForChart:[response objectForKey:@"last_updated_chart"]];
                [self.currentUser setLatestUpdateDateForSet:[response objectForKey:@"last_updated_set"]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}


-(void)shareChart:(NSString*)chartId withFriends:(NSString*)friends{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"friend_id": friends,
                             @"chord_id":chartId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"share"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_CHART_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)shareSet:(NSString*)setId withFriends:(NSString*)friends {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": [self.currentUser getUserRealID],
                             @"friend_id": friends,
                             @"setId":setId,
                             @"secret_key":[self.currentUser mySecretKey],
                             @"method":@"share"
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_SET_STRING
                                                                     parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
}

-(void)loginUserWithFb:(NSString*)userId{
    usrLoginWith = 0;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"key": userId,
                             @"object":@"authorization",
                             @"deviceToken": @"",
                             @"name": [self.currentUser getFBName]
                             };
    NSError *error;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:SERVER_AUTHORIZATION_STRING
                                                                     parameters:params error:&error];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions
                                                                   error:&error];
        if (response != nil) {
            if ([@"ok" isEqualToString:[response objectForKey:@"status"]]) {
                [self.currentUser setRealID:[response objectForKey:@"user_id"]];
                [self.currentUser setMySecretKey:[response objectForKey:@"secret_key"]];
                [self.currentUser setLatesDateForChart:@""];
                [self.currentUser setLatestCreateChartDate:@""];
                [self.currentUser setLatestUpdateDateForChart:@""];
                [self.currentUser setLatestUpdateDateForSet:@""];
                [self.currentUser setLatestCreatedSetDate:@""];
                [self getDataForFb];
            } else {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:[response objectForKey:@"reason"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error response is: %@", operation.responseString);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [manager.operationQueue addOperation:operation];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.delegate backToLogin];
}


//-(void)bgTask:(NSTimer*)timer {
////    if (checkShare) {
//    NSLog(@"background task firing, ServerUpdater");
//    [self getSharedData];
////    }
//}

-(void)pauseCheck{
    NSLog(@"--------- Pause check for updates");
    //[self setCheckShare:NO];
    //[self setCheckUpdates:NO];
}

-(void)continueCheck{
    NSLog(@" --------- Continue check for updates");
   // [self setCheckShare:YES];
   // [self setCheckUpdates:YES];
}

@end
