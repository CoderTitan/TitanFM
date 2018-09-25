//
//  TKRankingListModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TKRankingInfoModel;
@interface TKRankingListModel : NSObject

@property (nonatomic, assign)NSInteger ret;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong) NSArray <TKRankingInfoModel *> *list;


@end

NS_ASSUME_NONNULL_END
