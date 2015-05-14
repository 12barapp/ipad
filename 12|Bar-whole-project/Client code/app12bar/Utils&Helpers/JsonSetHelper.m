//
//  JsonSetHelper.m
//  app12bar
//
//  Created by Alex on 8/12/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "JsonSetHelper.h"

@interface JsonSetHelper () {
    DBManager *db;
}

@end

@implementation JsonSetHelper

- (id)init {
    self = [super init];
    if (self) {
        self.currentUser = [User sharedManager];
        db = [DBManager sharedManager];
    }
    return self;
}

- (void)passEditedSetToUsers {
    
}

- (void)updateExistingSet:(NSString *)title artist:(NSString *)artist date:(NSString *)date location:(NSString *)location {
    
}

- (void)deleteSet {
    
}


-(void)updateSet:(NSDictionary*)set{

    [[[ServerUpdater alloc] init] updateSet:set setId:set[@"setId"]];
}

-(NSString*)doneNewSet:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location{
   
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",unixTime];
}




@end
