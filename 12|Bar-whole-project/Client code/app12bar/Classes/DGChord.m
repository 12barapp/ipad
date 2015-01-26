//
//  DGChord.m
//  app12bar
//
//  Created by Alex on 8/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "DGChord.h"


@implementation DGChord
@synthesize uniqueID, myId;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)updateId:(int)elId{
    if (self.myManager != nil) {
            NSLog(@"string");
    }

}

- (void)dragEnded:(AtkDragAndDropManager *)manager {
    self.layer.opacity = 1;
}

- (void)dragWillStart:(AtkDragAndDropManager *)manager {
    self.myManager = manager;
    self.layer.opacity = 0;
    manager.pasteboard.string = [NSString stringWithFormat:@"val-%ld", (long)self.tag];
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width-40, self.frame.size.height-40);
    [UIView animateWithDuration:0.4 animations:^{
         self.frame = frame;
    }];    
}
@end
