//
//  TitanNavigationController.m
//  MainModule
//
//  Created by quanjunt on 2018/8/24.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TitanNavigationController.h"
#import "TitanNavBar.h"
#import "TitanMiddleView.h"

@interface TitanNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation TitanNavigationController

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self setValue:[[TitanNavBar alloc] init] forKey:@"navigationBar"];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置手势代理
    UIGestureRecognizer *gester = self.interactivePopGestureRecognizer;
    
    // 自定义手势
    // 手势加在谁身上, 手势执行谁的什么方法
    UIPanGestureRecognizer *panGester = [[UIPanGestureRecognizer alloc] initWithTarget:gester.delegate action:NSSelectorFromString(@"handleNavigationTransition:")];
    // 其实就是控制器的容器视图
    [gester.view addGestureRecognizer:panGester];
    
    gester.delaysTouchesBegan = YES;
    panGester.delegate = self;
}

- (void)back {
    
    [self popViewControllerAnimated:YES];
}



/**
 *  当控制器, 拿到导航控制器(需要是这个子类), 进行压栈时, 都会调用这个方法
 *
 *  @param viewController 要压栈的控制器
 *  @param animated       动画
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 拦截每一个push的控制器, 进行统一设置
    // 过滤第一个根控制器
    if (self.childViewControllers.count > 0) {
        //        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem customBackItemWithTarget:self action:@selector(back)];
        
        //统一设置返回按钮
        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [currentBundle pathForResource:@"btn_back_n@2x.png" ofType:nil inDirectory:@"MainMoudle.bundle"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:0 target:self action:@selector(back)];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 千万不要忘记写
    [super pushViewController:viewController animated:animated];
    
    if (viewController.view.tag == 666) {
        viewController.view.tag = 888;
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
        [viewController.view addSubview:middleView];
    }
}



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果根控制器也要返回手势有效, 就会造成假死状态
    // 所以, 需要过滤根控制器
    if(self.childViewControllers.count == 1) {
        return NO;
    }
    
    return YES;
}

@end
