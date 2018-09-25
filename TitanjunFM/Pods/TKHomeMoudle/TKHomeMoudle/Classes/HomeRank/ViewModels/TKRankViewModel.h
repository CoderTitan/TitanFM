//
//  TKRankViewModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class TKRankingListModel;
@class TKAdPicModel;
@interface TKRankViewModel : NSObject


+ (instancetype)shareInstance;



/**
 *  获取模块的  "广告列表"
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

NS_ASSUME_NONNULL_END
