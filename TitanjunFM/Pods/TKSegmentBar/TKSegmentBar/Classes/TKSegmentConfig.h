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

/**
 *  控制是否显示更多
 */
@property (nonatomic, assign) BOOL isShowMore;

/** 指示器颜色, 默认红色 */
@property (nonatomic, strong) UIColor *indicatorColor;

/** 指示器高度 */
@property (nonatomic, assign) CGFloat indicatorHeight;

/** 指示器的额外宽度(在跟随字体宽度之外的额外宽度) */
@property (nonatomic, assign) CGFloat indicatorExtraWidth;


/** 选项颜色(普通) */
@property (nonatomic, strong) UIColor *segNormalColor;

/** 选项颜色(选中) */
@property (nonatomic, strong) UIColor *segSelectedColor;

/** 选项字体(普通) */
@property (nonatomic, strong) UIFont *segNormalFont;

/** 选项字体(选中) */
@property (nonatomic, strong) UIFont *segSelectedFont;

/** 选项卡之间的最小间距 */
@property (nonatomic, assign) CGFloat limitMargin;


// 链式编程的改法
- (TKSegmentConfig *(^)(UIColor *color))itemNC;
- (TKSegmentConfig *(^)(UIColor *color))itemSC;

@end
