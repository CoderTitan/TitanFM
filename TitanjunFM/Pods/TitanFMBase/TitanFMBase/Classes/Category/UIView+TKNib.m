//
//  UIView+TKNib.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "UIView+TKNib.h"
#import "NSObject+TKBundle.h"

@implementation UIView (TKNib)

+ (instancetype)loadFromNib {
    UIView *view = [[self currentBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    return view;
}

/**
 *  返回当前视图, 所处的控制器
 *
 *  @return 控制器
 */
- (UIViewController *)currentViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
