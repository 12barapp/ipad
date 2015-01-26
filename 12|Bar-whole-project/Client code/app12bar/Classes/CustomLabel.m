//
//  CustomLabel.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 11/28/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

-(void)setUniqueID:(NSString *)someId{
    uniqueID = someId;
}

-(NSString*)getUniqueID{
    return uniqueID;
}

@end
