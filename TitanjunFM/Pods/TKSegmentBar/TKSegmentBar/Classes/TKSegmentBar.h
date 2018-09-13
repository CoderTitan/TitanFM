//
//  TKSegmentBar.h
//  TKSegmentBar_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKSegmentConfig.h"

@class TKSegmentBar;
@protocol XMGSegmentBarDelegate <NSObject>

/**
 代理方法, 告诉外界, 内部的点击数据
 
 @param segmentBar segmentBar
 @param toIndex    选中的索引(从0开始)
 @param fromIndex  上一个索引
 */
- (void)segmentBar: (TKSegmentBar *)segmentBar didSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex;

@end

@interface TKSegmentBar : UIView
/** 代理 */
@property (nonatomic, weak) id<XMGSegmentBarDelegate> delegate;
/** 数据源 */
@property (nonatomic, strong) NSArray <NSString *>*items;
/** 当前选中的索引, 双向设置 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 快速创建一个选项卡控件

 @param frame frame
 @return 选项卡控件
 */
+ (instancetype)segmentBarWithFrame: (CGRect)frame;

- (void)updateWithConfig: (void(^)(TKSegmentConfig *config))configBlock;

@end
