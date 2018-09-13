//
//  TitanTableTool.m
//  ObjcSQLiteDemo
//
//  Created by quanjunt on 2018/7/27.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TitanTableTool.h"
#import "TitanModelTool.h"
#import "TItanSQLiteTool.h"

@implementation TitanTableTool


//CREATE TABLE sqlite_sequence(name,seq)

/**
 动态更新表(排序好的)
 */
+ (NSArray *)tableSortedColumnNames:(Class)clas uid:(NSString *)uid {
    //1. 获取表名
    NSString *tableName = [TitanModelTool tableName:clas];
    
    //2.获取创建表的sql语句
    NSString *createSql = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    //3. 根据sql语句获取成员变量和类型
    NSMutableDictionary *dic = [TItanSQLiteTool querySql:createSql uid:uid].firstObject;
    
    NSString *createTableSql = [dic[@"sql"] lowercaseString];
    if (createTableSql.length == 0) {
        return nil;
    }
    
    //3. 分割字符串
    createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    //替换特殊字符
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\t" withString:@""];

    NSString *nameTypeStr = [createTableSql componentsSeparatedByString:@"("][1];
    
    //4. 分割成数组
    NSArray *nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    
    //5. 获取所有的变量名
    NSMutableArray *nameArr = [NSMutableArray array];
    for (NSString *nameTypw in nameTypeArray) {
        //不处理主键参数
        if ([nameTypw containsString:@"primary"]) {
            continue;
        }
        
        NSString *nameType2 = [nameTypw stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        //根据空格分割
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        
        [nameArr addObject:name];
    }
    return nameArr;
}


/**
 判断要操作的表格是否存在
 */
+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid {
    NSString *tableName = [TitanModelTool tableName:cls];
    NSString *createSql = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    //获取创建表的语句
    NSMutableArray *result = [TItanSQLiteTool querySql:createSql uid:uid];
    
    return result.count > 0;
}
@end
