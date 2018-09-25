//
//  TKRankingListCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRankingListCell.h"
#import "UIImageView+Extension.h"
#import "UIImage+Image.h"
#import "TKRankingInfoModel.h"

@interface TKRankingListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitle1;
@property (weak, nonatomic) IBOutlet UILabel *subTitle2;

@end

@implementation TKRankingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfoModel:(TKRankingInfoModel *)infoModel {
    _infoModel = infoModel;
    [self.coverImageView setURLImageWithURL:[NSURL URLWithString:infoModel.coverPath] placeHoldImage:[UIImage bundleImageWithClass:[self class] Name:@"find_albumcell_cover_bg@3x.png"] isCircle:NO];
    self.titleL.text = infoModel.title;
    self.subTitle1.text = infoModel.firstTitle;
    self.subTitle2.text = infoModel.subtitle;
}

@end
