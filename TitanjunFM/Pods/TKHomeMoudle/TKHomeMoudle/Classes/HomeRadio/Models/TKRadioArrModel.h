//
//  TKRadioArrModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TKRedioModel;
@interface TKRadioArrModel : NSObject

@property (nonatomic, assign) int sortID;
@property (nonatomic, copy)NSString *location;
@property (nonatomic, strong)NSArray <TKRedioModel *> *modelArr;

@end

NS_ASSUME_NONNULL_END
