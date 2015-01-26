//
//  JsonSetHelper.h
//  app12bar
//
//  Created by Alex on 8/12/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "DBManager.h"
#import "ColorHelper.h"
#import "ServerUpdater.h"

@interface JsonSetHelper : NSObject {
    
}

@property (nonatomic, retain)          User* currentUser;
@property (nonatomic, retain)          ServerUpdater *serverUpdater;

-(void)updateSet:(NSDictionary*)set;

-(void)updateExistingSet:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location;
-(NSString*)doneNewSet:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location;
-(void)passEditedSetToUsers;
-(void)deleteSet;
@end
