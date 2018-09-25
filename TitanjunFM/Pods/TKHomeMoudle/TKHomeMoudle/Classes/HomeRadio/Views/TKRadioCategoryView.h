//
//  TKRadioCategoryView.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TKRedioCategoryModel;
@class TKRedioCategoryCell;

typedef void(^selectorItemBlock)(TKRedioCategoryCell *cell, NSIndexPath *indexPath);

@interface TKRadioCategoryView : UIView

@property (nonatomic, strong)NSMutableArray<TKRedioCategoryModel *> *categorieModels;

@property (nonatomic, copy) selectorItemBlock selectorItemBlock;


@end

NS_ASSUME_NONNULL_END
