//
//  TitanTabBarController.m
//  MainModule
//
//  Created by quanjunt on 2018/8/24.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TitanTabBarController.h"
#import "TitanTabBar.h"
#import "TitanMiddleView.h"
#import "TitanNavigationController.h"
#import "UIImage+Image.h"

@interface TitanTabBarController ()

@end

@implementation TitanTabBarController

+ (instancetype)shareInstance {
    
    static TitanTabBarController *tabbarC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbarC = [[TitanTabBarController alloc] init];
    });
    return tabbarC;
}

+ (instancetype)tabBarControllerWithAddChildVCsBlock: (void(^)(TitanTabBarController *tabBarC))addVCBlock {
    
    TitanTabBarController *tabbarVC = [[TitanTabBarController alloc] init];
    if (addVCBlock) {
        addVCBlock(tabbarVC);
    }
    
    return tabbarVC;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tabbar
    [self setUpTabbar];
    
}

- (void)setUpTabbar {
    [self setValue:[[TitanTabBar alloc] init] forKey:@"tabBar"];
}

/**
 *  根据参数, 创建并添加对应的子控制器
 *
 *  @param vc                需要添加的控制器(会自动包装导航控制器)
 *  @param isRequired             标题
 *  @param normalImageName   一般图片名称
 *  @param selectedImageName 选中图片名称
 */
- (void)addChildVC: (UIViewController *)vc normalImageName: (NSString *)normalImageName selectedImageName:(NSString *)selectedImageName isRequiredNavController: (BOOL)isRequired {
    
    if (isRequired) {
        TitanNavigationController *nav = [[TitanNavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage originImageWithName:normalImageName] selectedImage:[UIImage originImageWithName:selectedImageName]];
        
        [self addChildViewController:nav];
    }else {
        [self addChildViewController:vc];
    }
    
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    
    UIViewController *vc = self.childViewControllers[selectedIndex];
    if (vc.view.tag == 666) {
        vc.view.tag = 888;
        
        TitanMiddleView *middleView = [TitanMiddleView middleView];
        middleView.middleClickBlock = [TitanMiddleView shareInstance].middleClickBlock;
        middleView.isPlaying = [TitanMiddleView shareInstance].isPlaying;
        middleView.middleImg = [TitanMiddleView shareInstance].middleImg;
        CGRect frame = middleView.frame;
        frame.size.width = 65;
        frame.size.height = 65;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        frame.origin.x = (screenSize.width - 65) * 0.5;
        frame.origin.y = screenSize.height - 65;
        middleView.frame = frame;
        [vc.view addSubview:middleView];
    }
}

@end
