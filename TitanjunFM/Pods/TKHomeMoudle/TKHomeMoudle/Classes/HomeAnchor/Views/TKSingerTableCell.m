//
//  TKSingerTableCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKSingerTableCell.h"
#import "UIImageView+Extension.h"

@interface TKSingerTableCell()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *singerIcon;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *middleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vLogo;

@end


@implementation TKSingerTableCell

- (void)setAnchorM:(TKAnchorModel *)anchorM {
    _anchorM = anchorM;
    [self.singerIcon setURLImageWithURL:[NSURL URLWithString:anchorM.middleLogo] placeHoldImage:nil isCircle:YES];
    self.titleLabel.text = anchorM.nickname;
    self.middleLabel.text = anchorM.verifyTitle;
    self.fansLabel.text = [NSString stringWithFormat:@"%zd 专辑", anchorM.tracksCounts];
    
    
    self.vLogo.hidden = !anchorM.isVerified;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}


@end
