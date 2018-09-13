//
//  TKFileTool.m
//  FileDownLoad
//
//  Created by quanjunt on 2018/8/31.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKFileTool.h"

@implementation TKFileTool

/**
 *  判断缓存文件中是否存在文件
 *
 *  @param filePath 文件路径
 *  @return BOOL
 */
+ (BOOL)fileExists:(NSString *)filePath {
    if (filePath.length == 0) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

/**
 *  获取缓存中的文件大小
 *
 *  @param filePath 文件路径
 *  @return long long 文件大小
 */
+ (long long)fileSize:(NSString *)filePath {
    // 判断是否存在该文件
    if (![self fileExists:filePath]) {
        return 0;
    }
    
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [fileInfo[NSFileSize] longLongValue];
}

/**
 *  移动文件
 *
 *  @param fromPath 初始文件路径
 *  @param toPath 目的文件路径
 */
+ (void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath {
    // 判断文件大小
    if (![self fileSize:fromPath]) {
        return ;
    }
    
    [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
}


/**
 *  删除缓存中文件
 *
 *  @param filePath 初始文件路径
 */
+ (void)removeFile:(NSString *)filePath {
    // 判断是否存在该文件
    if (![self fileExists:filePath]) {
        return ;
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
