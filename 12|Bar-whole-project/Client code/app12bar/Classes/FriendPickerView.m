//
//  FriendPickerView.m
//  app12bar
//
//  Created by Alex on 7/24/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "FriendPickerView.h"

@implementation FriendPickerView
@synthesize arOptions;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;

        self.header.frame = CGRectMake(0,0,screenWidth, 102);
        self.friendsTable.frame = CGRectMake(0, screenHeight/10, screenWidth, screenHeight-(screenHeight/10));
    }
    return self;
}

+ (id) friendPicker:(id)pickDelegate{
    UINib *nib = [UINib nibWithNibName:@"FriendPicker" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    FriendPickerView *me = [nibArray objectAtIndex: 0];
    
    me.delegate = pickDelegate;
    
    me.header.frame = CGRectMake(0,0,798, 202);
    return me;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    arOptions = [[NSMutableArray alloc] init];
    for(int i = 1; i <= 20; i++) {
        [arOptions addObject:[NSString stringWithFormat:@"Some friend %i", i]];
    }
    self.friendsTable.delegate = self;
    self.friendsTable.dataSource = self;
    return [arOptions count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdent = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    
    cell.textLabel.text = [arOptions objectAtIndex:indexPath.row];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenWidth/8,screenHeight/10)];
    v.backgroundColor = [UIColor redColor];

   // cell.imageView.image = [UIImage imageNamed:@"cancel.png"];
    [cell addSubview:v];
    return cell;
}

- (IBAction)cancelPick:(id)sender {
    [self.delegate cancel];
}

- (IBAction)donePick:(id)sender {
    [self.delegate shareWithFriends];
}

@end
