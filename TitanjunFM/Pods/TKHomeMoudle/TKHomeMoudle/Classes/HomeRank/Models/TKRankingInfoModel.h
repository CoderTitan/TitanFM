//
//  TKRankingInfoModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TKRankingInfoModel : NSObject

@property (nonatomic, strong) NSString * calcPeriod;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString * contentType;
@property (nonatomic, strong) NSString * coverPath;
@property (nonatomic, assign) NSInteger firstId;
@property (nonatomic, strong) NSString * firstTitle;
@property (nonatomic, strong) NSString * key;
@property (nonatomic, strong) NSArray * list;
@property (nonatomic, assign) NSInteger maxPageId;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger period;
@property (nonatomic, assign) NSInteger rankingListId;
@property (nonatomic, strong) NSString * rankingRule;
@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, strong) NSString * subtitle;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger top;
@property (nonatomic, assign) NSInteger totalCount;


@end

NS_ASSUME_NONNULL_END
