//
//  BaseViewController.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/22/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pushSlideRight:(UIViewController*)viewController{
    UIView *parent = self.view;
    parent.tag = SLIDE_RIGHT;
    [parent addSubview:viewController.view];
    viewController.view.frame = CGRectMake(parent.bounds.origin.x-parent.bounds.size.width,
                                           parent.bounds.origin.y,
                                           parent.bounds.size.width,
                                           parent.bounds.size.height);
    
    [UIView transitionWithView:parent
                      duration:0.4f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [parent setTransform:CGAffineTransformMakeTranslation(parent.bounds.size.width, 0)];
                        
                    }
                    completion:^(BOOL finished) {
                        [viewController.view removeFromSuperview];
                        [self presentViewController:viewController animated:NO completion:nil];
                    }];
}

-(void) pushSlideLeft:(UIViewController*)viewController{
    NSLog(@"Slide left");
    UIView *parent = self.view;
    parent.tag = SLIDE_LEFT;
    [parent addSubview:viewController.view];
    viewController.view.frame = CGRectMake(parent.bounds.origin.x+parent.bounds.size.width,
                                           parent.bounds.origin.y,
                                           parent.bounds.size.width,
                                           parent.bounds.size.height);
    
    [self performSelector:@selector(delayedTransitionSlideLeft:) withObject:viewController afterDelay:0.4f];
}

-(void)delayedTransitionSlideLeft:(UIViewController*)viewController {
    UIView *parent = self.view;
    
    [UIView transitionWithView:parent
                      duration:0.6f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [parent setTransform:CGAffineTransformMakeTranslation(-parent.bounds.size.width, 0)];
                    }
                    completion:^(BOOL finished) {
                        [viewController.view removeFromSuperview];
                        [self presentViewController:viewController animated:NO completion:^{
                           // [self pop];
                        }];
                        
                    }];
}

-(void) pop {
    NSLog(@"Pop");
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) fakeFlip {
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:self.view.frame];
    tempView.image = viewImage;
    
    
    
    
    CGRect frame = tempView.frame;
    frame.origin.y = 100;
    tempView.frame = frame;
    
    [UIView transitionWithView:tempView
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        
                    }
                    completion:^(BOOL finished) {
                        
                    }
     ];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
