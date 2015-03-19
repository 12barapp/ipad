//
//  TransposeChordHelper.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "TransposeChordHelper.h"

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )

@implementation TransposeChordHelper

-(id)init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(NSDictionary*)createChord:(NSString*)chord withModifier:(NSString*)modifier andColor:(NSString*)color{
    return [NSDictionary dictionaryWithObjectsAndKeys:chord,@"chord",modifier,@"modifier",color,@"color",nil];
}

-(NSMutableArray*)getViewForKey:(NSString*)key{
    NSMutableArray *viewPalette = [[NSMutableArray alloc] init];
    SWITCH(key){
        CASE(@"C"){
            [viewPalette addObject:[self createChord:@"C#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"D#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"" andColor:@"#F14545"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"m" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"m" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"m" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"dim" andColor:@"#F46F71"]];
            break;
        }
        CASE(@"C#"){
            [viewPalette addObject:[self createChord:@"C#" withModifier:@"" andColor:@"#F14545"]];
            [viewPalette addObject:[self createChord:@"D#" withModifier:@"m" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"F#" withModifier:@"" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"A#" withModifier:@"m" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"dim" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"m" andColor:@"#F46F71"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@"#F8A6A8"]];
            break;
        }
        CASE(@"D"){
            [viewPalette addObject:[self createChord:@"C#" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#F04445"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"m" andColor:@"#EF6D6F"]];
            break;
        }
        CASE(@"Eb"){
            [viewPalette addObject:[self createChord:@"Db" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Eb" withModifier:@"" andColor:@"#F14545"]];
            [viewPalette addObject:[self createChord:@"Gb" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Ab" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Bb" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@"#F8A6A8"]];
            break;
        }
        CASE(@"E"){
            [viewPalette addObject:[self createChord:@"C#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D#" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"F#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"A#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@"#EF6D6F"]];
            break;
        }
        CASE(@"F"){
            [viewPalette addObject:[self createChord:@"Db" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Eb" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Gb" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Ab" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Bb" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@"#F8A6A8"]];
            break;
        }
        CASE(@"F#"){
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"F#" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"A#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@"#EF6D6F"]];
            break;
        }
        CASE(@"G"){
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"D#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F#" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"m" andColor:@"#EF6D6F"]];
            break;
        }
        
        CASE(@"Cb"){
            [viewPalette addObject:[self createChord:@"Db" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Eb" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Gb" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Ab" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Db" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Cb" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Eb" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"dim" andColor:@"#F8A6A8"]];
        }
        
        CASE(@"A"){
            [viewPalette addObject:[self createChord:@"C#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"A#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"m" andColor:@"#EF6D6F"]];
            break;
        }
        CASE(@"Bb"){
            [viewPalette addObject:[self createChord:@"Db" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Eb" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Gb" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Ab" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Bb" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@"#F8A6A8"]];
            break;
        }
        CASE(@"B"){
            [viewPalette addObject:[self createChord:@"C#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"F#" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"A#" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@"#EC4344"]];
            break;
        }
        CASE(@"Db"){
            [viewPalette addObject:[self createChord:@"Db" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"Eb" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Gb" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Ab" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Bb" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@"#F8A6A8"]];
            break;
        }
        CASE(@"Gb"){
            [viewPalette addObject:[self createChord:@"Db" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Eb" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Gb" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"Ab" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Bb" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@"#EF6D6F"]];
            break;
        }
        CASE(@"Ab"){
            [viewPalette addObject:[self createChord:@"Db" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Eb" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"Gb" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"Ab" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"Bb" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"dim" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@"#F8A6A8"]];
            break;
        }
        CASE(@"G#"){
            [viewPalette addObject:[self createChord:@"C#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"D#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"F#" withModifier:@"m" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"dim" andColor:@"#DC3F3F"]];
            [viewPalette addObject:[self createChord:@"A#" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@"#EF6D6F"]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"" andColor:@"#F8A6A8"]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"" andColor:@"#EC4344"]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"m" andColor:@"#EF6D6F"]];
            break;
        }
        CASE(@"Cb"){
            [viewPalette addObject:[self createChord:@"C#" withModifier:@"" andColor:@""]];
            [viewPalette addObject:[self createChord:@"Eb" withModifier:@"" andColor:@""]];
            [viewPalette addObject:[self createChord:@"F#" withModifier:@"" andColor:@""]];
            [viewPalette addObject:[self createChord:@"G#" withModifier:@"" andColor:@""]];
            [viewPalette addObject:[self createChord:@"Bb" withModifier:@"" andColor:@""]];
            [viewPalette addObject:[self createChord:@"C" withModifier:@"m" andColor:@""]];
            [viewPalette addObject:[self createChord:@"D" withModifier:@"m" andColor:@""]];
            [viewPalette addObject:[self createChord:@"E" withModifier:@"" andColor:@""]];
            [viewPalette addObject:[self createChord:@"F" withModifier:@"" andColor:@""]];
            [viewPalette addObject:[self createChord:@"G" withModifier:@"m" andColor:@""]];
            [viewPalette addObject:[self createChord:@"A" withModifier:@"dim" andColor:@""]];
            [viewPalette addObject:[self createChord:@"B" withModifier:@"" andColor:@""]];
            break;
        }
    }
    return viewPalette;
}

-(NSString*)chordTranspose:(NSString*)chord fromKey:(NSString*)key1 toKey:(NSString*)key2{
    
    NSArray *arrA;
    NSArray *arrB;
    
    if (![key1 isEqualToString:key2]) {
        SWITCH(key1){
            CASE(@"A"){
                arrA = @[@"A", @"A#", @"B", @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#"];
                break;
            }
            CASE(@"Bb"){
                arrA = @[@"Bb", @"B", @"C", @"Db", @"D", @"Eb", @"E", @"F", @"Gb", @"G", @"Ab", @"A"];
                break;
            }
            CASE(@"B"){
                arrA = @[@"B", @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#"];
                break;
            }
            CASE(@"C"){
                arrA = @[@"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B"];
                break;
            }
            CASE(@"C#"){
                arrA = @[@"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", @"C"];
                break;
            }
            CASE(@"Db"){
                arrA = @[@"Db", @"D", @"Eb", @"E", @"F", @"Gb", @"G", @"Ab", @"A", @"Bb", @"B", @"C"];
                break;
            }
            CASE(@"D"){
                arrA = @[@"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", @"C", @"C#"];
                break;
            }
            CASE(@"Eb"){
                arrA = @[@"Eb", @"E", @"F", @"Gb", @"G", @"Ab", @"A", @"Bb", @"B", @"C", @"Db", @"D"];
                break;
            }
            CASE(@"E"){
                arrA = @[@"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", @"C", @"C#", @"D", @"D#"];
                break;
            }
            CASE(@"F"){
                arrA = @[@"F", @"Gb", @"G", @"Ab", @"A", @"Bb", @"B", @"C", @"Db", @"D", @"Eb", @"E"];
                break;
            }
            CASE(@"F#"){
                arrA = @[@"F#", @"G", @"G#", @"A", @"A#", @"B", @"C", @"C#", @"D", @"D#", @"E", @"F"];
                break;
            }
            CASE(@"Gb"){
                arrA = @[@"Gb" ,@"G", @"Ab", @"A", @"Bb", @"B", @"C", @"Db", @"D", @"Eb", @"E", @"F"];
                break;
            }
            CASE(@"G"){
                arrA = @[@"G" ,@"G#", @"A", @"A#", @"B", @"C", @"C#", @"D", @"Eb", @"E", @"F", @"F#"];
                break;
            }
            CASE(@"Ab"){
                arrA = @[@"Ab" ,@"A", @"Bb", @"B", @"C", @"Db", @"D", @"Eb", @"E", @"F", @"Gb", @"G"];
                break;
            }
        }
        
        SWITCH(key2){
            CASE(@"A"){
                arrB = @[@"A", @"A#", @"B", @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#"];
                break;
            }
            CASE(@"Bb"){
                arrB = @[@"Bb", @"B", @"C", @"Db", @"D", @"Eb", @"E", @"F", @"Gb", @"G", @"Ab", @"A"];
                break;
            }
            CASE(@"B"){
                arrB = @[@"B", @"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#"];
                break;
            }
            CASE(@"C"){
                arrB = @[@"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B"];
                break;
            }
            CASE(@"C#"){
                arrB = @[@"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", @"C"];
                break;
            }
            CASE(@"Db"){
                arrB = @[@"Db", @"D", @"Eb", @"E", @"F", @"Gb", @"G", @"Ab", @"A", @"Bb", @"B", @"C"];
                break;
            }
            CASE(@"D"){
                arrB = @[@"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", @"C", @"C#"];
                break;
            }
            CASE(@"Eb"){
                arrB = @[@"Eb", @"E", @"F", @"Gb", @"G", @"Ab", @"A", @"Bb", @"B", @"C", @"Db", @"D"];
                break;
            }
            CASE(@"E"){
                arrB = @[@"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", @"C", @"C#", @"D", @"D#"];
                break;
            }
            CASE(@"F"){
                arrB = @[@"F", @"Gb", @"G", @"Ab", @"A", @"Bb", @"B", @"C", @"Db", @"D", @"Eb", @"E"];
                break;
            }
            CASE(@"F#"){
                arrB = @[@"F#", @"G", @"G#", @"A", @"A#", @"B", @"C", @"C#", @"D", @"D#", @"E", @"F"];
                break;
            }
            CASE(@"Gb"){
                arrB = @[@"Gb" ,@"G", @"Ab", @"A", @"Bb", @"B", @"C", @"Db", @"D", @"Eb", @"E", @"F"];
                break;
            }
            CASE(@"G"){
                arrB = @[@"G" ,@"G#", @"A", @"A#", @"B", @"C", @"C#", @"D", @"Eb", @"E", @"F", @"F#"];
                break;
            }
            CASE(@"Ab"){
                arrB = @[@"Ab" ,@"A", @"Bb", @"B", @"C", @"Db", @"D", @"Eb", @"E", @"F", @"Gb", @"G"];
                break;
            }
        }
        
        if ((arrA != nil && [arrA count] > 0) && (arrB != nil && [arrB count] > 0)) {
            NSArray *subst = [chord matches:RX(@"[^b#][#b]?")];
            NSMutableArray* tempArr = [NSMutableArray arrayWithArray:subst];
            for (int i = 0; i < subst.count; i++)
            {
                if ([arrA indexOfObject:[subst objectAtIndex:i]] != NSNotFound){
                    int pos = [arrA indexOfObject:[tempArr objectAtIndex:i]];
                    [tempArr replaceObjectAtIndex:i withObject:[arrB objectAtIndex:pos]];
                    if ([tempArr count] ==1) {
                        if (pos == 2 || pos == 4 ||  pos == 9) {
                            [tempArr addObject:@"m"];
                        }
                        if (pos == 12) {
                            [tempArr addObject:@"dim"];
                        }
                    } else {
                        if (pos == 2 || pos == 4 || pos == 9) {
                            [tempArr replaceObjectAtIndex:1 withObject:@"m"];
                        }
                        if (pos == 12) {
                            [tempArr replaceObjectAtIndex:1 withObject:@"dim"];
                        }
                    }
                }
            }
            return [tempArr componentsJoinedByString:@""];
            
        } else {
            return chord;
        }
    }

    
    return chord;
}

-(NSString*)transpose:(NSString*)chord amount:(int)chordsAmount{
    NSArray* scale = @[@"C",@"Cb",@"C#",@"D",@"Db",@"D#",@"E",@"Eb",@"E#",@"F",@"Fb",@"F#",@"G",@"Gb",@"G#",
                       @"A",@"Ab",@"A#",@"B",@"Bb",@"B#"];
    
    NSArray* transp = @[@"Cb",@"C",@"C#",@"Bb",@"Cb",@"C",@"C",@"C#",@"D",@"Db",@"D",@"D#",@"C",@"Db",@"D",
                        @"D",@"D#",@"E",@"Eb",@"E",@"F",@"D",@"Eb",@"E", @"E",@"E#",@"F#", @"E",@"F",@"F#",
                        @"Eb",@"Fb",@"F",@"F",@"F#",@"G",@"Gb",@"G",@"G#",@"F",@"Gb",@"G", @"G",@"G#",@"A",
                        @"Ab",@"A",@"A#",@"G",@"Ab",@"A",@"A",@"A#",@"B",@"Bb",@"B",@"C",@"A",@"Bb",@"B",
                        @"B",@"B#",@"C#"];
    NSArray *subst = [chord matches:RX(@"[^b#][#b]?")];
    NSMutableArray* tempArr = [NSMutableArray arrayWithArray:subst];
    for (int i = 0; i < subst.count; i++) {
        if ([scale indexOfObject:[subst objectAtIndex:i]] != NSNotFound){
            if (chordsAmount > 0) {
                for (int ix = 0; ix < chordsAmount; ix++) {
                    int pos = [scale indexOfObject:[tempArr objectAtIndex:i]];
                    int transpos = pos*3 - 2+3;
                    [tempArr replaceObjectAtIndex:i withObject:[transp objectAtIndex:transpos+1]];
                }
            }
            if (chordsAmount < 0) {
                
            }
        }
    }    
     return [tempArr componentsJoinedByString:@""];
   
}
@end