//
//  SharedNotifierViewController.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 9/2/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "SharedNotifierViewController.h"

@interface SharedNotifierViewController ()

@end

@implementation SharedNotifierViewController
@synthesize sharedCharts, sharedSets;


-(void)updateForData:(NSDictionary*)data andShared:(NSString*)sh {
    self.sharedFromId = sh;
   
}

-(void)showSharedCharts:(NSMutableArray*)charts andSets:(NSMutableArray*)sets{
    sharedCharts = charts;
    sharedSets = sets;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if ([sharedCharts count]> 0) {
            // TODO: define string constans below in a plist
           return @"Shared chords";
        } else {
           return @"Shared sets";
        }
        
    }
    return @"Shared sets";
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([sharedCharts count] > 0) {
            return [sharedCharts count];
        } else {
             return [sharedSets count];
        }
        
    }
    return [sharedSets count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
        static NSString *simpleTableIdentifier = @"chartCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
    cell.frame = CGRectMake(0, cell.frame.origin.y, self.screenWidth, self.screenHeight/10);
    
    self.bigTitle =(UILabel*)[cell viewWithTag:1];
    self.smallAuthor = (UILabel*)[cell viewWithTag:4];
    self.chordOtherInfo = (UILabel*)[cell viewWithTag:3];
    self.smallGenre = (UILabel*)[cell viewWithTag:2];
    self.smallTitle = (UILabel*)[cell viewWithTag:5];
    self.dismissBtn = (UIButton*)[cell viewWithTag:11];
    CGRect rect = CGRectMake((self.screenWidth/8)*6, 0, self.screenWidth/8, self.screenHeight/10);
    self.dismissBtn.frame = rect;
    self.acceptBtn = (UIButton*)[cell viewWithTag:12];

    rect = CGRectMake((self.screenWidth/8)*7, 0, self.screenWidth/8, self.screenHeight/10);
    self.acceptBtn.frame = rect;
    NSLog(@"%ld",(long)indexPath.section);
    if (indexPath.section == 0) {
        if ([sharedCharts count] > 0) {
            self.colorView = (UIView*)[cell viewWithTag:25];
            NSDictionary *d = [sharedCharts objectAtIndex:indexPath.row];
            self.bigTitle.text = d[@"cTitle"];
            self.smallAuthor.text = d[@"artist"];
            self.chordOtherInfo.text = [NSString stringWithFormat:@"%@ • %@ • %@",d[@"key"],d[@"time_sig"], d[@"bpm"]];
            self.smallGenre.text = [sharedCharts objectAtIndex:indexPath.row][@"genre"];
            self.smallTitle.text = [sharedCharts objectAtIndex:indexPath.row][@"cTitle"];
            self.colorView.backgroundColor = [[ColorHelper alloc] getRandomRedColor];
            [self.dismissBtn addTarget:self action:@selector(dismissChord:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.acceptBtn addTarget:self action:@selector(acceptChord:) forControlEvents:UIControlEventTouchUpInside];
        } else {
             self.colorView = (UIView*)[cell viewWithTag:25];
            NSDictionary *d = [sharedSets objectAtIndex:indexPath.row];
            self.bigTitle.text = d[@"title"];
            self.smallAuthor.text = d[@"artist"];
            self.chordOtherInfo.text = d[@"date"];
            self.smallGenre.text = d[@"location"];
            self.smallTitle.text = [sharedSets objectAtIndex:indexPath.row][@"title"];
          
            [self.colorView setBackgroundColor:[[ColorHelper alloc] getRandomBlueColor]];
            [self.dismissBtn addTarget:self action:@selector(dismissSet:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.acceptBtn addTarget:self action:@selector(acceptSet:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        self.colorView = (UIView*)[cell viewWithTag:25];
        NSDictionary *d = [sharedSets objectAtIndex:indexPath.row];
        self.bigTitle.text = d[@"title"];
        self.smallAuthor.text = d[@"artist"];
        self.chordOtherInfo.text = d[@"date"];
        self.smallGenre.text = d[@"location"];
        self.smallTitle.text = [sharedSets objectAtIndex:indexPath.row][@"title"];
        [self.colorView setBackgroundColor:[[ColorHelper alloc] getRandomBlueColor]];
        [self.dismissBtn addTarget:self action:@selector(dismissSet:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.acceptBtn addTarget:self action:@selector(acceptSet:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}



-(void)dismissSet:(id)sender{
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath* indexPath = [self.sharedDataTable indexPathForCell:cell];
    int r = indexPath.row;
     NSDictionary* tempSet = [sharedSets objectAtIndex:r];
    [[ServerUpdater sharedManager] declineSet:tempSet[@"serverId"]];
    [sharedSets removeObjectAtIndex:r];
    [self.sharedDataTable reloadData];
}



-(void)dismissChord:(id)sender{
    if ([sharedCharts count] == 0){
        [self dismissSet:sender];
    } else {
        UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview] superview];
        NSIndexPath* indexPath = [self.sharedDataTable indexPathForCell:cell];
        int r = indexPath.row;
        NSDictionary *tempChord = [sharedCharts objectAtIndex:r];
        [[ServerUpdater sharedManager] declineChart:tempChord[@"serverId"]];
        [sharedCharts removeObjectAtIndex:r];
        [self.sharedDataTable reloadData];
    }
}

-(void)acceptSet:(id)sender{
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath* indexPath = [self.sharedDataTable indexPathForCell:cell];
    int r = indexPath.row;
    NSDictionary* tempSet = [sharedSets objectAtIndex:r];
    
    [[DBManager sharedManager] addNewSet:tempSet[@"title"]
           artist:tempSet[@"artist"]
             date:tempSet[@"date"]
         location:tempSet[@"location"]
            notes:tempSet[@"notes"]
           chords:tempSet[@"chords"]
           withId:tempSet[@"setId"]
            owner:tempSet[@"owner"]];
    
    [sharedSets removeObjectAtIndex:r];
    [[ServerUpdater sharedManager] acceptSet:tempSet[@"serverId"]];
    [self.sharedDataTable reloadData];
}

-(void)acceptChord:(id)sender{
    if ([sharedCharts count] == 0) {
        [self acceptSet:sender];
    } else {
        UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview] superview];
        NSIndexPath* indexPath = [self.sharedDataTable indexPathForCell:cell];
        int r = indexPath.row;
        NSDictionary *tempChord = [sharedCharts objectAtIndex:r];
        [self addChord:tempChord];
        [[ServerUpdater sharedManager] acceptChart:tempChord[@"serverId"]];
        [sharedCharts removeObjectAtIndex:r];
        [self.sharedDataTable reloadData];
    }
}

-(void)addChord:(NSDictionary*)tempChord{
   [[DBManager sharedManager] addNewChart:tempChord[@"cTitle"]
            artist:tempChord[@"artist"]
               key:tempChord[@"key"]
          time_sig:tempChord[@"time_sig"]
             genre:tempChord[@"genre"]
               bpm:tempChord[@"bpm"]
             notes:tempChord[@"notes"]
            lyrics:tempChord[@"lyrics"]
           chartId:tempChord[@"chordId"]
             owner:tempChord[@"owner"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)_indexPath {
    self.selectedRow = _indexPath.row;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [User sharedManager];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    self.screenWidth = screenSize.width;
    self.screenHeight = screenSize.height;

}

- (IBAction)hideSharedData:(id)sender {
    @try {
        ServerUpdater* updater = [ServerUpdater sharedManager];
        [self.delegate updatedDataAfterSharing];
        [updater continueCheck];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int countOfSection = 0;
    if ([sharedSets count] > 0) {
        countOfSection++;
    }
    if ([sharedCharts count] > 0 ) {
        countOfSection++;
    }
    return countOfSection;
}

@end
