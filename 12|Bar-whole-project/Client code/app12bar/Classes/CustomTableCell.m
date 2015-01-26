//
//  CustomTableCell.m
//  app12bar
//
//  Created by Vasiliy Alifanov on 12/3/14.
//  Copyright (c) 2014 Vasilkoff LTD. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUniqueId:(NSString*)uid{
    uniqueID = uid;
}

-(NSString*)getUniqueId{
    return uniqueID;
}

@end
