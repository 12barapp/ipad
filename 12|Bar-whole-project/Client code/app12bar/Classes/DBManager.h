//
//  DBManager.h
//  app12bar
//
//  Created by Alex on 7/1/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "User.h"

@interface DBManager : NSObject<NSXMLParserDelegate, NSURLConnectionDelegate>{
    FMDatabase *db;
    NSXMLParser *xmlParserObject;
    NSData *xmlData;
    
}

@property (nonatomic, retain) FMDatabase *db;
@property (nonatomic, retain) NSString * dbPath;
@property (nonatomic, assign) User *currentUser;
@property (nonatomic, readonly) NSString* DbPath;
@property (nonatomic) int lastSearchCiount;


-(NSString*)DbPath;

-(void)exchangeChart:(NSString*)chartId withChart:(NSString*)chartId2;
-(void)exchangeSet:(NSString*)setId withChart:(NSString*)setId2;

+(DBManager*)sharedManager;
-(void)updateLyrics:(NSMutableArray*)lyrics forChartId:(NSString*)chartId;
-(void)updateNotes:(NSString*)notes forChartId:(NSString*)chartId;
-(void)updateNotes:(NSString*)notes forSetWithId:(NSString*)setId;
-(NSDictionary*)getChartById:(NSString*)chartId;
-(NSDictionary*)getSetWithId:(NSString*)setId;
-(void)setServerId:(NSString*)serverId forChartWithId:(NSString*)chartId;
-(NSMutableArray*)getChordsForSet:(NSString*)setId;
-(void)updateChordOrderInSet:(NSMutableArray *)chords forSet:(NSString *)setID;
-(void)addChart:(NSString*)chartId IntoSet:(NSString*)setId;
-(void)addNewChart:(NSString*)title
            artist:(NSString*)artist
               key:(NSString*)key
          time_sig:(NSString*)time_sig
             genre:(NSString*)genre
               bpm:(NSString*)bpm
             notes:(NSString*)notes
            lyrics:(NSMutableArray*)lirycs
           chartId:(NSString*)chartId
             owner:(NSString*)ownerId;

-(void)updateChart:(NSString*)title
            artist:(NSString*)artist
               key:(NSString*)key
          time_sig:(NSString*)time_sig
             genre:(NSString*)genre
               bpm:(NSString*)bpm
             notes:(NSString*)notes
            lyrics:(NSMutableArray*)lirycs
           chartId:(NSString*)chartId;

-(void)addNewSet:(NSString*)title
          artist:(NSString*)artist
            date:(NSString*)date
        location:(NSString*)location
           notes:(NSString*)notes
          chords:(NSMutableArray*)chords
          withId:(NSString*)setId
           owner:(NSString*)ownerId;

-(void)updateSet:(NSString*)title
          artist:(NSString*)artist
            date:(NSString*)date
        location:(NSString*)location
           notes:(NSString*)notes
          chords:(NSDictionary*)chords
          withId:(NSString*)setId;
-(void)updateChartsWithServerData:(NSMutableArray*)data;
-(void)updateSetsWithServerData:(NSMutableArray*)data;
-(int)countOfSets;
-(int)countOfCharts;
-(void)removeChart:(NSString*)chartId fromSet:(NSString*)setId;
-(void)removeChartWithId:(NSString*)chartId;
-(void)removeSetWithId:(NSString*)setId;
-(NSMutableArray*)getMyChartsWithOrder:(NSString*)orderKey;
-(NSMutableArray*)getMySetsWithOrder:(NSString*)orderKey;
-(NSMutableArray*)findChartWithCriteria:(NSString*)criteria andPhrase:(NSString*)phrase;
-(NSMutableArray*)findSetWithCriteria:(NSString *)criteria andPhrase:(NSString *)phrase;

@end
