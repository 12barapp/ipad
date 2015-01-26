//
//  CustomLabel.h
//  app12bar
//
//  Created by Vasiliy Alifanov on 11/28/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel{
    NSString* uniqueID;
}

-(void)setUniqueID:(NSString *)someId;
-(NSString*)getUniqueID;

@end
