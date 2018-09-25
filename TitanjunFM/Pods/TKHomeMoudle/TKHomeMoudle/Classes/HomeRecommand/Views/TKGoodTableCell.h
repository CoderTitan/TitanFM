//
//  TKGoodTableCell.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKSpecialColumnModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TKGoodTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) TKSpecialColumnModel *specialColumnM;


@end

NS_ASSUME_NONNULL_END
