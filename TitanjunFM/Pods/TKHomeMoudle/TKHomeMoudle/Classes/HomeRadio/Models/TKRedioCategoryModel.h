//
//  TKRedioCategoryModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKRedioCategoryModel : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isLast; // 用于表示是否最后一个


@end

NS_ASSUME_NONNULL_END
