//
//  DGChord.h
//  app12bar
//
//  Created by Alex on 8/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtkDragAndDrop.h"
#import "GMGridView.h"

@interface DGChord : GMGridViewCell<AtkDragSourceProtocol>{

}


@property (nonatomic, retain) AtkDragAndDropManager *myManager;
@property (nonatomic)     int myId;
@property (nonatomic) NSString* uniqueID;

-(void)updateId:(int)elId;

-(void)setUniqueID:(NSString *)someId;
-(NSString*)getUniqueID;
-(void)setId:(int)mId;
-(int)getId;
@end
