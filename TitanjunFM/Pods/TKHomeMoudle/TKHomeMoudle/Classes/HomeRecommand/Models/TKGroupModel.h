//
//  TKGroupModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    CellTypeList3,
    CellTypeList2,
    CellTypeList1
}CellType;

@class TKLiveModel;
@class TKPromotionModel;
@interface TKGroupModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL hasMore;


@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray <TKLiveModel *>*liveMs;
@property (nonatomic, strong) NSArray <TKPromotionModel *>*tuiguangMs;

@property (nonatomic, assign) CellType cellType;
@property (nonatomic, assign) NSInteger sortID;

@end

NS_ASSUME_NONNULL_END
