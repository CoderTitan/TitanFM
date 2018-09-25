//
//  NSArray+Partition.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Partition)

/**
 *  将一个数组切割成多个数组
 *
 *  @param start 从第几个元素开始分割
 *  @param count 每个数组最大个数
 *
 *  @return 切割好的数组
 */
- (NSArray *)partitionArrayWithStart:(NSInteger)start Count:(NSInteger)count;

@end
