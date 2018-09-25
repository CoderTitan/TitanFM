//
//  TKRadioCategoryController.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM (NSInteger, LoadDataType){
    LoadDataRadioCategories,        //各个电台的详细数据
    LoadDataRadioLocalMore,         // 当地更多列表
    LoadDataRadioHotMore,           // 排行榜更多列表
    LoadDataRadioProvince,          // 本地台列表
    LoadDataRadioNational,          //国家台列表
    LoadDataProvince,               //省市台
    LoadDataRadioNetwork            //网络台
};

@class TKRedioCategoryModel;
@interface TKRadioCategoryController : UITableViewController

@property (nonatomic, strong)TKRedioCategoryModel *radioModel;

@property (nonatomic, copy)NSString *navTitle;

/**
 *  需要加载的数据类型
 */
@property (nonatomic, assign)LoadDataType type;


@end

NS_ASSUME_NONNULL_END
