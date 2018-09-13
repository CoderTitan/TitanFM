//
//  TitanTabBar.h
//  MainModule
//
//  Created by quanjunt on 2018/8/24.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitanMiddleView;
@interface TitanTabBar : UITabBar

@property (nonatomic, weak) TitanMiddleView *middleView;
/**
 点击中间按钮的执行代码块
 */
@property (nonatomic, copy) void(^middleClickBlock)(BOOL isPlaying);


@end
