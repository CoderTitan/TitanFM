//
//  TKRemoteCacheFile.m
//  PlayerManager
//
//  Created by quanjunt on 2018/9/4.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRemoteCacheFile.h"
#import <MobileCoreServices/MobileCoreServices.h>


#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kTmpPath NSTemporaryDirectory()
@implementation TKRemoteCacheFile

/** 获取本地的缓存路径, 下载完成的路径 */
+ (NSString *)cacheFilePath:(NSURL *)url {
    return [kCachePath stringByAppendingPathComponent:url.lastPathComponent];
}

/** 获取缓存文件大小 */
+ (long long)cacheFileSize:(NSURL *)url {
    //计算文件路径对应的文件大小
    if (![self cacheFileExists:url]) {
        return 0;
    }
    
    //获取文件路径
    NSString *path = [self cacheFilePath:url];
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return [fileInfo[NSFileSize] longLongValue];
}

/** 判断缓存文件中是否存在文件 */
+ (BOOL)cacheFileExists:(NSURL *)url {
    NSString *path = [self cacheFilePath:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}


/** 获取文件临时缓存路径 */
+ (NSString *)tmpFilePath:(NSURL *)url {
    return [kTmpPath stringByAppendingPathComponent:url.lastPathComponent];
}

/** 临时缓存文件大小 */
+ (long long)tmpFileSize:(NSURL *)url {
    // 1 计算文件路径对应的文件大小
    if (![self tmpFileExists:url]) {
        return 0;
    }
    // 2 获取文件路径
    NSString *path = [self tmpFilePath:url];
    NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return  [fileInfoDic[NSFileSize] longLongValue];
}

/** 临时缓存文件中是否存在该文件 */
+ (BOOL)tmpFileExists:(NSURL *)url {
    NSString *path = [self tmpFilePath:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

/** 删除临时缓存文件 */
+ (void)clearTmpFile:(NSURL *)url {
    NSString *tmpPath = [self tmpFilePath:url];
    BOOL isDic = YES;
    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:tmpPath isDirectory:&isDic];
    if (isExit && !isDic) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
    }
}


/** 文件路径的扩展名 */
+ (NSString *)contentType:(NSURL *)url {
    NSString *path = [self cacheFilePath:url];
    // 文件路径的扩展名
    NSString *fileExtension = path.pathExtension;
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)fileExtension, NULL);
    
    return CFBridgingRelease(contentType);
}


/** 移动缓存文件 */
+ (void)moveTmpPathToCachePath:(NSURL *)url {
    NSString *tmpPath = [self tmpFilePath:url];
    NSString *cachePath = [self cacheFilePath:url];
    [[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:cachePath error:nil];
}

@end
