//
//  TKAnchorGroupModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKAnchorGroupModel : NSObject

@property (nonatomic, assign) NSInteger id;

// 1. 六个, 2, 列表
@property (nonatomic, assign) NSInteger displayStyle;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong, getter=anchorMs) NSArray <TKAnchorModel *> *list;


/// 计算属性, 可以快速获取对应行的高度
@property (nonatomic, assign) CGFloat cellHeight;


@end

NS_ASSUME_NONNULL_END
