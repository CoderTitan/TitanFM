//
//  TKFileTool.h
//  FileDownLoad
//
//  Created by quanjunt on 2018/8/31.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKFileTool : NSObject

/**
 *  判断缓存文件中是否存在文件
 *
 *  @param filePath 文件路径
 *  @return BOOL
 */
+ (BOOL)fileExists:(NSString *)filePath;

/**
 *  获取缓存中的文件大小
 *
 *  @param filePath 文件路径
 *  @return long long 文件大小
 */
+ (long long)fileSize:(NSString *)filePath;

/**
 *  移动文件
 *
 *  @param fromPath 初始文件路径
 *  @param toPath 目的文件路径
 */
+ (void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 *  删除缓存中文件
 *
 *  @param filePath 初始文件路径
 */
+ (void)removeFile:(NSString *)filePath;
@end
