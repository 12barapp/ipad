//
//  DGZone.h
//  app12bar
//
//  Created by Alex on 8/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtkDragAndDrop.h"
#import "GMGridView.h"
#import "DGChord.h"

@class DGZone;
@protocol DGZoneDelegate

-(void)draggedToMe:(int)mid withMyId:(int)setId andUniqueID:(NSString*)uId setId:(NSString*)setId;

@end

@interface DGZone : GMGridViewCell<AtkDropZoneProtocol>{
    int myId;
    NSString* uniqueID;
}
@property (nonatomic, strong) UIColor *savedBackgroundColor;
@property (assign) id<DGZoneDelegate> delegate;
-(void)setId:(int)mId;
-(int)getId;
-(void)setUniqueID:(NSString *)someId;
-(NSString*)getUniqueID;
@end
