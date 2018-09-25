//
//  TKRankViewModel.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRankViewModel.h"
#import "BaseConstant.h"
#import "TitanSessionManager.h"
#import "MJExtension.h"
#import "NSArray+Partition.h"
#import "Sington.h"

#import "TKRankingListModel.h"
#import "TKRankingInfoModel.h"
#import "TKAdPicModel.h"
#import "TKFocusImageModel.h"

@interface TKRankViewModel()

@property (nonatomic, strong) TitanSessionManager *sessionManager;

@end

@implementation TKRankViewModel
singtonImplement(TKRankViewModel)

- (TitanSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[TitanSessionManager alloc]init];
    }
    return _sessionManager;
}

- (void)getAdList:(void (^)(NSArray<TKAdPicModel *> * _Nonnull, NSError * _Nonnull))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/rankingList/group"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"channel": @"ios-b1",
                            @"includeActivity": @"true",
                            @"includeSpecial": @"true",
                            @"scale": @"2",
                            @"version": @"5.4.21"
                            };
    
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSArray *focusImageMs = [TKFocusImageModel mj_objectArrayWithKeyValuesArray:responseObject[@"focusImages"][@"list"]];
        
        NSMutableArray *adPicMs = [NSMutableArray array];
        
        TKAdPicModel *adPicM = [[TKAdPicModel alloc] init];
        adPicM.focusImageM = [focusImageMs firstObject];
        [adPicMs addObject:adPicM];
        
        result(adPicMs, error);
    }];
}


- (void)getClassItemList:(void (^)(NSArray * classItemMs, NSError * error))result {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"/mobile/discovery/v2/rankingList/group"];
    
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"channel": @"ios-b1",
                            @"includeActivity": @"true",
                            @"includeSpecial": @"true",
                            @"scale": @"2",
                            @"version": @"5.4.21",
                            @"channel": @"ios-b1"
                            };
    
    [self.sessionManager request:RequestTypeGet urlStr:urlString parameter:param resultBlock:^(id responseObject, NSError *error) {
        
        NSArray<TKRankingListModel *> *rankingListMs = [TKRankingListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"]];
        
        NSMutableArray<TKRankingListModel *> *resultArr = [NSMutableArray array];
        for (TKRankingListModel *listModel in rankingListMs) {
            NSArray *infoModels = [TKRankingInfoModel mj_objectArrayWithKeyValuesArray:listModel.list];
            listModel.list = infoModels;
            [resultArr addObject:listModel];
        }
        
        result(resultArr, error);
    }];
}

//http://mobile.ximalaya.com//mobile/discovery/v2/rankingList/group?device=iPhone&channel=ios-b1&includeActivity=true&includeSpecial=true&scale=2&version=5.4.21
@end
