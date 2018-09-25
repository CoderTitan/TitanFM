//
//  TKCategoryViewModel.h
//  All
//
//  Created by 田全军 on 2018/9/17.
//  Copyright © 2018年 田全军. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TKMenueModel;
@class TKAdPicModel;
@class TKClassItemModel;

@interface TKCategoryViewModel : NSObject

+ (instancetype)shareInstance;

/**
 *  获取分类模块的 "图文菜单"
 *
 *  @param result 图文菜单列表
 */
- (void)getPicMenueList:(void(^)(NSArray <TKMenueModel *> *menuePicMs, NSError *error))result;


/**
 *  获取分类模块的  "广告列表"
 *
 *  @param result 广告列表
 */
- (void)getAdList:(void(^)(NSArray <TKAdPicModel *> *adModels, NSError *error))result;

/**
 *  获取分类模块的  "选项列表"
 *
 *  @param result 选项列表
 */
- (void)getClassItemList:(void(^)(NSArray *classItemMs, NSError *error))result;


@end
