//
//  TitanModelSqliteTool.h
//  ObjcSQLiteDemo
//
//  Created by quanjunt on 2018/7/25.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TitanModelProtocol.h"


typedef NS_ENUM(NSUInteger, ColumnNameToValueRelationType) {
    ColumnNameToValueRelationTypeMore,
    ColumnNameToValueRelationTypeLess,
    ColumnNameToValueRelationTypeEqual,
    ColumnNameToValueRelationTypeMoreEqual,
    ColumnNameToValueRelationTypeLessEqual,
    ColumnNameToValueRelationTypeNoneEqual,
};

typedef NS_ENUM(NSUInteger, SqliteModelToolNAO) {
    SqliteModelToolNAONot,
    SqliteModelToolNAOAnd,
    SqliteModelToolNAOOr,
};



@interface TitanModelSqliteTool : NSObject

/**
 拼接创建表格的sql(拼接主键信息)
 */
+ (BOOL)createTable:(Class)clas uid:(NSString *)uid;


/**
 判断是否需要刷新
 */
+ (BOOL)isTableRequiredUpdate:(Class)clas uid:(NSString *)uid;


/**
 更新表的数据
 */
+ (BOOL)updateTable:(Class)clas uid:(NSString *)uid;

/**
 保存model到数据库
 */
+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid;


/*
 根据主键删除数据
 */
+ (BOOL)deleteModel:(id)model uid:(NSString *)uid;


/*
 根据条件删除
 */
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;

/*
 根据删除语句删除
 */
+ (BOOL)deleteWithSql:(NSString *)sql uid:(NSString *)uid;

+ (BOOL)deleteModel:(Class)cls key: (NSString *)key relation: (ColumnNameToValueRelationType)relation value: (id)value uid: (NSString *)uid;
+ (BOOL)deleteModel:(Class)cls keys: (NSArray *)keys relations: (NSArray *)relations values: (NSArray *)values nao: (NSArray *)naos uid: (NSString *)uid;



/*
 查询所有数据
 */
+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid;

/*
 根据sql语句查询
 */
+ (NSArray *)queryModels:(Class)clas withSql:(NSString *)sql uid:(NSString *)uid;

+ (NSArray *)queryModels:(Class)cls key: (NSString *)key relation: (ColumnNameToValueRelationType)relation value: (id)value uid: (NSString *)uid;
+ (NSArray *)queryModels:(Class)cls keys: (NSArray *)keys relations: (NSArray *)relations values: (NSArray *)values nao: (NSArray *)naos uid: (NSString *)uid;

@end
