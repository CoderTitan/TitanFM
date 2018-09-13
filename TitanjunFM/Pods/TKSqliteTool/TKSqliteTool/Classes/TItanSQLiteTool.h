//
//  TItanSQLiteTool.h
//  ObjcSQLiteDemo
//
//  Created by quanjunt on 2018/7/25.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TItanSQLiteTool : NSObject
// 用户机制
// uid : nil  common.db
// uid: titan  titan.db



/**
 处理sql语句包括增删改记录, 创建删除表格等无结果集操作
 
 @param sql sql语句
 @param uid 用户唯一标示
 @return 是否处理成功
 */
+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid;


/**
 同时处理多条语句, 并使 事物进行包装
 
 @param sqls sql语句数组
 @param uid 用户的唯一表示
 @return 是否全部处理成功, 如果有一条没有处理成功则会进行回滚操作
 */
+ (BOOL)dealSqls:(NSArray <NSString *> *)sqls uid:(NSString *)uid;


/**
 查询语句, 返回结果集
 
 @param sql sql语句
 @param uid 用户唯一标识
 @return 字典(一行记录)组成的数组
 */
+ (NSMutableArray <NSMutableDictionary *> *)querySql:(NSString *)sql uid:(NSString *)uid;

@end
