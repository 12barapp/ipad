//
//  ChordsGrid.m
//  app12bar
//
//  Created by Alex on 7/6/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "ChordsGrid.h"

#define THREE_DOTS @"..."
#define ELEPSIS @"•••"
#define MY_FONT @"Helvetica Neue"
#define NUMBER_ITEMS_ON_LOAD 36

@implementation ChordsGrid



-(id)initWithData:(NSMutableArray*)data andIds:(NSMutableArray*)ids_ withFrame:(CGRect)rect andContainer:(UIView*)container owner:(UIViewController*)parent{
    self = [super init];
    if (self){
        redColors = @[@"#ED1C24", @"#E25D5D", @"#E53E3E", @"#E07E7E", @"#ED9D9D"];
        NSInteger spacing = 0;
        
        self.dataSource = data;
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
        //_gridView.scrollView.scrollEnabled = NO;
        _gridView.scrollEnabled = NO;
    }
    return self;
}

-(void)addNewItem:(NSString*)title withId:(NSString*)iid {
    [ids addObject:iid];
    [_gridView reloadData];
}

- (void)didTapLabelWithGesture:(UITapGestureRecognizer*)label{
    NSLog(@"ID %@",[(CustomButton*)label getUniqueID]);
    [self.delegate didTapLabelWithGesture:label];
};

- (void)showChordInfo:(UITapGestureRecognizer*)label{
    [self.delegate showInfo:label];
};

#pragma mark GMGridViewDataSource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView {
    return [self.dataSource count];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2 {

    DGChord *dc = (DGChord*)[gridView cellForItemAtIndex:index1-5];
    DGChord *dc2 = (DGChord*)[gridView cellForItemAtIndex:index2-5];
    [ dc setMyId:index2-5];
    [dc updateId:index2-5];
    [(DGChord*)[gridView cellForItemAtIndex:index2-4] setMyId:index1-5];
    [self.dataSource exchangeObjectAtIndex:index1-5 withObjectAtIndex:index2-5];

    
    [self.delegate exchangeChordItemAtIndex:[ids objectAtIndex:index1] withItemIndex:[ids objectAtIndex:index2]];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height-8;
    return CGSizeMake(/*94.8f*/screenWidth/8, screenHeight/10);
}



- (DGChord *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index {
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    DGChord *cell = (DGChord*)[gridView dequeueReusableCell];
    [cell setMyId:index];
    [cell setUniqueID:[ids objectAtIndex:index]];
    if (!cell) {
        cell = [[DGChord alloc] initWithFrame:CGRectMake(0, 0, screenWidth/8, screenSize.height/10)];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        [cell setUniqueID:[ids objectAtIndex:index]];
        [cell setMyId:index];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];

//        view.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:redColors[arc4random()%redColors.count]];
        view.backgroundColor = [[[ColorHelper alloc] init] colorWithHexString:redColors[index % redColors.count]];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 0;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth/8, screenSize.height/10)];
    
    UIView *dotsView = [[UIView alloc] initWithFrame:CGRectMake(((screenWidth/8)-40), 0, 35, 30)];

    
    CustomButton *dotsButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [dotsButton.titleLabel setText:ELEPSIS];
    [dotsButton.titleLabel setFont:[UIFont systemFontOfSize:35]];
    dotsButton.titleLabel.textColor = [UIColor whiteColor];
    [dotsButton setUniqueID:[ids objectAtIndex:index]];
    dotsButton.layer.zPosition = 99;
    
    [dotsButton setImage:[UIImage imageNamed:@"dots_icon"] forState:(UIControlStateNormal)];
    [dotsButton  setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
    dotsButton.layer.opacity = 0.25;
    
    dotsButton.tag = index;
    
    [dotsButton addTarget:self.delegate action:@selector(showInfo:) forControlEvents:(UIControlEventTouchUpInside)];
    
   
    [dotsView addSubview:dotsButton];
    [cellView addSubview:dotsView];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 5, 5);
    CGRect paddedFrame = UIEdgeInsetsInsetRect(CGRectMake(0, 40, 94, 60), contentInsets);
    
    CustomButton *chartTitle = [[CustomButton alloc] initWithFrame:paddedFrame];
    chartTitle.tag = index;
   // chartTitle.userInteractionEnabled = NO;
    chartTitle.enabled = YES;
    [chartTitle setUniqueID:[ids objectAtIndex:index]];
    [chartTitle setTitle:[self.dataSource objectAtIndex:index] forState:UIControlStateNormal];
    [chartTitle.titleLabel setFont:[UIFont fontWithName:MY_FONT size:14.0]];
    [chartTitle.titleLabel setNumberOfLines:3];
  //  chartTitle.backgroundColor = [UIColor grayColor];
    UITapGestureRecognizer *titleGestureInfo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapLabelWithGesture:)];
    titleGestureInfo.numberOfTapsRequired = 1;
    [cellView addGestureRecognizer:titleGestureInfo];

    cellView.userInteractionEnabled = YES;
    
    [chartTitle addTarget:self action:@selector(didTapLabelWithGesture:) forControlEvents:(UIControlEventTouchUpInside)];
    
    chartTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    chartTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [cellView addSubview:chartTitle];
    [cell.contentView addSubview:cellView];    
    return cell;
}

-(void)refreshItemAtIndex:(int)index withTitle:(NSString*)title{
    index = index+5;
    [self.dataSource replaceObjectAtIndex:(NSUInteger)index withObject:title];
    [_gridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}


-(void)reloadChordsWithData:(NSMutableArray*)newData{
    self.dataSource = newData;   
    [_gridView reloadData];
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index {
    return YES;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////



- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    DGChord *cell = (DGChord*)[gridView getSortItem];
    [self.delegate selectedChord:position - 5 withId:[(DGChord*)cell uniqueID]];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
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
        [self.dataSource removeObjectAtIndex:_lastDeleteItemIndexAsked];
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
    NSObject *object = [self.dataSource objectAtIndex:oldIndex];
    [self.dataSource removeObject:object];
    [self.dataSource insertObject:object atIndex:newIndex];
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
  /*  UIView *fullView = [[UIView alloc] init];
    //fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.textAlignment = NSTextAlignmentCenter;
  //  label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    label.font = [UIFont boldSystemFontOfSize:20];
    
    
    [fullView addSubview:label];*/
    
    
    return cell;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}



@end
