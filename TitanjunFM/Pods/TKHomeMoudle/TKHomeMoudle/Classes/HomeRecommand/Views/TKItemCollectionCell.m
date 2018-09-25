//
//  TKItemCollectionCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKItemCollectionCell.h"
#import "UIImage+Image.h"
#import "UIImageView+Extension.h"

@interface TKItemCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *payIcon;

@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end

@implementation TKItemCollectionCell

-(void)setItemCellModel:(TKItemCellModel *)itemCellModel {
    _itemCellModel = itemCellModel;
    
    self.payIcon.hidden = [itemCellModel.isPaid boolValue];
    NSURL *url = [NSURL URLWithString:itemCellModel.albumCoverUrl290];
    [self.albumCoverImageView setURLImageWithURL:url placeHoldImage:[UIImage bundleImageWithClass:[self class] Name:@"find_albumcell_cover_bg@3x.png"] isCircle:NO];
    self.titleLabel.text = itemCellModel.trackTitle;
    self.detailLabel.text = itemCellModel.title;
}
@end
