//
//  TransposeChordHelper.h
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegExCategories.h"

@interface TransposeChordHelper : NSObject

-(NSString*)transpose:(NSString*)chord amount:(int)chordsAmount;
-(NSMutableArray*)getViewForKey:(NSString*)key;
-(NSString*)chordTranspose:(NSString*)chord fromKey:(NSString*)key1 toKey:(NSString*)key2;
@end
