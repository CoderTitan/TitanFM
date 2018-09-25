//
//  TKRadioInfoCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRadioInfoCell.h"
#import "TKRedioModel.h"
#import "UIImageView+Extension.h"
#import "UIImage+Image.h"

@interface TKRadioInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *programNameLable;
@property (weak, nonatomic) IBOutlet UILabel *playCountLable;

@end

@implementation TKRadioInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.coverImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.coverImageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.coverImageView.layer.shadowOpacity = 0.5;
}

- (void)setModel:(TKRedioModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    [self.coverImageView setURLImageWithURL:[NSURL URLWithString:model.coverSmall] placeHoldImage:[UIImage bundleImageWithClass:[self class] Name:@"find_albumcell_cover_bg@3x.png"] isCircle:NO];
    self.programNameLable.text = [NSString stringWithFormat:@"直播中: %@", model.programName];
    self.playCountLable.text = [NSString stringWithFormat:@"收听人数: %.1f万人", model.playCount / 10000.0];
}
@end
