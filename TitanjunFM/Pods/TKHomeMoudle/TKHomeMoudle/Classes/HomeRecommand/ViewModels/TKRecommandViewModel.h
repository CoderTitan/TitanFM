//
//  TKRecommandViewModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TKAdPicModel;
@class TKMenueModel;
#import "TKGroupModel.h"
#import "TKNominateEditorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKRecommandViewModel : NSObject

+ (instancetype)shareInstance;


/**
 *  获取发现模块的菜单列表
 *
 *  @param result 菜单列表
 */
- (void)getDiscoverMenueList:(void(^)(NSArray <NSString *>*menueList, NSError *error))result;


/**
 *  获取发现模块的  "广告列表"
 *
 *  @param result 广告列表
 */
- (void)getAdList:(void(^)(NSArray <TKAdPicModel *>*adMs, NSError *error))result;


/**
 *  获取发现模块的 "图文菜单"
 *
 *  @param result 图文菜单列表
 */
- (void)getPicMenueList:(void(^)(NSArray <TKMenueModel *>*menuePicMs, NSError *error))result;

/**
 *  获取发现模块的  "小编推荐"
 *
 *  @param result 小编推荐
 */
- (void)getEditorRecommendAlbums:(void(^)(TKGroupModel *groupM, NSError *error))result;

/**
 *  获取小编推荐更多数据
 *
 *  @param result 小编推荐更多数据
 */
- (void)getRecommendEditorList:(void (^)(NSArray <TKNominateEditorModel *>*editorMs, NSError *error))result;

/**
 *  获取发现模块的  "现场直播"
 *
 *  @param result 现场直播
 */
- (void)getLiveMs:(void(^)(TKGroupModel *groupM, NSError *error))result;


/**
 *  获取发现模块的  "精品听单"
 *
 *  @param result 精品听单
 */
- (void)getSpecialColumnMs:(void(^)(TKGroupModel *groupM, NSError *error))result;


/**
 *  获取发现模块的  "推广"
 *
 *  @param result 推广
 */
- (void)getTuiGuangMs:(void(^)(TKGroupModel *groupM, NSError *error))result;

/**
 *  获取发现模块的  "听广州"
 *
 *  @param result 听广州
 */
- (void)getCityAlbums:(void(^)(TKGroupModel *groupM, NSError *error))result;

/**
 *  获取发现模块的  "热门推荐-听其他"
 *
 *  @param result "热门推荐-听其他"
 */
- (void)getHotRecommendsAlbums:(void(^)(NSArray <TKGroupModel *> *groupMs, NSError *error))result;


@end

NS_ASSUME_NONNULL_END
