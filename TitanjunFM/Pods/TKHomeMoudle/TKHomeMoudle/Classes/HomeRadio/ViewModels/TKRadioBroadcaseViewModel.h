//
//  TKRadioBroadcaseViewModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKRedioCategoryModel.h"
#import "TKRedioModel.h"
#import "TKRadioArrModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface TKRadioBroadcaseViewModel : NSObject

+ (instancetype)shareInstance;


/**
 *  获取广播模块 "分类列表"
 *
 *  @param result 分类列表
 */
- (void) getCategoriesList:(void (^)(NSMutableArray <TKRedioCategoryModel *> *categorieModels, NSError *error))result;

/**
 *  获取广播模块 "当地电台列表"
 *
 *  @param result 当地电台列表
 */
- (void)getLocalRadioList:(void(^)(TKRadioArrModel *radioModels, NSError *error))result;

/**
 *  获取广播模块 "排行榜列表"
 *
 *  @param result 排行榜列表
 */
- (void)getTopRadioList:(void(^)(TKRadioArrModel *radioModels, NSError *error))result;



/**
 *  获取广播模块 "各个电台的详细数据"
 *
 *  @param result 各个电台的详细数据
 */
- (void) getRadioCategoriesListWithId:(NSInteger) Id resultBlock: (void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result;

/**
 *  获取本地更多列表
 *
 *  @param result 更多列表
 */
- (void) getRadioLocalMore:(void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result;

/**
 *  获取排行榜更多列表
 *
 *  @param result 更多列表
 */
- (void) getRadioHotMore:(void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result;

/**
 *  获取本地台数据列表
 *
 *  @param result 本地台数据列表
 */

- (void) getRadioProvince:(void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result;
/**
 *  获取国家台数据列表
 *
 *  @param result 国家台数据列表
 */

- (void) getRadioNational:(void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result;

/**
 *  获取网络台数据列表
 *
 *  @param result 网络台数据列表
 */

- (void) getRadioNetwork:(void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result;

@end

NS_ASSUME_NONNULL_END
