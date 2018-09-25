//
//  TKRedioCategoryCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRedioCategoryCell.h"
#import "UIImage+Image.h"


@interface TKRedioCategoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation TKRedioCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage bundleImageWithClass:[self class] Name:@"icon_radio_hide@3x.png"]];
}

- (void)up {
    self.imageView.image = [UIImage bundleImageWithClass:[self class] Name:@"icon_radio_hide@3x.png"];
}

- (void)down {
    self.imageView.image = [UIImage bundleImageWithClass:[self class] Name:@"icon_radio_show@3x.png"];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.center = self.contentView.center;
}

- (void)setModel:(TKRedioCategoryModel *)model {
    _model = model;
    
    if (model.isLast) {
        [self.contentView addSubview:self.imageView];
    } else {
        [self.imageView removeFromSuperview];
    }
    
    self.nameLabel.text = model.name;
}
@end
