#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MainModuleAPI.h"
#import "TitanNavigationController.h"
#import "TitanTabBarController.h"
#import "TitanMiddleView.h"
#import "TitanNavBar.h"
#import "TitanTabBar.h"

FOUNDATION_EXPORT double MainMoudleVersionNumber;
FOUNDATION_EXPORT const unsigned char MainMoudleVersionString[];

