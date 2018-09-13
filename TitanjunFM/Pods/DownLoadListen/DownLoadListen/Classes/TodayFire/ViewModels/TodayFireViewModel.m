//
//  TodayFireViewModel.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TodayFireViewModel.h"
#import "CategoryModel.h"
#import "MJExtension.h"
#import "TitanSessionManager.h"


#define kBaseUrl @"http://mobile.ximalaya.com/"

@interface TodayFireViewModel ()
@property (nonatomic, strong) TitanSessionManager *sessionManager;
@end

@implementation TodayFireViewModel
#pragma mark - 单例/懒加载
static TodayFireViewModel *_shareInstance;
+ (instancetype)shareInstance {
    if (!_shareInstance) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

- (TitanSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[TitanSessionManager alloc] init];
    }
    return _sessionManager;
}


#pragma mark - 数据处理
- (void)getTodayFireCategoryModels: (void(^)(NSArray <CategoryModel *>*categoryArr))resultBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/rankingList/track"];
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"key": @"ranking:track:scoreByTime:1:0",
                            @"pageId": @"1",
                            @"pageSize": @"0"
                            };
    
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        CategoryModel *model = [[CategoryModel alloc]init];
        model.key = @"ranking:track:scoreByTime:1:0";
        model.name = @"总榜";
        
        NSMutableArray <CategoryModel *> *modelArr = [CategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"categories"]];
        if (modelArr.count > 0) {
            [modelArr insertObject:model atIndex:0];
        }
        resultBlock(modelArr);
    }];
}

- (void)getTodayFireVoiceMsWithKey: (NSString *)key result: (void(^)(NSArray <DownloadVoiceModel *>*voiceArr))resultBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/rankingList/track"];
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"key": key,
                            @"pageId": @"1",
                            @"pageSize": @"30"
                            };
    
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSMutableArray <DownloadVoiceModel *> *voiceModeaArr = [DownloadVoiceModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        resultBlock(voiceModeaArr);
    }];
}

@end
