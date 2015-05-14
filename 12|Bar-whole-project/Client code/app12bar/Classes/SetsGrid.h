//
//  SetsGrid.h
//  app12bar
//
//  Created by Alex on 7/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "DGZone.h"
#import "ColorHelper.h"
#import "CustomButton.h"
#import "CustomLabel.h"

@class SetsGrid;
@protocol SetsGridDelegate
- (void)didTapSetLabelWithGesture:(UITapGestureRecognizer*)label;
- (void)showSetInfo:(UITapGestureRecognizer*)label;
- (void)selectedSet:(NSInteger)position;
- (void) exchangeSetItemAtIndex:(NSString*)index1 withItemAtIndex:(NSString*)index2;
- (void)updateBlurImage;
- (void)copyChord:(int)chordId intoSet:(int)setId andUID:(NSString*)uId setId:(NSString *)setId;
-(void)startedDragging;
-(void)canceledDragging;
@end

@interface SetsGrid : NSObject<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate, DGZoneDelegate>{
    GMGridView *_gridView;
    NSMutableArray *dataSource;
    NSMutableArray *ids;
    NSInteger _lastDeleteItemIndexAsked;
    NSArray* blueColors;
    BOOL isDropped;
    
}
//@property(assign, nonatomic) IBOutlet GMGridView *_gridView;
@property (assign) id<SetsGridDelegate> delegate;
-(id)initWithData:(NSMutableArray*)data andIds:(NSMutableArray*)ids withFrame:(CGRect)rect andContainer:(UIView*)container;

-(void)addNewItem:(NSString*)title withId:(NSString*)iid;
-(void)reloadChordsWithData:(NSMutableArray*)newData;
@end
