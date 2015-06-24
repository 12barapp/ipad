//
//  HelpViewController.h
//  app12bar
//
//  Created by Noah Labhart on 2/9/15.
//  Copyright (c) 2015 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) NSString *helpFile;

@end
