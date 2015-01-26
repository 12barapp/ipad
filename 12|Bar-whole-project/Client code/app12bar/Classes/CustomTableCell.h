//
//  CustomTableCell.h
//  app12bar
//
//  Created by Vasiliy Alifanov on 12/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCell : UITableViewCell{
    NSString *uniqueID;
}

-(void)setUniqueId:(NSString*)uid;
-(NSString*)getUniqueId;

@end
