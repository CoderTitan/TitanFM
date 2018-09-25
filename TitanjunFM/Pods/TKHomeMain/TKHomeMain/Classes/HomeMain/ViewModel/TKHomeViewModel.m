//
//  TKHomeViewModel.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKHomeViewModel.h"
#import "TitanSessionManager.h"
#import "MJExtension.h"
#import "Sington.h"
#import "BaseConstant.h"

@interface TKHomeViewModel()

@property (nonatomic, strong) TitanSessionManager *manager;

@end

@implementation TKHomeViewModel
singtonImplement(TKHomeViewModel);

- (TitanSessionManager *)manager {
    if (!_manager) {
        _manager = [[TitanSessionManager alloc] init];
    }
    return _manager;
}


- (void)getHomeTabs: (void(^)(NSArray <TKHomeTabModel *> *tabModels))resultBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v1/tabs"];
    NSDictionary *param = @{
                            @"device": @"iPhone"
                            };
    
    [self.manager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        NSArray <NSDictionary *>*dicArray = (NSArray <NSDictionary *>*)responseObject[@"tabs"][@"list"];
        NSMutableArray *menueItems = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            
            [menueItems addObject:dic[@"title"]];
            
        }
        resultBlock(menueItems);
    }];
}



@end
