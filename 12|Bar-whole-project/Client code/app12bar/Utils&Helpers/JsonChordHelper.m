//
//  JsonChordHelper.m
//  app12bar
//
//  Created by Alex on 8/12/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "JsonChordHelper.h"

@implementation JsonChordHelper

static DBManager *db;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.currentUser = [User sharedManager];
        db = [DBManager sharedManager];
    }
    return self;
}


-(void)updateExistingChordWith:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes transposeIndex:(int)tIndex{
    self.transposer = [[TransposeChordHelper alloc] init];
    NSDictionary *chart = [db getChartById:[self.currentUser chartId]];
    NSMutableArray *lyrics = [NSMutableArray arrayWithArray:chart[@"lyrics"]];
    NSString* oldChordKey  = chart[@"key"];
    
    if (tIndex != 0) {
        if ([lyrics count] > 0) {
            NSDictionary*dc = [[NSDictionary alloc] init];
            
            NSMutableArray *vKeys = [[[TransposeChordHelper alloc] init] getViewForKey:key];
            
            dc = [[lyrics objectAtIndex:0] mutableCopy];
            NSMutableArray *tempArray = [dc[@"cordinates"] mutableCopy];
            NSMutableArray *chordsArray = [tempArray mutableCopy];
            for (int c = 0; c < chordsArray.count; c++){ // transposing chords
                if ([[chordsArray objectAtIndex:c] valueForKey:@"index"] != nil) {
                    int chordIndex = [[[chordsArray objectAtIndex:c] valueForKey:@"index"] intValue];
                    if (chordIndex >= 0) {
                        NSArray *subst = [[self.transposer chordTranspose:[[chordsArray objectAtIndex:c] valueForKey:@"key_char"] fromKey:oldChordKey toKey:key] matches:RX(@"[^b#][#b]?")];
                        NSString* updatedChord = subst[0];
                        NSDictionary* someD = [[chordsArray objectAtIndex:c] mutableCopy];
                        [someD setValue:updatedChord forKey:@"key_char"];
                        if ([[chordsArray objectAtIndex:c] valueForKey:@"custom"] != nil) {
                            if (![[[chordsArray objectAtIndex:c] valueForKey:@"custom"] isEqualToString:@"1"]) {                                
                                [someD setValue:[[vKeys objectAtIndex:chordIndex] valueForKey:@"modifier"] forKey:@"metadata"];
                            }
                        }else
                        [someD setValue:subst[1] forKey:@"metadata"];
                        [chordsArray replaceObjectAtIndex:c withObject:someD];
                    }
                }
            }
            [dc setValue:chordsArray forKey:@"cordinates"];
            [lyrics replaceObjectAtIndex:0 withObject:dc];
        }
    }
    if (lyrics == nil) {
        lyrics = [[NSMutableArray alloc] init];
    }
    [db updateChart:title artist:artist key:key time_sig:time_sig genre:genre bpm:bpm notes:notes lyrics:lyrics chartId:[self.currentUser chartId]];
}

-(time_t)doneNewChord:(NSString*)title artist:(NSString*)artist key:(NSString*)key time_sig:(NSString*)time_sig genre:(NSString*)genre bpm:(NSString*)bpm notes:(NSString*)notes setId:(NSString*)setId{
     time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
   
    return unixTime; // returns chord id
}



@end
