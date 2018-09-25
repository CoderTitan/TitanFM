//
//  TKCategoryViewModel.m
//  All
//
//  Created by 田全军 on 2018/9/17.
//  Copyright © 2018年 田全军. All rights reserved.
//

#import "TKCategoryViewModel.h"
#import "BaseConstant.h"
#import "TitanSessionManager.h"
#import "MJExtension.h"
#import "NSArray+Partition.h"
#import "Sington.h"

#import "TKMenueModel.h"
#import "TKAdPicModel.h"
#import "TKClassItemModel.h"


@interface TKCategoryViewModel()

@property (nonatomic, strong) TitanSessionManager *sessionManager;

@end


@implementation TKCategoryViewModel
singtonImplement(TKCategoryViewModel)

- (TitanSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[TitanSessionManager alloc]init];
    }
    return _sessionManager;
}

/**
 *  获取分类模块的 "图文菜单"
 *
 *  @param result 图文菜单列表
 */
- (void)getPicMenueList:(void(^)(NSArray <TKMenueModel *> *menuePicMs, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/categories"];
    NSDictionary *param = @{
                            @"channel": @"ios-b1",
                            @"device": @"iPhone",
                            @"version": @"5.4.21",
                            @"picVersion": @13,
                            @"scale": @2
                            };
    
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSArray *menuePicMs = [TKMenueModel mj_objectArrayWithKeyValuesArray:responseObject[@"discoveryColumns"][@"list"]];
        
        result(menuePicMs, error);
    }];
}


/**
 *  获取分类模块的  "广告列表"
 *
 *  @param result 广告列表
 */
- (void)getAdList:(void(^)(NSArray <TKAdPicModel *> *adModels, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/categories"];
    NSDictionary *param = @{
                            
                            @"channel": @"ios-b1",
                            @"device": @"iPhone",
                            @"version": @"5.4.21",
                            @"picVersion": @13,
                            @"scale": @2
                            };
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSArray *classItemMs = [TKClassItemModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        NSMutableArray *adPicMs = [NSMutableArray array];
        
        TKAdPicModel *adPicM = [[TKAdPicModel alloc] init];
        adPicM.classItemM = [classItemMs firstObject];
        [adPicMs addObject:adPicM];
        
        result(adPicMs, error);
    }];
}

/**
 *  获取分类模块的  "选项列表"
 *
 *  @param result 选项列表
 */
- (void)getClassItemList:(void(^)(NSArray *classItemMs, NSError *error))result {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/categories"];
    NSDictionary *param = @{
                            
                            @"channel": @"ios-b1",
                            @"device": @"iPhone",
                            @"version": @"5.4.21",
                            @"picVersion": @13,
                            @"scale": @2
                            };
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSArray *classItemMs = [TKClassItemModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 将一个大数组按照指定的个数切成小数组
        NSArray *resultMs = [classItemMs partitionArrayWithStart:1 Count:6];
        
        result(resultMs, error);
    }];
}


@end
