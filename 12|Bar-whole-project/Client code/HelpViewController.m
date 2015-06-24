//
//  HelpViewController.m
//  app12bar
//
//  Created by Noah Labhart on 2/9/15.
//  Copyright (c) 2015 Vasilkoff LTD. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:self.helpFile ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];
}



- (IBAction)closeHelp:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
