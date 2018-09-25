//
//  UIView+SegLayout.h
//  TKSegmentBar_Example
//
//  Created by quanjunt on 2018/9/20.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SegLayout)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;


/**
 *  返回当前视图, 所处的控制器
 *
 *  @return 控制器
 */
- (UIViewController *)currentViewController;


@end

NS_ASSUME_NONNULL_END
