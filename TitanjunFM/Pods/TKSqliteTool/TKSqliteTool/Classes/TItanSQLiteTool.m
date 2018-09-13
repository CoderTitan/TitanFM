//
//  TItanSQLiteTool.m
//  ObjcSQLiteDemo
//
//  Created by quanjunt on 2018/7/25.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TItanSQLiteTool.h"
#import "sqlite3.h"


#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject


@implementation TItanSQLiteTool
#pragma mark - 全局属性

sqlite3 *titanDB = nil;


#pragma mark - 接口

/**
 处理sql语句包括增删改记录, 创建删除表格等无结果集操作
 
 @param sql sql语句
 @param uid 用户唯一标示
 @return 是否处理成功
 */
+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid {
    //1. 打开数据库
    if (![self openDB:uid]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    //2. 执行语句
    BOOL result = sqlite3_exec(titanDB, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    //3. 关闭数据库
    [self closeDB];
    
    return result;
}


/**
 查询语句, 返回结果集
 
 @param sql sql语句
 @param uid 用户唯一标识
 @return 字典(一行记录)组成的数组
 */
+ (NSMutableArray <NSMutableDictionary *> *)querySql:(NSString *)sql uid:(NSString *)uid {
    //1. 打开数据库
    [self openDB:uid];
    
    //2. 创建准备语句
    /**
     sqlite3_prepare_v2
     参数1: 一个已经打开的数据库
     参数2: 需要中的sql
     参数3: 参数2取出多少字节的长度 -1 自动计算
     参数4: 准备语句
     参数5: 通过参数3, 取出参数2的长度字节之后, 剩下的字符串
     */
    sqlite3_stmt *ppStmt = nil;
    BOOL res = sqlite3_prepare_v2(titanDB, sql.UTF8String, -1, &ppStmt, nil) == SQLITE_OK;
    if (!res) {
        NSLog(@"准备语句编译失败");
        return nil;
    }
    
    //3. 绑定数据
    
    //4. 执行
    //创建存储字典的大数组
    NSMutableArray * rowDicArr = [NSMutableArray array];
    
    //SQLITE_ROW: 代表下一行还有数据
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        // 一行记录 -> 字典
        // 4-1. 获取所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        
        //创建存储每一行数据的字典
        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
        
        //4-2. 遍历所有的列
        for (int i = 0; i < columnCount; i ++) {
            //4-2-1. 获取列名sqli
            //参数一: 准备语句, 参数二: 索引
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnname = [NSString stringWithUTF8String:columnNameC];
            
            //4-2-2. 获取列值
            // 不同列的数据类型, 使用不同的函数进行获取
            
            //获取列的数据类型
            int type = sqlite3_column_type(ppStmt, i);
            
            //获取列的值
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    //sqlite3_column_blob: 返回时void
                    //CFBridgingRelease: 把一个值转成id类型
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE_TEXT:
                    value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(ppStmt, i)];
                    break;
                    
                default:
                    break;
            }
            
            //写入字典
            [rowDic setValue:value forKey:columnname];
        }
        
        [rowDicArr addObject:rowDic];
    }
    
    //5. 重置
    
    //6. 释放资源
    sqlite3_finalize(ppStmt);
    
    //7. 关闭数据库
    [self closeDB];
    
    
    return rowDicArr;
}


/**
 同时处理多条语句, 并使 事物进行包装
 
 @param sqls sql语句数组
 @param uid 用户的唯一表示
 @return 是否全部处理成功, 如果有一条没有处理成功则会进行回滚操作
 */
+ (BOOL)dealSqls:(NSArray <NSString *> *)sqls uid:(NSString *)uid {
    //开始执行
    [self beginTransaction:uid];
    
    //遍历所有的语句
    for (NSString *sql in sqls) {
        BOOL result = [self deal:sql uid:uid];
        if (result == NO) {
            //如果有一条语句出现错误, 则全部语句失败, 回滚数据
            [self rollBackTransaction:uid];
            return NO;
        }
    }
    
    //都成功, 提交
    [self commitTransaction:uid];
    return YES;
}


#pragma mark - 关于事物的操作
/// 开始操作
+ (void)beginTransaction:(NSString *)uid {
    [self deal:@"begin reansaction" uid:uid];
}

/// 提交操作
+ (void)commitTransaction:(NSString *)uid {
    [self deal:@"commit reansaction" uid:uid];
}

/// 回滚操作
+ (void)rollBackTransaction:(NSString *)uid {
    [self deal:@"rollback reansaction" uid:uid];
}

#pragma mark - 私有方法

/**
 打开数据库
 @param uid 用户唯一标识
 @return 是否打开成功
 */
+ (BOOL)openDB:(NSString *)uid {
    //1. 路径
    NSString *dbName = @"common.db";
    if (uid.length != 0) {
        dbName = [NSString stringWithFormat:@"%@.db", uid];
    }
    
    //2. 凭借数据库路径
    NSString *dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    
    //3. 创建&打开数据库
    //SQLITE_OK打开数据库成功
    return sqlite3_open(dbPath.UTF8String, &titanDB) == SQLITE_OK;
}


/**
 关闭数据库
 */
+ (void)closeDB {
    sqlite3_close(titanDB);
}
@end
