//
//  TKSingerGroupTableCell.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKAnchorGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKSingerGroupTableCell : UITableViewCell

+ (instancetype)cellWithTableView: (UITableView *)tableView;

@property (nonatomic, strong) TKAnchorGroupModel *anchorGroupM;

@end

NS_ASSUME_NONNULL_END
