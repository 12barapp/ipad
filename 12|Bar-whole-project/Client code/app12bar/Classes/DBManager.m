//
//  DBManager.m
//  app12bar
//
//  Created by Alex on 7/1/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
@synthesize db, dbPath, DbPath;

#define DB_NAME @"twelvebar.sqlite"

static DBManager *instance=nil;

-(id)init {
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
    DbPath = defaultDBPath;
    if (self=[super init]) {
        NSLog(@"%@",self.DbPath);
        [self createEditableCopyOfDatabaseIfNeeded:self.DbPath];
        self.db = [[FMDatabase alloc ] initWithPath:self.DbPath];
        [db setShouldCacheStatements:YES];
        if (![db open]) {
            if ([db hadError]) {
                NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Error" message:[db lastErrorMessage] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            FMResultSet *results = [db executeQuery:@"select * from jsonTable"];
            if(results && [results next]) {
                
            }
            [results close];
        }
    }
    self.currentUser = [User sharedManager];
    return self;
}

-(NSString*)DbPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	if (![documentsDirectory hasSuffix:@"/"]) {
		documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
	}
	//Create the complete path to the database file.
    return [documentsDirectory stringByAppendingString:DB_NAME];
}

- (void)createEditableCopyOfDatabaseIfNeeded:(NSString*)mydbPath {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:mydbPath];
    if (success) return;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:0 forKey:@"version"];
    NSError* error;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
    
    success = [fileManager copyItemAtPath:defaultDBPath toPath:mydbPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


-(NSDictionary*)getChartById:(NSString*)chartId{
    NSMutableDictionary *chart = [[NSMutableDictionary alloc] init];
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select * from chords where chartId = \'%@\'", chartId]];
    if(results ) {
         while([results next]){
            [chart setValue:[results stringForColumn:@"title"] forKey:@"cTitle"];
            [chart setValue:[results stringForColumn:@"time"] forKey:@"time_sig"];
            [chart setValue:[results stringForColumn:@"notes"] forKey:@"notes"];
            [chart setValue:[results stringForColumn:@"key"] forKey:@"key"];
            [chart setValue:[results stringForColumn:@"bpm"] forKey:@"bpm"];
            [chart setValue:[results stringForColumn:@"genre"] forKey:@"genre"];
            [chart setValue:[results stringForColumn:@"chartId"] forKey:@"chordId"];
            [chart setValue:[results stringForColumn:@"serverId"] forKey:@"serverId"];
             NSError *jsonError;
             NSData *objectData = [[results stringForColumn:@"lyrics"] dataUsingEncoding:NSUTF8StringEncoding];
             [chart setValue:[NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError] forKey:@"lyrics"];
            [chart setValue:[results stringForColumn:@"artist"] forKey:@"artist"];
            [chart setValue:[results stringForColumn:@"owner"] forKey:@"owner"];
         }
    }
    [results close];
    return chart;
}

-(NSDictionary*)getSetWithId:(NSString*)setId{
    NSMutableDictionary *set = [[NSMutableDictionary alloc] init];
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select * from sets where setId = \'%@\'", setId]];
    if(results ) {
        while([results next]){
            [set setValue:[results stringForColumn:@"title"] forKey:@"title"];
            [set setValue:[results stringForColumn:@"date"] forKey:@"date"];
            [set setValue:[results stringForColumn:@"notes"] forKey:@"notes"];
            [set setValue:[results stringForColumn:@"location"] forKey:@"location"];
            [set setValue:[results stringForColumn:@"artist"] forKey:@"artist"];
            [set setValue:[NSString stringWithFormat:@"%d",[results intForColumn:@"serverId"]] forKey:@"serverId"];
            [set setValue:[results stringForColumn:@"setId"] forKey:@"setId"];
            [set setValue:[results stringForColumn:@"artist"] forKey:@"artist"];
            [set setValue:[results stringForColumn:@"owner"] forKey:@"owner"];
        }
    }
    [results close];
    return set;
}

-(void)addChart:(NSString*)chartId IntoSet:(NSString*)setId{
    [self.db executeUpdate:[NSString stringWithFormat:@"insert into chords_inside_sets (chord_id, set_id, order_number) values(\'%@\',\'%@\', (select count(order_number)+1 from chords_inside_sets where set_id=\'%@\'))", chartId, setId, setId]];
}

-(NSMutableArray*)getChordsForSet:(NSString*)setId{
    NSMutableArray *chordsForSet = [[NSMutableArray alloc] init];
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select DISTINCT cis.chord_id, ch.chartId as chartId, cis.order_number as order_number from chords_inside_sets cis, chords ch where cis.chord_id=ch.chartId and cis.set_id=\'%@\' order by cis.order_number", setId]];
    if(results ) {
        while([results next]){
            
            NSMutableDictionary *oneChart = [[NSMutableDictionary alloc] init];
            [oneChart setValue:[results stringForColumn:@"chartId"] forKey:@"chordId"];
            [oneChart setValue:[results stringForColumn:@"order_number"] forKey:@"order_number"];
            [chordsForSet addObject:oneChart];
        }
    }
    [results close];
    return chordsForSet;
}

-(void)updateChordOrderInSet:(NSMutableArray *)chords forSet:(NSString *)setID {
    for (NSMutableDictionary *chord in chords) {
        NSString *chordID = [chord objectForKey:@"chordId"];
        NSString *orderNumber = [chord objectForKey:@"order_number"];
        [db executeUpdate:[NSString stringWithFormat:@"UPDATE chords_inside_sets SET order_number = %@ where set_id = \'%@\' and chord_id = \'%@\'", orderNumber, setID, chordID]];
    }
}

-(void)exchangeSet:(NSString*)setId withChart:(NSString*)setId2{
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select order_number from sets where setId=\'%@\'", setId]];
    NSString *setOne = @"";
    NSString *setTwo = @"";
    if(results ) {
        while([results next]){
            setOne = [results stringForColumn:@"order_number"];
        }
    }
    [results close];
    results = [db executeQuery:[NSString stringWithFormat:@"select order_number from sets where setId=\'%@\'", setId2]];
    if(results ) {
        while([results next]){
            setTwo = [results stringForColumn:@"order_number"];
        }
    }
    [results close];
    [self.db executeUpdate:[NSString stringWithFormat:@"update sets SET order_number = \'%@\' where setId=\'%@\'", @"-1", setId2]];
    [self.db executeUpdate:[NSString stringWithFormat:@"update sets SET order_number = \'%@\' where setId=\'%@\'", setTwo, setId]];
    [self.db executeUpdate:[NSString stringWithFormat:@"update sets SET order_number = \'%@\' where setId=\'%@\'", setOne, setId2]];
}

-(void)exchangeChart:(NSString*)chartId withChart:(NSString*)chartId2{
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select order_number from chords where chartId=\'%@\'", chartId]];
    NSString *chartOne = @"";
    NSString *chartTwo = @"";
    if(results ) {
        while([results next]){
            chartOne = [results stringForColumn:@"order_number"];
        }
    }
    [results close];
    results = [db executeQuery:[NSString stringWithFormat:@"select order_number from chords where chartId=\'%@\'", chartId2]];
    if(results ) {
        while([results next]){
            chartTwo = [results stringForColumn:@"order_number"];
        }
    }
    [results close];
    [self.db executeUpdate:[NSString stringWithFormat:@"update chords SET order_number = \'%@\' where chartId=\'%@\'", @"-1", chartId2]];
    [self.db executeUpdate:[NSString stringWithFormat:@"update chords SET order_number = \'%@\' where chartId=\'%@\'", chartTwo, chartId]];
    [self.db executeUpdate:[NSString stringWithFormat:@"update chords SET order_number = \'%@\' where chartId=\'%@\'", chartOne, chartId2]];
    
}

-(NSMutableArray*)getMyChartsWithOrder:(NSString*)orderKey{
    NSMutableArray *myCharts = [[NSMutableArray alloc] init];
    //NSLog(@"%@",[NSString stringWithFormat:@"select DISTINCT  chartId, title from chords where user_id=\'%@\' OR user_id='free' ORDER BY \'%@\'", [self.currentUser userId], orderKey]);
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select DISTINCT  chartId, title from chords where user_id=\'%@\' OR user_id='free' ORDER BY %@", [self.currentUser userId], orderKey]];
    
    int currentChordNum = 0;
    int cntOfChords = 0;
    int allCharts = [self countOfCharts];
    NSMutableArray *tempChartTitles = [NSMutableArray arrayWithArray:[self fiveOfA]];
    NSMutableArray *tempChartIds = [NSMutableArray arrayWithArray:[self fiveOfA]];
    if ( allCharts > 0) {
        if(results ) {
            while([results next]){
                
                //NSLog(@"%@",[results stringForColumn:@"title"]);
                
                [tempChartTitles addObject:[results stringForColumn:@"title"]];
                [tempChartIds addObject:[results stringForColumn:@"chartId"]];
                currentChordNum++;
                cntOfChords ++;
                if ((currentChordNum == 35) || cntOfChords == allCharts ){
                    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:tempChartTitles,@"data",tempChartIds,@"id", nil];
                    [myCharts addObject:d];
                    tempChartTitles = [NSMutableArray arrayWithArray:[self fiveOfA]];
                    tempChartIds = [NSMutableArray arrayWithArray:[self fiveOfA]];
                    currentChordNum = 0;
                }
            }
            
        }
    } else {
        NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:tempChartTitles,@"data",tempChartIds,@"id", nil];
        [myCharts addObject:d];
    }
    
    [results close];
    return myCharts;
}

-(void)setServerId:(NSString*)serverId forChartWithId:(NSString*)chartId{
     [self.db executeUpdate:[NSString stringWithFormat:@"update chords SET serverId = \'%@\' where chartId=\'%@\'", serverId, chartId]];
}

-(NSMutableArray*)getMySetsWithOrder:(NSString*)orderKey{
    NSMutableArray *mySets = [[NSMutableArray alloc] init];
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select DISTINCT  setId, title from sets where user_id=\'%@\' OR user_id='free' ORDER BY %@",[self.currentUser userId] ,orderKey]];
    NSMutableArray *tempSetTitles = [NSMutableArray arrayWithArray:[self fiveOfA]];
    NSMutableArray *tempSetIds = [NSMutableArray arrayWithArray:[self fiveOfA]];
    int currentSetNum = 0;
    int cntOfSets = 0;
    int countOfAllSets = [self countOfSets];
    if ( countOfAllSets > 0) {
        if(results) {
            while([results next]){
                [tempSetTitles addObject:[results stringForColumn:@"title"]];
                [tempSetIds addObject:[results stringForColumn:@"setId"]];
                currentSetNum++;
                cntOfSets++;
                if ((currentSetNum == 34) || (cntOfSets == countOfAllSets)) {
                    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:tempSetTitles,@"data",tempSetIds,@"id", nil];
                    [mySets addObject:d];
                    tempSetTitles = [NSMutableArray arrayWithArray:[self fiveOfA]];
                    tempSetIds = [NSMutableArray arrayWithArray:[self fiveOfA]];
                    currentSetNum = 0;
                }
             }
        }
    } else {
        NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:tempSetTitles,@"data",tempSetIds,@"id", nil];
        [mySets addObject:d];
    }
    [results close];
    return mySets;
}

-(int)countOfSets{
    FMResultSet *countOfSetsResult = [db executeQuery:[NSString stringWithFormat:@"select COUNT(DISTINCT setId) as cnt from sets where user_id=\'%@\' OR user_id='free'", [self.currentUser userId]]];
    int countOfSets = 0;
    if (countOfSetsResult && [countOfSetsResult next]){
        countOfSets = [countOfSetsResult intForColumn:@"cnt"];
    }
    [countOfSetsResult close];
    return countOfSets;
}

-(int)countOfCharts{
    FMResultSet *countOfChartsResult = [db executeQuery:[NSString stringWithFormat:@"select COUNT(DISTINCT chartId) as cnt from chords where user_id=\'%@\' or user_id=\'free\'", [self.currentUser userId]]];
    int countOfChords = 0;
    if(countOfChartsResult && [countOfChartsResult next]) {
        countOfChords = [countOfChartsResult intForColumn:@"cnt"];
    }
    [countOfChartsResult close];
    return countOfChords;
}

-(NSArray*)fiveOfA {
    return @[@"A",@"A",@"A",@"A",@"A"];
}

-(void)addNewChart:(NSString*)title
            artist:(NSString*)artist
               key:(NSString*)key
          time_sig:(NSString*)time_sig
             genre:(NSString*)genre
               bpm:(NSString*)bpm
             notes:(NSString*)notes
            lyrics:(NSMutableArray*)lirycs
           chartId:(NSString*)chartId
             owner:(NSString*)ownerId {
    NSError *error;
    if (notes == nil || [@"" isEqualToString:notes ]) {
        notes = @" ";
    }

    title = [title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    artist = [artist stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:lirycs options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self.db executeUpdate:[NSString stringWithFormat:@"insert into chords (title, key, artist, bpm, time, lyrics, genre, chartId, owner, user_id) values(\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\', \'%@\')", title, key, artist, bpm, time_sig, jsonString, genre,chartId, ownerId, [self.currentUser userId]]];
}

-(void)addNewSet:(NSString*)title
          artist:(NSString*)artist
            date:(NSString*)date
        location:(NSString*)location
           notes:(NSString*)notes
          chords:(NSMutableArray*)chords
          withId:(NSString*)setId
           owner:(NSString*)ownerId {
    
    title = [title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    artist = [artist stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    location = [location stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    [self.db executeUpdate:[NSString stringWithFormat:@"insert into sets (title, setId, artist, date, location, notes, owner, user_id) values(\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\', \'%@\')", title, setId,artist, date, location, notes, ownerId, [self.currentUser userId]]];
    
    for (int i = 0; i < [chords count]; i++) {
        [self addChart:[chords objectAtIndex:i][@"chordId"] IntoSet:setId];
    }
}

-(void)updateChart:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes lyrics:(NSMutableArray*)lirycs chartId:(NSString*)chartId{
    if (notes == nil || [@"" isEqualToString:notes ]) {
        notes = @" ";
    }
    [self.db executeUpdate:[NSString stringWithFormat:@"update chords SET title = \'%@\', artist= \'%@\', time=\'%@\', notes=\'%@\', genre=\'%@\', key=\'%@\', bpm=\'%@\', lyrics=\'%@\' where chartId=\'%@\'", title, artist, time_sig, notes, genre, key,bpm, [self mutableArrayToString:lirycs], chartId]];
}

-(NSString*)dictionaryToString:(NSDictionary*)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

-(NSString*)mutableArrayToString:(NSMutableArray*)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

-(void)updateSetsWithServerData:(NSMutableArray*)data{
    for (int i = 0; i < data.count; i++) {
        NSDictionary* tempSet = [data objectAtIndex:i];
        BOOL updated = false;
        [self.db executeUpdate:[NSString stringWithFormat:@"delete from chords_inside_sets where set_id = \'%@\' ", tempSet[@"setId"]]];
        [self.db executeUpdate:[NSString stringWithFormat:@"delete from sets where setId = \'%@\' ", tempSet[@"setId"]]];
        if ([[self getSetWithId:tempSet[@"setId"]] count] == 0){
            [self addNewSet:tempSet[@"title"] artist:tempSet[@"artist"] date:tempSet[@"date"] location:tempSet[@"location"] notes:tempSet[@"notes"] chords:tempSet[@"chords"] withId:tempSet[@"setId"]owner:tempSet[@"owner"]];
                NSMutableArray *setChords = tempSet[@"chords"];
            
            for (int j = 0; j < setChords.count; j++) {
                [self addChart:[setChords objectAtIndex:j][@"chordId"] IntoSet:tempSet[@"setId"]];
            }
        } else {
             updated = [self.db executeUpdate:[NSString stringWithFormat:@"update sets SET title = \'%@\', artist=\'%@\', date=\'%@\', location=\'%@\', serverId=\'%@\', notes=\'%@\' where setId=\'%@\'", tempSet[@"title"], tempSet[@"artist"], tempSet[@"date"], tempSet[@"location"],tempSet[@"serverId"], tempSet[@"notes"],tempSet[@"setId"]]];
            NSMutableArray *setChords = tempSet[@"chords"];
            
          //
            
            if (setChords.count > 0)
            for (int j = 0; j < setChords.count; j++) {
                [self addChart:[setChords objectAtIndex:j][@"chordId"] IntoSet:tempSet[@"setId"]];
            }
        }
    }
}

-(void)updateChartsWithServerData:(NSMutableArray*)data{
    for (int i = 0; i < data.count; i++) {
        NSDictionary* tempChart = [data objectAtIndex:i];
        BOOL updated = false;
        if ([[tempChart allKeys] count] > 10) {
            NSString *chartTitle = @"";
            if ([[tempChart allKeys] containsObject:@"title"]) {
                chartTitle = tempChart[@"title"];
            } else {
                chartTitle = tempChart[@"cTitle"];
            }
            NSDictionary *dbChart = [self getChartById:tempChart[@"chordId"]];
            if ([dbChart count] == 0) {
                NSString* chartOwner = tempChart[@"owner"];
                [self addNewChart:chartTitle artist:tempChart[@"artist"] key:tempChart[@"key"] time_sig:tempChart[@"time_sig"] genre:tempChart[@"genre"] bpm:tempChart[@"bpm"] notes:tempChart[@"notes"] lyrics:tempChart[@"lyrics"] chartId:tempChart[@"chordId"]owner:chartOwner];
            }else {
                NSString *chartTitle = @"";
                if ([[tempChart allKeys] containsObject:@"title"]) {
                    chartTitle = tempChart[@"title"];
                } else {
                    chartTitle = tempChart[@"cTitle"];
                }
                updated = [self.db executeUpdate:[NSString stringWithFormat:@"update chords SET title = \'%@\', artist= \'%@\', time=\'%@\', notes=\'%@\', genre=\'%@\', key=\'%@\', bpm=\'%@\', lyrics=\'%@\', created=\'%@\', serverId= \'%@\',last_updated_time=\'%@\' where (datetime(last_updated_time) < datetime(\'%@\') OR last_updated_time IS NULL) and chartId=\'%@\'",
                                                       chartTitle,
                                                       tempChart[@"artist"],
                                                       tempChart[@"time_sig"],
                                                       tempChart[@"notes"],
                                                       tempChart[@"genre"],
                                                       tempChart[@"key"],
                                                       tempChart[@"bpm"],
                                                       [self mutableArrayToString:tempChart[@"lyrics"]],
                                                       tempChart[@"serverId"],
                                                       tempChart[@"created"],
                                                       tempChart[@"last_updated_time"],
                                                       tempChart[@"last_updated_time"],
                                                       tempChart[@"chordId"]]];
            }
            
        }
       
    }
}

-(void)updateNotes:(NSString*)notes forSetWithId:(NSString*)setId{
    [self.db executeUpdate:[NSString stringWithFormat:@"update sets SET notes = \'%@\' where setId=\'%@\'",notes , setId]];
}

-(void)updateNotes:(NSString*)notes forChartId:(NSString*)chartId{
     [self.db executeUpdate:[NSString stringWithFormat:@"update chords SET notes = \'%@\' where chartId=\'%@\'",notes , chartId]];
}

-(void)updateSet:(NSString*)title artist:(NSString*)artist date:(NSString*)date location:(NSString*)location notes:(NSString*)notes chords:(NSDictionary*)chords withId:(NSString*)setId {
    [self.db executeUpdate:[NSString stringWithFormat:@"update sets SET title = \'%@\', artist=\'%@\', date=\'%@\', location=\'%@\' where setId=\'%@\'", title, artist, date, location, setId]];
    
}

-(void)updateLyrics:(NSMutableArray*)lyrics forChartId:(NSString*)chartId{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:lyrics options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self.db executeUpdate:[NSString stringWithFormat:@"update chords SET lyrics = \'%@\' where chartId=\'%@\'", jsonString, chartId]];
}

-(void)removeChart:(NSString*)chartId fromSet:(NSString*)setId{
    [self.db executeUpdate:[NSString stringWithFormat:@"delete from chords_inside_sets where chord_id=\'%@\' and set_id=\'%@\'", chartId, setId]];
}

-(void)removeChartWithId:(NSString*)chartId{
    [self.db executeUpdate:[NSString stringWithFormat:@"delete from chords where chartId=\'%@\'", chartId]];
    [self.db executeUpdate:[NSString stringWithFormat:@"delete from chords_inside_sets where chord_id=\'%@\'", chartId]];
}

-(void)removeSetWithId:(NSString*)setId{
    [self.db executeUpdate:[NSString stringWithFormat:@"delete from sets where setId=\'%@\'", setId]];
    [self.db executeUpdate:[NSString stringWithFormat:@"delete from chords_inside_sets where set_id=\'%@\'", setId]];
}

-(NSMutableArray*)findSetWithCriteria:(NSString *)criteria andPhrase:(NSString *)phrase{
    NSMutableArray *searchResult = [[NSMutableArray alloc] init];
    NSString *searchField = @"title";
    if ([criteria isEqualToString:@"author"]) {
        searchField = @"artist";
    } else {
        searchField = criteria;
    }
    
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select * from sets where `%@` LIKE \'%%%@%%\'", searchField, phrase]];
    NSLog(@"Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    int currentChordNum = 0;
    int cntOfChords = 0;
    int allCharts = [self getCountOfSetSearch:searchField andPhrase:phrase];
    NSMutableArray *tempChartTitles = [NSMutableArray arrayWithArray:[self fiveOfA]];
    NSMutableArray *tempChartIds = [NSMutableArray arrayWithArray:[self fiveOfA]];
    if (allCharts > 0) {
        if(results) {
            while([results next]){
                [tempChartTitles addObject:[results stringForColumn:@"title"]];
                [tempChartIds addObject:[results stringForColumn:@"setId"]];
                currentChordNum++;
                cntOfChords ++;
                if ((currentChordNum == 35) || cntOfChords == allCharts ){
                    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:tempChartTitles,@"data",tempChartIds,@"id", nil];
                    [searchResult addObject:d];
                    tempChartTitles = [NSMutableArray arrayWithArray:[self fiveOfA]];
                    tempChartIds = [NSMutableArray arrayWithArray:[self fiveOfA]];
                    currentChordNum = 0;
                }
            }
        }
    } else {
        NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:tempChartTitles,@"data",tempChartIds,@"id", nil];
        [searchResult addObject:d];
    }
    [results close];

    return searchResult;
}

-(int)getCountOfSetSearch:(NSString*)searchField_ andPhrase:(NSString*)phrase{
    int res = 0;
    NSString *searchField = @"title";
    if ([searchField_ isEqualToString:@"author"]) {
        searchField = @"artist";
    } else {
        searchField = searchField_;
    }
     FMResultSet *resultsCoun = [db executeQuery:[NSString stringWithFormat:@"select COUNT(*) as cnt from sets where %@ LIKE \'%%%@%%\'", searchField, phrase]];
    if (resultsCoun && [resultsCoun next])
        res = [resultsCoun intForColumn:@"cnt"];
    [resultsCoun close];
    self.lastSearchCiount = res;
    return res;
}

-(int)getCountOfChartSearch:(NSString*)searchField_ andPhrase:(NSString*)phrase{
    NSString *searchField = @"title";
    if ([searchField_ isEqualToString:@"author"]) {
        searchField = @"artist";
    } else {
        searchField = searchField_;
    }
    FMResultSet *resultsCoun = [db executeQuery:[NSString stringWithFormat:@"select COUNT(*) as cnt from chords where %@ LIKE \'%%%@%%\'", searchField, phrase]];
    int res = 0;
    if (resultsCoun && [resultsCoun next])
        res = [resultsCoun intForColumn:@"cnt"];
    [resultsCoun close];
    self.lastSearchCiount = res;
    return res;
}

-(NSMutableArray*)findChartWithCriteria:(NSString*)criteria andPhrase:(NSString*)phrase{
    NSMutableArray *searchResult = [[NSMutableArray alloc] init];
    NSString *searchField = @"title";
    if ([criteria isEqualToString:@"author"]) {
        searchField = @"artist";
    } else {
        searchField = criteria;
    }

    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"select * from chords where `%@` LIKE \'%%%@%%\'", searchField, phrase]];
    NSLog(@"Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    int currentChordNum = 0;
    int cntOfChords = 0;
    int allCharts = [self getCountOfChartSearch:searchField andPhrase:phrase];
    NSMutableArray *tempChartTitles = [NSMutableArray arrayWithArray:[self fiveOfA]];
    NSMutableArray *tempChartIds = [NSMutableArray arrayWithArray:[self fiveOfA]];
    if (allCharts > 0) {
        if(results) {
            while([results next]){
                [tempChartTitles addObject:[results stringForColumn:@"title"]];
                [tempChartIds addObject:[results stringForColumn:@"chartId"]];
                currentChordNum++;
                cntOfChords ++;
                if ((currentChordNum == 35) || cntOfChords == allCharts ){
                    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:tempChartTitles,@"data",tempChartIds,@"id", nil];
                    [searchResult addObject:d];
                    tempChartTitles = [NSMutableArray arrayWithArray:[self fiveOfA]];
                    tempChartIds = [NSMutableArray arrayWithArray:[self fiveOfA]];
                    currentChordNum = 0;
                }
            }
        }
    } else {
        NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:tempChartTitles,@"data",tempChartIds,@"id", nil];
        [searchResult addObject:d];
    }
    [results close];
    return searchResult;
}



+(DBManager*)sharedManager {
    if (instance==nil) {
        instance = [[DBManager alloc] init];
    }
    return instance;
}

@end
