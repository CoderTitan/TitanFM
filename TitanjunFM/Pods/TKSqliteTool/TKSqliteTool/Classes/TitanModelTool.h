//
//  TitanModelTool.h
//  ObjcSQLiteDemo
//
//  Created by quanjunt on 2018/7/25.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TitanModelProtocol.h"

@interface TitanModelTool : NSObject


/**
 根据类名创建表命
 */
+ (NSString *)tableName:(Class)clas;

/// 创建临时表的名字
+ (NSString *)tempTableName:(Class)clas;


/**
 获取所有的成员变量, 以及成员变量对应的类型
 */
+ (NSDictionary *)classIvarNameTypeDic:(Class)clas;



/**
 获取所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 */
+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)clas;



/**
 将成员变量和类型拼接成sqlite字符串
 */
+ (NSString *)columnNamesAndTypesStr:(Class)clas;


/**
 给所有的成员变量进行排序
 */
+ (NSArray *)allTableSortedIvarNames:(Class)clas;
@end
