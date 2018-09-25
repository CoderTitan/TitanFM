//
//  TKGoodTableCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKGoodTableCell.h"
#import "UIImageView+Extension.h"
#import "UIImage+Image.h"


@interface TKGoodTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *specialIcon;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;

@end

@implementation TKGoodTableCell
static NSString *const cellID = @"cellInCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    TKGoodTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle bundleForClass:self] loadNibNamed:@"TKGoodTableCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

- (void)setSpecialColumnM:(TKSpecialColumnModel *)specialColumnM {
    _specialColumnM = specialColumnM;
    NSURL *url = [NSURL URLWithString:specialColumnM.coverPath];
    [self.specialIcon setURLImageWithURL:url placeHoldImage:[UIImage bundleImageWithClass:[self class] Name:@"find_albumcell_cover_bg@3x.png"] isCircle:NO];
    self.topTitleLabel.text = specialColumnM.title;
    self.middleTitleLabel.text = specialColumnM.subtitle;
    self.bottomTitleLabel.text = specialColumnM.footnote;
}

@end
