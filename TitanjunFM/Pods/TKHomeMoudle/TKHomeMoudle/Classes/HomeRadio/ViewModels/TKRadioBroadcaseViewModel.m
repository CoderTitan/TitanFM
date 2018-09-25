//
//  TKRadioBroadcaseViewModel.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRadioBroadcaseViewModel.h"
#import "TitanSessionManager.h"
#import "BaseConstant.h"
#import "MJExtension.h"
#import "Sington.h"

@interface TKRadioBroadcaseViewModel ()

@property (nonatomic, strong) TitanSessionManager *sessionManager;
@end

@implementation TKRadioBroadcaseViewModel
singtonImplement(TKRadioBroadcaseViewModel)

- (TitanSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[TitanSessionManager alloc]init];
    }
    return _sessionManager;
}

/**
 *  获取广播模块 "分类列表"
 *
 *  @param result 分类列表
 */
- (void) getCategoriesList:(void (^)(NSMutableArray <TKRedioCategoryModel *> *categorieModels, NSError *error))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLiveUrl, @"live-web/v4/homepage"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone"
                            };
    
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSMutableArray *categorieMs = [TKRedioCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"categories"]];
        
        TKRedioCategoryModel *lastModel = [TKRedioCategoryModel new];
        lastModel.isLast = YES;
        [categorieMs addObject:lastModel];
        
        result(categorieMs, error);
    }];
}

/**
 *  获取广播模块 "当地电台列表"
 *
 *  @param result 当地电台列表
 */
- (void)getLocalRadioList:(void(^)(TKRadioArrModel *radioModels, NSError *error))result {
    //http://live.ximalaya.com/live-web/v4/homepage
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLiveUrl, @"live-web/v4/homepage"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            };
    
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        TKRadioArrModel *radioMs = [TKRadioArrModel new];
        
        [TKRedioModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"playUrl" : @"playUrl"
                     };
        }];
        
        NSArray *models = [TKRedioModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"localRadios"]];
        radioMs.modelArr = models;
        radioMs.location = responseObject[@"data"][@"location"];
        radioMs.sortID = 1;
        
        result(radioMs, error);
    }];
}

/**
 *  获取广播模块 "排行榜列表"
 *
 *  @param result 排行榜列表
 */
- (void)getTopRadioList:(void(^)(TKRadioArrModel *radioModels, NSError *error))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLiveUrl, @"live-web/v4/homepage"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            };
    
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        TKRadioArrModel *radioMs = [TKRadioArrModel new];
        [TKRedioModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"playUrl" : @"playUrl"
                     };
        }];
        NSArray *models = [TKRedioModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"topRadios"]];
        radioMs.modelArr = models;
        radioMs.location = @"排行榜";
        radioMs.sortID = 2;
        result(radioMs, error);
    }];
}

/**
 *  获取广播模块 "各个电台的详细数据"
 *
 *  @param result 各个电台的详细数据
 */
- (void) getRadioCategoriesListWithId:(NSInteger) Id resultBlock: (void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLiveUrl, @"live-web/v2/radio/category"];
    
    NSDictionary *param = @{
                            @"categoryId": @(Id),
                            @"device": @"iPhone",
                            @"pageNum": @"1",
                            @"pageSize": @"30"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKRedioModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"playUrl" : @"playUrl"
                     };
        }];
        
        NSMutableArray *radioMs = [TKRedioModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        result(radioMs, error);
    }];
}

/**
 *  获取本地更多列表
 *
 *  @param result 更多列表
 */
- (void) getRadioLocalMore:(void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLiveUrl, @"live-web/v1/radio/local"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"pageNum": @"1",
                            @"pageSize": @"30"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKRedioModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"playUrl" : @"playUrl"
                     };
        }];
        
        NSMutableArray *radioMs = [TKRedioModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        result(radioMs, error);
    }];
}

/**
 *  获取排行榜更多列表
 *
 *  @param result 更多列表
 */
- (void) getRadioHotMore:(void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLiveUrl, @"live-web/v3/radio/hot"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"pageNum": @"1",
                            @"pageSize": @"30"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKRedioModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"playUrl" : @"playUrl"
                     };
        }];
        
        NSMutableArray *radioMs = [TKRedioModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        result(radioMs, error);
    }];
}

/**
 *  获取本地台数据列表
 *
 *  @param result 本地台数据列表
 */

- (void) getRadioProvince:(void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLiveUrl, @"live-web/v2/radio/province"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"pageNum": @"1",
                            @"pageSize": @"30",
                            @"provinceCode": @"440000"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKRedioModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"playUrl" : @"playUrl"
                     };
        }];
        
        NSMutableArray *radioMs = [TKRedioModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        result(radioMs, error);
    }];
}
/**
 *  获取国家台数据列表
 *
 *  @param result 国家台数据列表
 */

- (void) getRadioNational:(void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLiveUrl, @"live-web/v2/radio/national"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"pageNum": @"1",
                            @"pageSize": @"30"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKRedioModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"playUrl" : @"playUrl"
                     };
        }];
        
        NSMutableArray *radioMs = [TKRedioModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        result(radioMs, error);
    }];
}

/**
 *  获取网络台数据列表
 *
 *  @param result 网络台数据列表
 */

- (void) getRadioNetwork:(void (^)(NSMutableArray <TKRedioModel *>*radioMs, NSError *error))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLiveUrl, @"live-web/v2/radio/network"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"pageNum": @"1",
                            @"pageSize": @"30"
                            };
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKRedioModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"playUrl" : @"playUrl"
                     };
        }];
        
        NSMutableArray *radioMs = [TKRedioModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        result(radioMs, error);
    }];
}

@end
