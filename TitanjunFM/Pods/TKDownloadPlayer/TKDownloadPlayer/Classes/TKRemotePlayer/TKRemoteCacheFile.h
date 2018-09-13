//
//  TKRemoteCacheFile.h
//  PlayerManager
//
//  Created by quanjunt on 2018/9/4.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKRemoteCacheFile : NSObject

/** 获取本地的缓存路径, 下载完成的路径 */
+ (NSString *)cacheFilePath:(NSURL *)url;
/** 获取缓存文件大小 */
+ (long long)cacheFileSize:(NSURL *)url;
/** 判断缓存文件中是否存在文件 */
+ (BOOL)cacheFileExists:(NSURL *)url;


/** 获取文件临时缓存路径 */
+ (NSString *)tmpFilePath:(NSURL *)url;
/** 临时缓存文件大小 */
+ (long long)tmpFileSize:(NSURL *)url;
/** 临时缓存文件中是否存在该文件 */
+ (BOOL)tmpFileExists:(NSURL *)url;
/** 删除临时缓存文件 */
+ (void)clearTmpFile:(NSURL *)url;


/** 文件路径的扩展名 */
+ (NSString *)contentType:(NSURL *)url;


/** 移动缓存文件 */
+ (void)moveTmpPathToCachePath:(NSURL *)url;

@end
