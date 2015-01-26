//
//  ChordsGrid.h
//  app12bar
//
//  Created by Alex on 7/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "LyricsDragSource.h"
#import "DGChord.h"
#import "ColorHelper.h"
#import "CustomLabel.h"
#import "CustomButton.h"

@class ChordsGrid;
@protocol ChordsGridDelegate
    - (void)didTapLabelWithGesture:(UITapGestureRecognizer*)label;
    - (void)showInfo:(UITapGestureRecognizer*)label;
    - (void)selectedChord:(NSInteger)position withId:(NSString*)chordId;
    - (void)startedDragging;
    - (void)canceledDragging;
    - (void)updateBlurImage;
    - (void)exchangeChordItemAtIndex:(NSString*)index1 withItemIndex:(NSString*)index2;
@end

@interface ChordsGrid : NSObject<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>{
    GMGridView *_gridView;
    NSMutableArray *ids;
    NSMutableArray *_data;
    NSMutableArray *_data2;
    NSInteger _lastDeleteItemIndexAsked;
    NSArray *redColors;
}

@property (assign) id<ChordsGridDelegate> delegate;
@property (assign) NSMutableArray *dataSource;

-(id)initWithData:(NSMutableArray*)data andIds:(NSMutableArray*)ids withFrame:(CGRect)rect andContainer:(UIView*)container owner:(UIViewController*)parent;

-(void)addNewItem:(NSString*)title withId:(NSString*)iid;
-(void)reloadChordsWithData:(NSMutableArray*)newData;
-(void)refreshItemAtIndex:(int)index withTitle:(NSString*)title;
@end
