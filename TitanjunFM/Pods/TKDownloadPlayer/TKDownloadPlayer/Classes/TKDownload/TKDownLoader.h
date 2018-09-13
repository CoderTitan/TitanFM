//
//  TKDownLoader.h
//  FileDownLoad
//
//  Created by quanjunt on 2018/8/31.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kDownLoadURLOrStateChangeNotification @"downLoadURLOrStateChangeNotification"

/** 下载任务的状态  */
typedef NS_ENUM(NSUInteger, TKDownLoaderState) {
    TKDownLoaderStateUnKnown,
    /** 下载暂停 */
    TKDownLoaderStatePause,
    /** 正在下载 */
    TKDownLoaderStateDowning,
    /** 已经下载 */
    TKDownLoaderStateSuccess,
    /** 下载失败 */
    TKDownLoaderStateFailed
};


/** 文件下载信息(下载文件总大小)  */
typedef void(^DownLoadInfoType)(long long totalSize);
/** 文件下载进度  */
typedef void(^ProgressBlockType)(float progress);
/** 下载成功(成功路径)  */
typedef void(^SuccessBlockType)(NSString *filePath);
/** 下载失败  */
typedef void(^FailedBlockType)(void);
/** 下载任务状态  */
typedef void(^StateChangeType)(TKDownLoaderState state);



@interface TKDownLoader : NSObject

/** 获取缓存文件路径 */
+ (NSString *)downLoadedFileWithURL: (NSURL *)url;
/** 获取临时缓存文件大小 */
+ (long long)tmpCacheSizeWithURL: (NSURL *)url;
/** 清楚缓存文件 */
+ (void)clearCacheWithURL: (NSURL *)url;


/**
 根据url地址下载文件, 根据提供的回调代码块, 返回下载信息
 
 @param url 文件的url地址
 @param downLoadInfo 下载信息
 @param progressBlock 下载进度
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlockType)progressBlock success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

/*
 根据url地址下载文件, 如果已经下载, 则继续当前下载
 @prame url 文件的url地址
 */
- (void)downLoader:(NSURL *)url;

/*
 * 恢复下载
 */
- (void)resumeCurrentTask;

/*
 * 暂停下载
 */
- (void)pauseCurrentTask;

/*
 * 取消下载
 */
- (void)cancelCurrentTask;

/*
 * 删除缓存
 */
- (void)cancelAndClearCache;

/*
 * kvo , 通知, 代理, block
 */
@property (nonatomic, assign) TKDownLoaderState state;
/// 下载进度
@property (nonatomic, assign, readonly) float progress;
/** 文件下载信息(下载文件总大小)  */
@property (nonatomic, copy) DownLoadInfoType downLoadInfo;
/** 下载任务状态  */
@property (nonatomic, copy) StateChangeType stateChange;
/** 文件下载进度  */
@property (nonatomic, copy) ProgressBlockType progressChange;
/** 下载成功(成功路径)  */
@property (nonatomic, copy) SuccessBlockType successBlock;
/** 下载失败  */
@property (nonatomic, copy) FailedBlockType faildBlock;

@end
