//
//  JsonChordHelper.h
//  app12bar
//
//  Created by Alex on 8/12/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "DBManager.h"
#import "TransposeChordHelper.h"
#import "ColorHelper.h"
#import "ServerUpdater.h"

@interface JsonChordHelper : NSObject

@property (nonatomic, retain)          User* currentUser;
@property (nonatomic, retain)          TransposeChordHelper* transposer;

-(void)updateExistingChordWith:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes transposeIndex:(int)tIndex;
-(time_t)doneNewChord:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes setId:(NSString*)setId;

@end
