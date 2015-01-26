//
//  DGZone.m
//  app12bar
//
//  Created by Alex on 8/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "DGZone.h"

@implementation DGZone

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setId:(int)mId{
    myId = mId;
}
-(int)getId{
    return myId;
}

-(void)setUniqueID:(NSString *)someId{
    uniqueID = someId;
}

-(NSString*)getUniqueID{
    return uniqueID;
}

- (BOOL)shouldDragStart:(AtkDragAndDropManager *)manager
{
    return YES;
}

- (BOOL)isInterested:(AtkDragAndDropManager *)manager
{
    //   NSLog(@"AtkSampleOneDropZoneView.isInterested");
    
    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *tagValue = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    NSString *pasteboardString = pastebaord.string;
    
    return [tagValue isEqualToString:pasteboardString];
}

- (void)dragStarted:(AtkDragAndDropManager *)manager
{
    //  NSLog(@"AtkSampleOneDropZoneView.dragStarted");
    self.savedBackgroundColor = self.backgroundColor;
    
    UIPasteboard *pastebaord = manager.pasteboard;
    NSString *tagValue = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    NSString *pasteboardString = pastebaord.string;
    
    if([tagValue isEqualToString:pasteboardString])
    {
        //self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    else
    {
        //self.backgroundColor = [UIColor redColor];
    }
}

- (void)dragEnded:(AtkDragAndDropManager *)manager
{
  
   // NSArray *views = [(UIView*)((id<AtkDragSourceProtocol>)[manager getDataSource]) subviews];
   // NSLog(@"AtkSampleOneDropZoneView.dragEnded %@",self.superclass);
   
    [self performSelector:@selector(delayEnd) withObject:nil afterDelay:0.4];
}


- (void)delayEnd
{
    self.backgroundColor = self.savedBackgroundColor;
}

- (void)dragEntered:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    //self.backgroundColor = [UIColor orangeColor];
    self.layer.shadowOpacity = 0.7;
    self.layer.zPosition = 999;
}

- (void)dragExited:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    // NSLog(@"AtkSampleOneDropZoneView.dragExited");
   // self.backgroundColor = self.savedBackgroundColor;//[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    self.layer.shadowOpacity = 0;
    self.layer.zPosition = 0;
}

- (void)dragMoved:(AtkDragAndDropManager *)manager point:(CGPoint)point
{

}

- (void)dragDropped:(AtkDragAndDropManager *)manager point:(CGPoint)point
{
    self.layer.shadowOpacity = 0;
    self.layer.zPosition = 0;
    NSArray *views = [(DGChord*)((id<AtkDragSourceProtocol>)[manager getDataSource]) subviews];
  //  DGChord* mid = (DGChord*)[views objectAtIndex:0];
 //   NSLog(@"%d",[((DGChord*)((UIView*)([views objectAtIndex:0])).superview) getId]);
    [self.delegate draggedToMe:[((DGChord*)((UIView*)([views objectAtIndex:0])).superview) myId] withMyId:myId andUniqueID:[((DGChord*)((UIView*)([views objectAtIndex:0])).superview) uniqueID] setId:uniqueID];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
