//
//  TKSegmentMenueCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKSegmentMenueCell.h"

@implementation TKSegmentMenueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.backgroundColor = [UIColor redColor];
    } else {
        self.backgroundColor = [UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:0.4];
    }
}

@end
