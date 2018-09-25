//
//  TKRedioCategoryCell.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKRedioCategoryModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface TKRedioCategoryCell : UICollectionViewCell

@property (nonatomic, strong)TKRedioCategoryModel *model;

- (void)up;
- (void)down;


@end

NS_ASSUME_NONNULL_END
