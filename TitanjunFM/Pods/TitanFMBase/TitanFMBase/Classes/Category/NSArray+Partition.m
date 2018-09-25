//
//  NSArray+Partition.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "NSArray+Partition.h"

@implementation NSArray (Partition)

/**
 *  将一个数组切割成多个数组
 *
 *  @param start 从第几个元素开始分割
 *  @param count 每个数组最大个数
 *
 *  @return 切割好的数组
 */
- (NSArray *)partitionArrayWithStart:(NSInteger)start Count:(NSInteger)count {
    NSMutableArray *resultArr = [NSMutableArray array];
    NSInteger max = count;
    
    //需要分割几次
    NSInteger segment = (self.count + max - 1) / max;
    for (int i = 0; i < segment; i++) {
        //开始位置(此处跳过1个长度要加1)
        NSUInteger star = (i * max) + start;
        //结束位置(此处跳过1个长度要减1)
        NSUInteger len = (i == (segment - 1)) ? (self.count - start - i * max) % (max + 1) : max;
        //分割范围
        NSRange range= NSMakeRange(star,len);
        // 分割数组
        NSArray *temp = [self subarrayWithRange:range];
        [resultArr addObject:temp];
    }
    
    return resultArr;
}
@end
