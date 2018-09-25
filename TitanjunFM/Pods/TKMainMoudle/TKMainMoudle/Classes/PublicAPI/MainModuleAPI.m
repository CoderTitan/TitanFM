//
//  MainModuleAPI.m
//  MainModule
//
//  Created by quanjunt on 2018/8/29.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "MainModuleAPI.h"
#import "TitanTabBar.h"
#import "TitanTabBarController.h"
#import "TitanNavBar.h"
#import "TitanMiddleView.h"

@implementation MainModuleAPI

+ (TitanTabBarController *)rootTabBarCcontroller {
    return [TitanTabBarController shareInstance];
}


+ (void)addChildVC:(UIViewController *)vc normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName isRequiredNavController:(BOOL)isRequired {
    
    [[TitanTabBarController shareInstance] addChildVC:vc normalImageName:normalImageName selectedImageName:selectedImageName isRequiredNavController:isRequired];
}


+ (void)setTabbarMiddleBtnClick: (void(^)(BOOL isPlaying))middleClickBlock {
    
    TitanTabBar *tabbar = (TitanTabBar *)[TitanTabBarController shareInstance].tabBar;
    tabbar.middleClickBlock = middleClickBlock;
}

/**
 *  设置全局的导航栏背景图片
 *
 *  @param globalImg 全局导航栏背景图片
 */
+ (void)setNavBarGlobalBackGroundImage: (UIImage *)globalImg {
    [TitanNavBar setGlobalBackGroundImage:globalImg];
}

/**
 *  设置全局导航栏标题颜色, 和文字大小
 *
 *  @param globalTextColor 全局导航栏标题颜色
 *  @param fontSize        全局导航栏文字大小
 */
+ (void)setNavBarGlobalTextColor: (UIColor *)globalTextColor andFontSize: (CGFloat)fontSize {
    
    [TitanNavBar setGlobalTextColor:globalTextColor andFontSize:fontSize];
}

+ (UIView *)middleView {
    return [TitanMiddleView middleView];
}

@end
