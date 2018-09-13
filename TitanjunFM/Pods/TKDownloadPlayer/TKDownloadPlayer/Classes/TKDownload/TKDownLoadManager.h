//
//  TKDownLoadManager.h
//  FileDownLoad
//
//  Created by quanjunt on 2018/9/3.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKDownLoader.h"

@interface TKDownLoadManager : NSObject

// 单例
// 1. 无论通过怎样的方式, 创建出来, 只有一个实例(alloc  copy mutableCopy)
// 2. 通过某种方式, 可以获取同一个对象,但是, 也可以通过其他方式, 创建出来新的对象
+ (instancetype)shareInstance;

/** 根据URL下载资源 */
- (TKDownLoader *)downLoadWithURL: (NSURL *)url;

/** 获取url对应的downLoader */
- (TKDownLoader *)getDownLoaderWithURL: (NSURL *)url;


/**
 根据url地址下载文件, 根据提供的回调代码块, 返回下载信息
 
 @param url 文件的url地址
 @param downLoadInfo 下载信息
 @param progressBlock 下载进度
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlockType)progressBlock success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

/// 根据url暂停下载
- (void)pauseWithURL:(NSURL *)url;
/// 根据url继续下载
- (void)resumeWithURL:(NSURL *)url;
/// 根据url取消下载
- (void)cancelWithURL:(NSURL *)url;

/// 暂停所有下载任务
- (void)pauseAll;
/// 继续所有下载任务
- (void)resumeAll;


@end
