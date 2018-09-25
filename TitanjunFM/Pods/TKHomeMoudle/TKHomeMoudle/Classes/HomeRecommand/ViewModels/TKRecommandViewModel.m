//
//  TKRecommandViewModel.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRecommandViewModel.h"
#import "BaseConstant.h"
#import "TitanSessionManager.h"
#import "MJExtension.h"
#import "NSArray+Partition.h"
#import "Sington.h"
#import "TKAdPicModel.h"
#import "TKMenueModel.h"
#import "TKItemCellModel.h"
#import "TKSpecialColumnModel.h"

@interface TKRecommandViewModel()

@property (nonatomic, strong) TitanSessionManager *sessionManager;

@end

@implementation TKRecommandViewModel
singtonImplement(TKRecommandViewModel)

- (TitanSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[TitanSessionManager alloc]init];
    }
    return _sessionManager;
}

/**
 *  获取发现模块的菜单列表
 *
 *  @param result 菜单列表
 */
- (void)getDiscoverMenueList:(void(^)(NSArray <NSString *>*menueList, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v1/tabs"];
    NSDictionary *param = @{ @"device": @"iPhone" };
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSArray <NSDictionary *>*dicArray = (NSArray <NSDictionary *>*)responseObject[@"tabs"][@"list"];
        NSMutableArray *menueItems = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            
            [menueItems addObject:dic[@"title"]];
            
        }
        result(menueItems, error);
    }];
}


/**
 *  获取发现模块的  "广告列表"
 *
 *  @param result 广告列表
 */
- (void)getAdList:(void(^)(NSArray <TKAdPicModel *>*adMs, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v4/recommends"];
    NSDictionary *param = @{
                            @"channel": @"ios-b1",
                            @"device": @"iPhone",
                            @"includeActivity": @(YES),
                            @"includeSpecial": @(YES),
                            @"scale": @2,
                            @"version": @"5.4.21"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSArray *focusImageMs = [TKFocusImageModel mj_objectArrayWithKeyValuesArray:responseObject[@"focusImages"][@"list"]];
        
        NSMutableArray *adPicMs = [NSMutableArray array];
        for (TKFocusImageModel *focusImageM in focusImageMs) {
            TKAdPicModel *adPicM = [[TKAdPicModel alloc] init];
            adPicM.focusImageM = focusImageM;
            [adPicMs addObject:adPicM];
        }
        
        result(adPicMs, error);
    }];
}


/**
 *  获取发现模块的 "图文菜单"
 *
 *  @param result 图文菜单列表
 */
- (void)getPicMenueList:(void(^)(NSArray <TKMenueModel *>*menuePicMs, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/recommend/hotAndGuess"];
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"version": @"5.4.21"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSArray *menuePicMs = [TKMenueModel mj_objectArrayWithKeyValuesArray:responseObject[@"discoveryColumns"][@"list"]];
        
        result(menuePicMs, error);
    }];
}

/**
 *  获取发现模块的  "小编推荐"
 *
 *  @param result 小编推荐
 */
- (void)getEditorRecommendAlbums:(void(^)(TKGroupModel *groupM, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v4/recommends"];
    NSDictionary *param = @{
                            @"channel": @"ios-b1",
                            @"device": @"iPhone",
                            @"includeActivity": @(YES),
                            @"includeSpecial": @(YES),
                            @"scale": @2,
                            @"version": @"5.4.21"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKGroupModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"list": [TKItemCellModel class]
                     };
        }];
        
        NSDictionary *dic = responseObject[@"editorRecommendAlbums"];
        TKGroupModel *groupM = [TKGroupModel mj_objectWithKeyValues:dic];
        groupM.cellType = CellTypeList3;
        result(groupM, error);
    }];
}

/**
 *  获取小编推荐更多数据
 *
 *  @param result 小编推荐更多数据
 */
- (void)getRecommendEditorList:(void (^)(NSArray <TKNominateEditorModel *>*editorMs, NSError *error))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v1/recommend/editor"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"pageId": @"1",
                            @"pageSize": @"20"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSArray *editorMs = [TKNominateEditorModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        result(editorMs, error);
    }];
}

/**
 *  获取发现模块的  "现场直播"
 *
 *  @param result 现场直播
 */
- (void)getLiveMs:(void(^)(TKGroupModel *groupM, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kLiveUrl, @"live-activity-web/v3/activity/recommend"];
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:nil resultBlock:^(id responseObject, NSError *error) {
        NSArray *liveMs = [TKLiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        TKGroupModel *groupM = [[TKGroupModel alloc] init];
        groupM.cellType = CellTypeList1;
        groupM.title = @"现场直播";
        groupM.hasMore = true;
        groupM.liveMs = liveMs;
        
        result(groupM, error);
    }];
}


/**
 *  获取发现模块的  "精品听单"
 *
 *  @param result 精品听单
 */
- (void)getSpecialColumnMs:(void(^)(TKGroupModel *groupM, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v4/recommends"];
    NSDictionary *param = @{
                            @"channel": @"ios-b1",
                            @"device": @"iPhone",
                            @"includeActivity": @(YES),
                            @"includeSpecial": @(YES),
                            @"scale": @2,
                            @"version": @"5.4.21"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKGroupModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"list": [TKSpecialColumnModel class]
                     };
        }];
        
        NSDictionary *dic = responseObject[@"specialColumn"];
        TKGroupModel *groupM = [TKGroupModel mj_objectWithKeyValues:dic];
        groupM.cellType = CellTypeList2;
        
        result(groupM, error);
    }];
}


/**
 *  获取发现模块的  "推广"
 *
 *  @param result 推广
 */
- (void)getTuiGuangMs:(void(^)(TKGroupModel *groupM, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kAdUrl, @"/ting/feed"];
    
    NSDictionary *param = @{
                            @"appid": @"0",
                            @"device": @"iPhone",
                            @"name": @"find_native",
                            @"network": @"WIFI",
                            @"operator": @3,
                            @"scale": @2,
                            @"version": @"5.4.21"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKPromotionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return  @{
                      @"Description": @"description",
                      @"Auto" : @"auto"
                      };
        }];
        
        NSArray *tuiguangMs = [TKPromotionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        TKGroupModel *groupM = [[TKGroupModel alloc] init];
        groupM.cellType = CellTypeList1;
        groupM.title = @"推广";
        groupM.hasMore = true;
        groupM.tuiguangMs = tuiguangMs;
        
        result(groupM, error);
    }];
}

/**
 *  获取发现模块的  "听广州"
 *
 *  @param result 听广州
 */
- (void)getCityAlbums:(void(^)(TKGroupModel *groupM, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/recommend/hotAndGuess"];
    NSDictionary *param = @{
                            @"code": @"43_440000_4401",
                            @"device": @"iPhone",
                            @"version": @"5.4.21"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKGroupModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"list": [TKItemCellModel class]
                     };
        }];
        
        TKGroupModel *groupM = [TKGroupModel mj_objectWithKeyValues:responseObject[@"cityColumn"]];
        
        groupM.cellType = CellTypeList3;
        result(groupM, error);
    }];
}

/**
 *  获取发现模块的  "热门推荐-听其他"
 *
 *  @param result "热门推荐-听其他"
 */
- (void)getHotRecommendsAlbums:(void(^)(NSArray <TKGroupModel *> *groupMs, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/recommend/hotAndGuess"];
    NSDictionary *param = @{
                            @"code": @"43_440000_4401",
                            @"device": @"iPhone",
                            @"version": @"5.4.21"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKGroupModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"list": [TKItemCellModel class]
                     };
        }];
        
        
        NSArray *groupMs = [TKGroupModel mj_objectArrayWithKeyValuesArray:responseObject[@"hotRecommends"][@"list"]];
        
        [groupMs enumerateObjectsUsingBlock:^(TKGroupModel *groupM, NSUInteger idx, BOOL * _Nonnull stop) {
            groupM.sortID = 10 + idx;
            groupM.cellType = CellTypeList3;
        }];
        
        result(groupMs, error);
    }];
}


@end
