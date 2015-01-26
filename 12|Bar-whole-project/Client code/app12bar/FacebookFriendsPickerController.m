//
//  FacebookFriendsPickerController.m
//  app12bar
//
//  Created by Alex on 8/26/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "FacebookFriendsPickerController.h"

@interface FacebookFriendsPickerController ()

@end

@implementation FacebookFriendsPickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Hello from friend picker");
    [self fetchMyFriends];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelFriendPick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneFriendPick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fetchMyFriends{
    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error )
        {
            //[self ShowActivityIndicatorWithTitle:@"Loading..."];
            [[[FBSession activeSession] accessTokenData] accessToken];
               NSLog(@"My friends %@",result);
            /*    NSLog(@"acces token=%@",[[[FBSession activeSession] accessTokenData] accessToken]);
             [[NSUserDefaults standardUserDefaults]setValue:[[[FBSession activeSession] accessTokenData] accessToken]  forKey:@"FbAccessTokenKey"];
             NSLog(@"sdfsdfdsfsf=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FbAccessTokenKey"]);
             NSLog(@"result %@",result);
             
             
             [[NSUserDefaults standardUserDefaults]setValue:userid  forKey:@"FBuserID"];
             [[NSUserDefaults standardUserDefaults]setValue:userName   forKey:@"FBuserName"];
             [[NSUserDefaults standardUserDefaults]setValue:email   forKey:@"FBemail"];
             [[NSUserDefaults standardUserDefaults]setValue:gender   forKey:@"FBgender"];
             [[NSUserDefaults standardUserDefaults]setValue:dob   forKey:@"FBbirthday"];
             [[NSUserDefaults standardUserDefaults]setObject:userLocation forKey:@"location"];
             [[NSUserDefaults standardUserDefaults]synchronize];*/
            /*                NSString *userName=[result objectForKey:@"name"];
             NSString *userid=[result objectForKey:@"id"];
             NSString *email = [result objectForKey:@"email"];
             NSString *gender = [result objectForKey:@"gender"];
             NSString *dob = [result objectForKey:@"birthday"];
             NSString *userLocation  = [[result objectForKey:@"location"] objectForKey:@"name"];*/
            
            
            //   [self registerFromFacebook];
            
        }
    }];

}



@end
