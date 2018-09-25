//
//  TKRecommendCell.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKGroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TKRecommendCell : UITableViewCell

@property (nonatomic, strong) TKGroupModel *groupM;

+ (instancetype)cellWithTableView: (UITableView *)tableView;


@end

NS_ASSUME_NONNULL_END
