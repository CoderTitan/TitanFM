//
//  TitanModelProtocol.h
//  ObjcSQLiteDemo
//
//  Created by quanjunt on 2018/7/25.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TitanModelProtocol <NSObject>

/**
 操作模型必须实现的方法, 通过这个方法获取主键信息
 
 @return 主键字符串
 */
@required
+ (NSString *)primaryKey;


/**
 忽略的字段数组
 
 @return 忽略的字段数组
 */
@optional
+ (NSArray *)ignoreColumnNames;


/**
 新字段名称-> 旧的字段名称的映射表格
 
 @return 映射表格
 */
@optional
+ (NSDictionary *)newNameToOldNameDic;
@end
