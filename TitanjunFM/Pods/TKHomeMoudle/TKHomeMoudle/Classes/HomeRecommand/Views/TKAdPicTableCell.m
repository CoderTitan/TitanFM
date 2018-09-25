//
//  TKAdPicTableCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKAdPicTableCell.h"
#import "TitanADPicView.h"
#import "TKAdPicModel.h"
#import "UIImageView+Extension.h"


#define kCellMargin 10

@interface TKAdPicTableCell () <TitanAdPicViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TitanADPicView *adpicView;
@property (weak, nonatomic) IBOutlet UILabel *upTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;

@end
@implementation TKAdPicTableCell
static NSString *const cellID = @"CellTypeList1";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    TKAdPicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell =  [[NSBundle bundleForClass:[self class]] loadNibNamed:@"TKAdPicTableCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.adpicView setLoadBlock:^(UIImageView *imageView, NSURL *url) {
        [imageView setURLImageWithURL:url progress:nil complete:nil];
    }];
    self.adpicView.delegate = self;
}

- (void)setGroupM:(TKGroupModel *)groupM {
    _groupM = groupM;
    self.titleLabel.text = groupM.title;
    
    NSMutableArray *picMs = [NSMutableArray array];
    if (groupM.liveMs.count > 0) {
        for (TKLiveModel *liveModel in groupM.liveMs) {
            TKAdPicModel *picModel = [[TKAdPicModel alloc]init];
            picModel.liveM = liveModel;
            [picMs addObject:picModel];
        }
    } else if (groupM.tuiguangMs.count > 0) {
        for (TKPromotionModel *model in groupM.tuiguangMs) {
            TKAdPicModel *picModel = [[TKAdPicModel alloc]init];
            picModel.promotionM = model;
            [picMs addObject:picModel];
        }
    }
    self.adpicView.picModels = picMs;
}

-(void)setFrame:(CGRect)frame {
    frame.size.height -= kCellMargin;
    [super setFrame:frame];
}

#pragma mark - 代理
- (void)adPicViewDidSelectorPicModel:(TKAdPicModel *)picModel {
    TKLiveModel *liveModel = picModel.liveM;
    if (liveModel != nil) {
        self.upTitleLabel.text = liveModel.name;
        self.detailTitleLabel.text = liveModel.shortDescription;
        double count = [liveModel.playCount doubleValue];
        if (count > 10000) {
            count = count / 10000.0;
            self.rightTitleLabel.text = [NSString stringWithFormat:@"%.01f万人参与", count];
        } else {
            self.rightTitleLabel.text = [NSString stringWithFormat:@"%zd人参与", count];
        }
    }
    
    TKPromotionModel *model = picModel.promotionM;
    if (model != nil) {
        self.upTitleLabel.text = model.name;
        self.detailTitleLabel.text = model.Description;
    }
}
@end
