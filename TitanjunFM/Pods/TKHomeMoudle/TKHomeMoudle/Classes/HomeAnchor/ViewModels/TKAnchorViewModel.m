//
//  TKAnchorViewModel.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKAnchorViewModel.h"
#import "BaseConstant.h"
#import "Sington.h"
#import "TitanSessionManager.h"
#import "MJExtension.h"

@interface TKAnchorViewModel()

@property (nonatomic, strong) TitanSessionManager *sessionManager;

@end
@implementation TKAnchorViewModel
singtonImplement(TKAnchorViewModel)

- (TitanSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[TitanSessionManager alloc] init];
    }
    return _sessionManager;
}

- (void)getAnchorMs:(void (^)(NSArray<TKAnchorGroupModel *> * _Nonnull))resultBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v1/anchor/recommend"];
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"version": @"5.4.39"
                            };
    
    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {
        [TKAnchorGroupModel mj_setupObjectClassInArray:^NSDictionary *{
            return  @{
                      @"list" : @"TKAnchorModel"
                      };
        }];
        
        NSMutableArray <TKAnchorGroupModel *> *famouArr = [TKAnchorGroupModel mj_objectArrayWithKeyValuesArray:responseObject[@"famous"]];
        NSMutableArray <TKAnchorGroupModel *> *normalArr = [TKAnchorGroupModel mj_objectArrayWithKeyValuesArray:responseObject[@"normal"]];
        
        resultBlock([famouArr arrayByAddingObjectsFromArray:normalArr]);
    }];
}
@end
