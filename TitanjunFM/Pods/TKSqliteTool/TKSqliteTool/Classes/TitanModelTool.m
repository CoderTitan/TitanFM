//
//  TitanModelTool.m
//  ObjcSQLiteDemo
//
//  Created by quanjunt on 2018/7/25.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TitanModelTool.h"
#import <objc/runtime.h>

@implementation TitanModelTool

/**
 根据类名创建表名
 */
+ (NSString *)tableName:(Class)clas {
    return NSStringFromClass(clas);
}

/// 创建临时表的名字
+ (NSString *)tempTableName:(Class)clas {
    return [NSStringFromClass(clas) stringByAppendingString:@"_tmp"];
}


/**
 获取所有的成员变量, 以及成员变量对应的类型
 */
+ (NSDictionary *)classIvarNameTypeDic:(Class)clas {
    //获取这个类的所有成员变量和类型
    unsigned int count = 0;
    Ivar *varList = class_copyIvarList(clas, &count);
    
    NSMutableDictionary *nameTypeDic = [NSMutableDictionary dictionary];
    
    //获取忽略的字段
    NSArray *ignoreNames = nil;
    if ([clas respondsToSelector:@selector(ignoreColumnNames)]) {
        ignoreNames = [clas ignoreColumnNames];
    }
    
    //遍历所有成员变量
    for (int i = 0; i < count; i ++) {
        Ivar ivar = varList[i];
        
        //1. 获取成员变量名称
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        //去掉下划线
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }
        
        //去掉忽略的成员变量
        if ([ignoreNames containsObject:ivarName]) {
            continue;
        }
        
        //2. 获取成员变量的类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        ivarType = [ivarType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        //写入字典
        [nameTypeDic setValue:ivarType forKey:ivarName];
    }
    
    return nameTypeDic;
}



/**
 获取所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 */
+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)clas {
    //1. 获取类的所有成员变量和类型
    NSMutableDictionary *dic = [[self classIvarNameTypeDic:clas] mutableCopy];
    
    //2. 获取oc和sqlite的类型匹配
    NSDictionary *typeDic = [self ocTypeToSqliteTypeDic];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        dic[key] = typeDic[obj];
    }];
    
    return dic;
}


/**
 将成员变量和类型拼接成sqlite字符串
 */
+ (NSString *)columnNamesAndTypesStr:(Class)clas {
    //1. 获取转换后的sqlite类型的字典
    NSDictionary *dic = [self classIvarNameSqliteTypeDic:clas];
    
    NSMutableArray *result = [NSMutableArray array];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        [result addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
    }];
    
    return [result componentsJoinedByString:@","];
}


/**
 给所有的成员变量进行排序
 */
+ (NSArray *)allTableSortedIvarNames:(Class)clas {
    //1. 获取所有的成员变量
    NSDictionary *dic = [self classIvarNameTypeDic:clas];
    NSArray *keys = dic.allKeys;
    
    //2.排序
    [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return keys;
}


#pragma mark - 私有方法
/// OC数据类型转换成sqlite类型
+ (NSDictionary *)ocTypeToSqliteTypeDic {
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
}


@end
