//
//  TKSegmentBar.h
//  TKSegmentBar_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKSegmentConfig.h"
#import "TKSegmentModelProtocol.h"



@protocol TKSegmentBarDelegate <NSObject>

/**
 代理方法, 告诉外界, 内部的点击数据
 
 @param toIndex    选中的索引
 @param fromIndex  上一个索引
 */
- (void)segmentBarDidSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex;

@end


@interface TKSegmentBar : UIView


/** 代理 */
@property (nonatomic, weak) id<TKSegmentBarDelegate> delegate;

/** 选项卡模型数组, 此处传递字符串数组也可以, 只不过索引变成了对应的数组下标 */
@property (nonatomic, strong) NSArray <id<TKSegmentModelProtocol>> *segmentModels;

/** 当前选中的索引, 双向设置 */
@property (nonatomic, assign) NSInteger selectIndex;



/**
 *  快速根据配置参数, 创建选项卡
 *
 *  @param config 选项卡配置模型
 *
 *  @return 选项卡
 */
+ (instancetype)segmentBarWithConfig: (TKSegmentConfig *)config;

- (void)updateWithConfig: (void(^)(TKSegmentConfig *config))configBlock;

@end
