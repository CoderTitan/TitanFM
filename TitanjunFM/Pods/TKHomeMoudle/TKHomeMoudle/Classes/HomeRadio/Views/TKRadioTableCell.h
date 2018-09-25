//
//  TKRadioTableCell.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKRadioArrModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKRadioTableCell : UITableViewCell

typedef void(^moreBlok)(TKRadioTableCell *cell);

@property (nonatomic, copy) moreBlok moreBlock;
@property (nonatomic, strong) TKRadioArrModel *listModels;



@end

NS_ASSUME_NONNULL_END
