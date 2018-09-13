//
//  TitanTableTool.h
//  ObjcSQLiteDemo
//
//  Created by quanjunt on 2018/7/27.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TitanTableTool : NSObject


/**
 动态更新表(排序好的)
 */
+ (NSArray *)tableSortedColumnNames:(Class)clas uid:(NSString *)uid;


/**
 判断要操作的表格是否存在
 */
+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid;
@end
