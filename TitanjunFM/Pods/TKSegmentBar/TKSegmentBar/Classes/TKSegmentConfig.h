//
//  TKSegmentConfig.h
//  TKSegmentBar_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TKSegmentConfig : NSObject

/// 设置默认值
+ (instancetype)defaultConfig;

/** 背景颜色 */
@property (nonatomic, strong) UIColor *segmentBarBackColor;
/** 标签未选中字体颜色 */
@property (nonatomic, strong) UIColor *itemNormalColor;
/** 标签选中字体颜色 */
@property (nonatomic, strong) UIColor *itemSelectColor;
/** 字体大小 */
@property (nonatomic, strong) UIFont *itemFont;
/** 状态指示条颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 状态指示条高度 */
@property (nonatomic, assign) CGFloat indicatorHeight;
/** 状态指示条宽度 */
@property (nonatomic, assign) CGFloat indicatorExtraW;


// 链式编程的改法
- (TKSegmentConfig *(^)(UIColor *color))itemNC;
- (TKSegmentConfig *(^)(UIColor *color))itemSC;

@end
