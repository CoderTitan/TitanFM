//
//  TodayFireViewModel.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"
#import "DownloadVoiceModel.h"

@interface TodayFireViewModel : NSObject
+ (instancetype)shareInstance;

- (void)getTodayFireCategoryModels: (void(^)(NSArray <CategoryModel *>*categoryArr))resultBlock;

- (void)getTodayFireVoiceMsWithKey: (NSString *)key result: (void(^)(NSArray <DownloadVoiceModel *>*voiceArr))resultBlock;
@end
