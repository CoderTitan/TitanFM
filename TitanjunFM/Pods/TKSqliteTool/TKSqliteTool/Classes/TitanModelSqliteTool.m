//
//  TitanModelSqliteTool.m
//  ObjcSQLiteDemo
//
//  Created by quanjunt on 2018/7/25.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TitanModelSqliteTool.h"
#import "TItanSQLiteTool.h"
#import "TitanModelTool.h"
#import "TitanTableTool.h"

@implementation TitanModelSqliteTool


/**
 拼接创建表格的sql(拼接主键信息)
 */
+ (BOOL)createTable:(Class)clas uid:(NSString *)uid {
    //1. 拼接创建表格的sql语句
    //create table if not exists 表名(字段1 字段1类型, 字段2 字段2类型 (约束),...., primary key(字段))
    
    //1-1. 获取表格名称
    NSString *tableName = [TitanModelTool tableName:clas];
    
    if (![clas respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    
    NSString *primary = [clas primaryKey];
    
    //1-2. 获取一个模型的所有字段和类型
    NSString *createSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, [TitanModelTool columnNamesAndTypesStr:clas], primary];
    
    //2. 执行语句
    return [TItanSQLiteTool deal:createSql uid:uid];;
}


#pragma mark - 更新数据
/**
 判断是否需要刷新
 */
+ (BOOL)isTableRequiredUpdate:(Class)clas uid:(NSString *)uid {
    //1. 获取所有的排序号的成员变量
    NSArray *modelNames = [TitanModelTool allTableSortedIvarNames:clas];
    NSArray *tableNames = [TitanTableTool tableSortedColumnNames:clas uid:uid];
    
    return ![tableNames isEqualToArray:modelNames];
}


/**
 更新表的数据
 */
+ (BOOL)updateTable:(Class)clas uid:(NSString *)uid {
    //1. 获取新旧表名
    NSString *tmpTableName = [TitanModelTool tempTableName:clas];
    NSString *tableName = [TitanModelTool tableName:clas];
    
    //2. 判断主键
    if (![clas respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    
    //3. 创建所有的语句
    //用于保存所有的语句, 保证所有语句都成功
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [clas primaryKey];
    
    //3-1. 创建临时表名
    NSString *createTmpSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTableName, [TitanModelTool columnNamesAndTypesStr:clas], primaryKey];
    [execSqls addObject:createTmpSql];
    
    //3-2. 根据主键插入数据
    // 语句格式: insert into stu_tmp(stuNum) select stuNum from stu;
    NSString *insertPrimaryStr = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, tableName];
    [execSqls addObject:insertPrimaryStr];
    
    //3-3. 根据主键吧所有数据都更信道表里
    NSArray *oldNames = [TitanTableTool tableSortedColumnNames:clas uid:uid];
    NSArray *newNames = [TitanModelTool allTableSortedIvarNames:clas];
    
    //获取更名字典
    NSDictionary *nameDic = @{};
    //  @{@"age": @"age2"};
    if ([clas respondsToSelector:@selector(newNameToOldNameDic)]) {
        nameDic = [clas newNameToOldNameDic];
    }
    
    for (NSString *newName in newNames) {
        NSString *oldName = newName;
        //3-3-1. 找映射的旧的字段名称
        if ([nameDic[newName] length] != 0) {
            oldName = nameDic[newName];
        }
        // 3-3-2. 判断新表中的字段是否在旧表中
        if ((![oldNames containsObject:newName] && ![oldNames containsObject:oldName]) || [newName isEqualToString:primaryKey]) {
            continue;
        }
        
        //3-3-3. 创建数据迁移命令
        //格式: update stu_tmp set name = (select name from stu where stu_tmp.id = stu.id)
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)", tmpTableName, newName, oldName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSqls addObject:updateSql];
    }
    
    //3-4. 删除旧表
    NSString *deleteOldSql = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [execSqls addObject:deleteOldSql];
    
    //3-5. 修改临时表的名字
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTableName, tableName];
    [execSqls addObject:renameTableName];
    
    //4. 执行所有的语句
    return [TItanSQLiteTool dealSqls:execSqls uid:uid];
}


#pragma mark - 保存数据
/**
 保存model到数据库
 */
+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid {
    //1. 判断表是否存在, 不存在则创建
    Class clas = [model class];
    if (![TitanTableTool isTableExists:clas uid:uid]) {
        //不存在则创建表
        [self createTable:clas uid:uid];
    }
    
    //2. 检测表的数据是否需要更新
    if (![self isTableRequiredUpdate:clas uid:uid]) {
        //需要更新
        [self updateTable:clas uid:uid];
    }
    
    //3. 判断记录是否存在
    // 从表格里面, 按照主键, 进行查询该记录, 如果能够查询到
    NSString *tableName = [TitanModelTool tableName:clas];
    if (![clas respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [clas primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    NSArray *result = [TItanSQLiteTool querySql:checkSql uid:uid];
    
    //4. 获取字段数组
    NSArray *columNames = [TitanModelTool classIvarNameTypeDic:clas].allKeys;
    
    //5. 获取值数组
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *setValueArr = [NSMutableArray array];
    for (NSString *colname in columNames) {
        id value = [model valueForKeyPath:colname];
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        if (value == nil) {
            value = @"";
        }
        [values addObject:value];
        NSString *setStr = [NSString stringWithFormat:@"%@='%@'", colname, value];
        [setValueArr addObject:setStr];
    }
    
    //6. 更新
    NSString *execSql = @"";
    if (result.count > 0) {
        //更新数据
        execSql = [NSString stringWithFormat:@"update %@ set %@  where %@ = '%@'", tableName, [setValueArr componentsJoinedByString:@","], primaryKey, primaryValue];
    } else {
        //插入数据
        // insert into 表名(字段1, 字段2, 字段3) values ('值1', '值2', '值3')
        execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@')", tableName, [columNames componentsJoinedByString:@","], [values componentsJoinedByString:@"','"]];
    }
    
    return [TItanSQLiteTool deal:execSql uid:uid];
}


#pragma mark - 删除数据
/*
 根据主键删除数据
 */
+ (BOOL)deleteModel:(id)model uid:(NSString *)uid {
    Class clas = [model class];
    NSString * tableName = [TitanModelTool tableName:clas];
    if (![clas respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [clas primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    
    //删除语句
    NSString *delStr = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    return [TItanSQLiteTool deal:delStr uid:uid];
}


/*
 根据条件删除
 */
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid {
    if (whereStr.length <= 0) {
        return NO;
    }
    
    NSString *tableName = [TitanModelTool tableName:cls];
    NSString *delStr = [NSString stringWithFormat:@"delete from %@ where %@", tableName, whereStr];
    return [TItanSQLiteTool deal:delStr uid:uid];
}


/*
 根据删除语句删除
 */
+ (BOOL)deleteWithSql:(NSString *)sql uid:(NSString *)uid {
    return [TItanSQLiteTool deal:sql uid:uid];
}

+ (BOOL)deleteModel:(Class)cls key: (NSString *)key relation: (ColumnNameToValueRelationType)relation value: (id)value uid: (NSString *)uid {
    NSString *tableName = [TitanModelTool tableName:cls];
    NSString *relationStr = [self relationTypeSQLRelation][@(relation)];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ %@ '%@'", tableName, key, relationStr, value];
    return [TItanSQLiteTool deal:sql uid:uid];
    
}

+ (BOOL)deleteModel:(Class)cls keys: (NSArray *)keys relations: (NSArray *)relations values: (NSArray *)values nao: (NSArray *)naos uid: (NSString *)uid {
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < keys.count; i++) {
        
        NSString *key = keys[i];
        NSString *relationStr = [self relationTypeSQLRelation][relations[i]];
        id value = values[i];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@ %@ '%@'", key, relationStr, value];
        
        [resultStr appendString:tempStr];
        if (i != keys.count - 1) {
            NSString *naoStr = [self naoTypeSQLRelation][naos[i]];
            [resultStr appendString: [NSString stringWithFormat:@"%@", naoStr]];
        }
    }
    NSString *tableName = [TitanModelTool tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@", tableName, resultStr];
    return [TItanSQLiteTool deal:sql uid:uid];
}



#pragma mark - 查询语句
/*
 查询所有数据
 */
+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid {
    //1. 创建查询语句
    NSString *tableName = [TitanModelTool tableName:cls];
    NSString *queryStr = [NSString stringWithFormat:@"select * from %@", tableName];
    
    //2. 执行查询操作
    NSArray <NSDictionary *>*results = [TItanSQLiteTool querySql:queryStr uid:uid];
    
    //3. 处理查询结果
    return [self parseResults:results withClass:cls];
}


/*
 根据sql语句查询
 */
+ (NSArray *)queryModels:(Class)clas withSql:(NSString *)sql uid:(NSString *)uid {
    //1. 执行查询操作
    NSArray <NSDictionary *>*results = [TItanSQLiteTool querySql:sql uid:uid];
    
    //2. 处理查询结果
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dic in results) {
        id model = [[clas alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [models addObject:model];
    }
    return models;
}

+ (NSArray *)queryModels:(Class)cls key: (NSString *)key relation: (ColumnNameToValueRelationType)relation value: (id)value uid: (NSString *)uid {
    NSString *tableName = [TitanModelTool tableName:cls];
    NSString *relationStr = [self relationTypeSQLRelation][@(relation)];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ %@ '%@'", tableName, key, relationStr, value];
    NSArray *rowDics = [TItanSQLiteTool querySql:sql uid:uid];
    NSArray *resulds = [self parseResults:rowDics withClass:cls];
    return resulds;
}

+ (NSArray *)queryModels:(Class)cls keys: (NSArray *)keys relations: (NSArray *)relations values: (NSArray *)values nao: (NSArray *)naos uid: (NSString *)uid {
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < keys.count; i++) {
        
        NSString *key = keys[i];
        NSString *relationStr = [self relationTypeSQLRelation][relations[i]];
        id value = values[i];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@ %@ '%@'", key, relationStr, value];
        
        [resultStr appendString:tempStr];
        if (i != keys.count - 1) {
            NSString *naoStr = [self naoTypeSQLRelation][naos[i]];
            [resultStr appendString: [NSString stringWithFormat:@" %@ ", naoStr]];
        }
    }
    NSString *tableName = [TitanModelTool tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@", tableName, resultStr];
    NSArray *rowDics = [TItanSQLiteTool querySql:sql uid:uid];
    
    return [self parseResults:rowDics withClass:cls];
}



#pragma mark - 私有属性
/// 处理查询的结果集
+ (NSArray *)parseResults:(NSArray <NSDictionary *> *)results withClass:(Class)clas {
    NSMutableArray *modelArr = [NSMutableArray array];
    // 模型真正的字段 - > 类型
    NSDictionary *modelColumnNames = [TitanModelTool classIvarNameTypeDic:clas];
    for (NSDictionary *rowDic in results) {
        id model = [[clas alloc] init];
        [modelArr addObject:model];
        
        [modelColumnNames enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id value = rowDic[key];
            if ([obj isEqualToString:@"NSArray"] || [obj isEqualToString:@"NSDictionary"]) {
                NSData *daata = [value dataUsingEncoding:NSUTF8StringEncoding];
                
                value = [NSJSONSerialization JSONObjectWithData:daata options:0 error:nil];
            } else if ([obj isEqualToString:@"NSMutableArray"] || [obj isEqualToString:@"NSMutableDictionary"]) {
                NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
                value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            
            [model setValue:value forKeyPath:key];
        }];
    }
    
    return modelArr;
}

/**
 枚举 -> sql 逻辑运算符 映射表
 */
+ (NSDictionary *)relationTypeSQLRelation {
    
    return @{
             @(ColumnNameToValueRelationTypeEqual) : @"=",
             @(ColumnNameToValueRelationTypeMore) : @">",
             @(ColumnNameToValueRelationTypeLess) : @"<",
             @(ColumnNameToValueRelationTypeMoreEqual) : @">=",
             @(ColumnNameToValueRelationTypeLessEqual) : @"<=",
             @(ColumnNameToValueRelationTypeNoneEqual) : @"!="
             };
    
}

/**
 枚举 -> sql 逻辑运算符 映射表
 */
+ (NSDictionary *)naoTypeSQLRelation {
    
    return @{
             @(SqliteModelToolNAONot) : @"not",
             @(SqliteModelToolNAOAnd) : @"and",
             @(SqliteModelToolNAOOr) : @"or"
             };
    
}

@end
