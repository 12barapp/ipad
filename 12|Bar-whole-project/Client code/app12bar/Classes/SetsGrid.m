//
//  SetsGrid.m
//  app12bar
//
//  Created by Alex on 7/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "SetsGrid.h"

@implementation SetsGrid

-(id)initWithData:(NSMutableArray*)data andIds:(NSMutableArray*)ids_ withFrame:(CGRect)rect andContainer:(UIView*)container{
    self = [super init];
    if (self){
        blueColors = @[@"#36abe0", @"#5cb0d2", @"#7ec2d7", @"#96cfdd", @"#b0dbe2"];
        NSInteger spacing = 0;
        dataSource = data;
        ids = ids_;
        GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:rect];
        [gmGridView setScrollsToTop:YES];
        gmGridView.autoresizingMask = UIViewAutoresizingNone | UIViewAutoresizingFlexibleHeight;
        [container addSubview:gmGridView];
        _gridView = gmGridView;
        _gridView.style = GMGridViewStyleSwap;
        _gridView.itemSpacing = spacing;
        _gridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
        _gridView.centerGrid = NO;
        _gridView.actionDelegate = self;
        _gridView.sortingDelegate = self;
        _gridView.transformDelegate = self;
        _gridView.dataSource = self;
        _gridView.scrollEnabled = NO;
    }
    isDropped = NO;
    return self;
}
-(void)reloadChordsWithData:(NSMutableArray*)newData{
    dataSource = newData;
    [_gridView reloadData];
}

- (void)didTapSetLabelWithGesture:(UITapGestureRecognizer*)label{
    [self.delegate didTapSetLabelWithGesture:label];
};
- (void)showSetInfo:(UITapGestureRecognizer*)label{
    [self.delegate showSetInfo:label];
};
-(void)addNewItem:(NSString*)title withId:(NSString*)iid{
    [ids addObject:iid];
 //   [dataSource addObject:title];
    [_gridView reloadData];
};

#pragma mark GMGridViewDataSource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [dataSource count];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{   
    [dataSource exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    [self.delegate exchangeSetItemAtIndex:[ids objectAtIndex:index1] withItemAtIndex:[ids objectAtIndex:index2]];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height-8;
    return CGSizeMake(/*94.8f*/screenWidth/8, screenHeight/10);
}

-(void)draggedToMe:(int)mid withMyId:(int)setId andUniqueID:(NSString*)uId setId:(NSString*)setId_{
    if (!isDropped) {
        [self.delegate copyChord:mid-5 intoSet:setId-5 andUID:uId setId:setId_];
        isDropped = YES;
    } else {
        isDropped = NO;
    }

}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        DGZone *view = [[DGZone alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [view setId:index];
        view.delegate = self;
        view.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:blueColors[index % blueColors.count]];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 0;
        cell.contentView = view;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    DGZone *cellView = [[DGZone alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    cellView.delegate = self;
    [cellView setId:index];
    [cellView setUniqueID:[ids objectAtIndex:index]];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    UIView *dotsView = [[UIView alloc] initWithFrame:CGRectMake(((screenWidth/8)-40), 10, 35, 30)];
    CustomButton *dotsButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 35, 10)];
    dotsButton.titleLabel.text = @"";
    [dotsButton setBackgroundImage:[UIImage imageNamed:@"dots_icon"] forState:(UIControlStateNormal)];
    dotsButton.tag = index;
    [dotsButton setUniqueID:[ids objectAtIndex:index]];
    [dotsButton addTarget:self.delegate action:@selector(showSetInfo:) forControlEvents:(UIControlEventTouchUpInside)];
    dotsButton.layer.opacity = 0.45;
    
    [dotsView addSubview:dotsButton];
    [cellView addSubview:dotsView];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 5, 5);
    CGRect paddedFrame = UIEdgeInsetsInsetRect(CGRectMake(5, 35, 90, 60), contentInsets);
    CustomButton *setTitle = [[CustomButton alloc] initWithFrame:paddedFrame];
    setTitle.tag = index;
    [setTitle setUniqueID:[ids objectAtIndex:index]];
    [setTitle setTitle:[dataSource objectAtIndex:index] forState:UIControlStateNormal];
    [setTitle.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
    [setTitle.titleLabel setNumberOfLines:3];
    [setTitle addTarget:self action:@selector(didTapSetLabelWithGesture:) forControlEvents:(UIControlEventTouchUpInside)];
    setTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    setTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [cellView addSubview:setTitle];
    [cell.contentView addSubview:cellView];
    return cell;
}



- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////



- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    [self.delegate selectedSet:position - 5];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{

}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [dataSource removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil
     ];
    [self.delegate startedDragging];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.delegate updateBlurImage];
                     }
     ];
    [self.delegate canceledDragging];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return NO;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [dataSource objectAtIndex:oldIndex];
    [dataSource removeObject:object];
    [dataSource insertObject:object atIndex:newIndex];
}



//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        return CGSizeMake(700, 530);
    }
    else
    {
        return CGSizeMake(600, 500);
    }
    
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
      return cell;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
   
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}


@end
