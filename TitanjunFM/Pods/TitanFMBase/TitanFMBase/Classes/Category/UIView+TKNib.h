//
//  UIView+TKNib.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TKNib)

+ (instancetype)loadFromNib;

/**
 *  返回当前视图, 所处的控制器
 *
 *  @return 控制器
 */
- (UIViewController *)currentViewController;

@end
