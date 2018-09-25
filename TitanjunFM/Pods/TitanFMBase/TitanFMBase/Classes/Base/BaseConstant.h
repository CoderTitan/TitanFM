//
//  BaseConstant.h
//  MainModule
//
//  Created by quanjunt on 2018/8/28.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#ifndef BaseConstant_h
#define BaseConstant_h

#define kBaseUrl @"http://mobile.ximalaya.com/"
#define kLiveUrl @"http://live.ximalaya.com/"
#define kAdUrl @"http://adse.ximalaya.com/"
#define kAlbumUrl @"http://ar.ximalaya.com/"
#define kHybridUrl @"http://hybrid.ximalaya.com/"

// 如果是调试模式(DEBUG 是调试模式下, 自带的宏)
#ifdef DEBUG
#define TitanLog(...) NSLog(__VA_ARGS__);
#else
#define TitanLog(...)
#endif

// 打印调用函数的宏
#define TitanLogFunc TitanLog(@"%s",__func__);

// 颜色
#define backColor [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1]
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TitanColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define TitanAlphaColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define TitanRandomColor TitanColor(arc4random_uniform(255.0), arc4random_uniform(255.0), arc4random_uniform(255.0))
#define kCommonColor TitanColor(223, 223, 223)

// 屏幕尺寸相关
#define kScreenBounds [[UIScreen mainScreen] bounds]
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
// 共有的间距
#define kCommonMargin  10
// 发现 顶部 菜单栏的高度
#define kMenueBarHeight 35
// 导航栏的高度
#define kNavigationBarMaxY 64
// tabbar的高度
#define kTabbarHeight 0


// 弱引用
#define kWeakSelf __weak typeof(self) weakSelf = self;


#endif /* BaseConstant_h */
