//
//  TKAnchorCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKAnchorCell.h"
#import "UIImageView+Extension.h"

@interface TKAnchorCell()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TKAnchorCell

- (void)setAnchorM:(TKAnchorModel *)anchorM {
    _anchorM = anchorM;
    
    [self.imageView setURLImageWithURL:[NSURL URLWithString:anchorM.middleLogo] progress:nil complete:nil];
    self.titleLabel.text = anchorM.verifyTitle;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
