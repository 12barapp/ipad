//
//  BaseViewController.h
//  app12bar
//
//  Created by Vasiliy Alifanov on 10/22/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {MEMBER_MENU, PUBLIC_MENU, PRIVATE_MENU, PERSONAL_INFO, NEWS_EVENTS, SESSIONS, PAMPER_ME, OUR_SERVICES, MY_REWARDS, ABOUT_US, BOOK_A_SESSION, CONTACT_US} WEB_PAGES;

typedef enum {CURL_RIGHT=100,SLIDE_RIGHT,FADE_IN,CURL_AND_SLIDE,SLIDE_LEFT,CURL_LEFT} ViewsSwitchTypes;


@interface AnimationViewController : UIViewController

-(void) pushSlideRight:(UIViewController*)viewController;
-(void) pushSlideLeft:(AnimationViewController*)viewController;
-(void) fakeFlip;


@end
