//
//  TKDownLoader.m
//  FileDownLoad
//
//  Created by quanjunt on 2018/8/31.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKDownLoader.h"
#import "TKFileTool.h"
#import "NSString+MD5.h"


/// 已下载完成缓存地址
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
/// 正在下载临时魂村地址
#define kTmpPath NSTemporaryDirectory()

@interface TKDownLoader () <NSURLSessionDataDelegate>
{
    /// 临时文件的大小
    long long _tmpSize;
    /// 文件的总大小
    long long _totalSize;
}

/** 文件的缓存路径 */
@property (nonatomic, copy) NSString *downLoadedPath;
/** 文件的临时缓存路径 */
@property (nonatomic, copy) NSString *downLoadingPath;
/** 下载会话 */
@property (nonatomic, strong) NSURLSession *session;
/** 文件输出流 */
@property (nonatomic, strong) NSOutputStream *outputStream;
/** 下载任务 */
@property (nonatomic, weak) NSURLSessionDataTask *task;
@property (nonatomic, weak) NSURL *url;
@end
@implementation TKDownLoader

#pragma mark - 懒加载
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

#pragma mark - 对外接口
/** 获取缓存文件路径 */
+ (NSString *)downLoadedFileWithURL: (NSURL *)url {
    NSString *cachePath = [kCachePath stringByAppendingPathComponent:url.lastPathComponent];
    if ([TKFileTool fileExists:cachePath]) {
        return cachePath;
    }
    return nil;
}

/** 获取临时缓存文件大小 */
+ (long long)tmpCacheSizeWithURL: (NSURL *)url {
    NSString *tmpFileMd5 = [url.absoluteString md5];
    NSString *tmpPath = [kTmpPath stringByAppendingPathComponent:tmpFileMd5];
    return [TKFileTool fileSize:tmpPath];
}

/** 清楚缓存文件 */
+ (void)clearCacheWithURL: (NSURL *)url {
    NSString *cachePath = [kCachePath stringByAppendingPathComponent:url.lastPathComponent];
    [TKFileTool removeFile:cachePath];
}


- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlockType)progressBlock success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock {
    //block赋值
    self.downLoadInfo = downLoadInfo;
    self.progressChange = progressBlock;
    self.successBlock = successBlock;
    self.faildBlock = failedBlock;
    
    //开始下载
    [self downLoader:url];
}

- (void)downLoader:(NSURL *)url {
    self.url = url;
    
    // 0. 验证, 当前任务是否存在
    if ([url isEqual:self.task.originalRequest.URL]) {
        //任务存在
        //如果是暂停状态
        if (self.state == TKDownLoaderStatePause) {
            [self resumeCurrentTask];
            return;
        }
    }
    
    // 两种: 1. 任务不存在, 2. 任务存在, 但是, 任务的Url地址 不同
    //取消当前任务
    [self cancelCurrentTask];
    
    //获取文件名
    self.downLoadedPath = [kCachePath stringByAppendingPathComponent:url.lastPathComponent];
    self.downLoadingPath = [kTmpPath stringByAppendingPathComponent:[url.absoluteString md5]];
    
    //1. 判断url对应的文件是否是下载完成的
    if ([TKFileTool fileExists:self.downLoadedPath]) {
        //已经下载完成
        self.state = TKDownLoaderStateSuccess;
        return;
    }
    
    //获取本地文件大小
    _tmpSize = [TKFileTool fileSize:self.downLoadingPath];
    [self downLoadWithURL:url offset:_tmpSize];
}

// 暂停了几次, 恢复几次, 才可以恢复
- (void)resumeCurrentTask {
    if (self.task && self.state == TKDownLoaderStatePause) {
        [self.task resume];
        self.state = TKDownLoaderStateDowning;
    }
}

// 暂停, 暂停任务, 可以恢复, 缓存没有删除
- (void)pauseCurrentTask {
    if (self.state == TKDownLoaderStateDowning) {
        [self.task suspend];
        self.state = TKDownLoaderStatePause;
    }
}

// 取消,
- (void)cancelCurrentTask {
    [self.session invalidateAndCancel];
    self.session = nil;
    self.state = TKDownLoaderStatePause;
}

// 删除缓存, 删除的是下载中的文件, 下载完成的需要手动删除
-(void)cancelAndClearCache {
    [self cancelCurrentTask];
    //删除缓存
    [TKFileTool removeFile:self.downLoadingPath];
}

#pragma mark - 协议方法
/**
 第一次接受到相应的时候调用(响应头, 并没有具体的资源内容)
 通过这个方法, 里面, 系统提供的回调代码块, 可以控制, 是继续请求, 还是取消本次请求
 
 @param session 会话
 @param dataTask 任务
 @param response 响应头信息
 @param completionHandler 系统回调代码块, 通过它可以控制是否继续接收数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 通过completionHandler回调代码块, 可以控制, 是继续请求, 还是取消本次请求
    //获取资源总大小
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    _totalSize = [httpResponse.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = httpResponse.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
        _totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    //传递给外界, 下载信息
    if (self.downLoadInfo != nil) {
        self.downLoadInfo(_totalSize);
    }
    
    /* 比对本地大小, 三种状态
     * 本地大小 == 总大小  ==> 移动到下载完成的路径中
     * 本地大小 > 总大小  ==> 删除本地临时缓存, 从0开始下载
     * 本地大小 < 总大小 => 从本地大小开始下载
     */
    if (_tmpSize == _totalSize) {
        // 1. 移动到下载完成文件夹
        [TKFileTool moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        self.state = TKDownLoaderStateSuccess;
        
        // 2. 取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    
    if (_tmpSize > _totalSize) {
        // 1. 删除临时缓存
        [TKFileTool removeFile:self.downLoadingPath];
        // 2. 从0 开始下载
        [self downLoader:response.URL];
        // 3. 取消请求
        completionHandler(NSURLSessionResponseCancel);
        
        return;
    }
    
    // 继续接受数据
    // 确定开始下载数据
    self.state = TKDownLoaderStateDowning;
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.downLoadingPath append:YES];
    [self.outputStream open];
    completionHandler(NSURLSessionResponseAllow);
}

// 当用户确定, 继续接受数据的时候调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    //当前已经下载的大小
    _tmpSize += data.length;
    self.progress = 1.0 * _tmpSize / _totalSize;
    
    // 往输出流中写入数据
    [self.outputStream write:data.bytes maxLength:data.length];
    
}

// 请求完成的时候调用( != 请求成功/失败)
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error == nil) {
        [TKFileTool moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        self.state = TKDownLoaderStateSuccess;
    } else {
        if (error.code == -999) {
            self.state = TKDownLoaderStatePause;
        } else {
            self.state = TKDownLoaderStateFailed;
        }
    }
    [self.outputStream close];
    self.outputStream = nil;
}


#pragma mark - 私有方法
/**
 根据开始字节, 请求资源
 
 @param url url
 @param offset 开始字节
 */
- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset {
    //IgnoringLocalCacheData: 忽略缓存文件, 重新下载
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    //添加请求头
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    // session 分配的task, 默认情况, 挂起状态
    self.task = [self.session dataTaskWithRequest:request];
    [self resumeCurrentTask];
}


#pragma mark - 事件/数据传递
- (void)setState:(TKDownLoaderState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    
    //代理, 通知, block
    if (self.stateChange) {
        self.stateChange(_state);
    }
    
    //成功状态
    if (_state == TKDownLoaderStateSuccess && self.successBlock) {
        self.successBlock(self.downLoadedPath);
    }
    
    //失败状态
    if (_state == TKDownLoaderStateFailed && self.faildBlock) {
        self.faildBlock();
    }
    
    NSDictionary *infoDic = @{
                              @"downLoadURL": self.url,
                              @"downLoadState": @(self.state)
                              };
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownLoadURLOrStateChangeNotification object:nil userInfo:infoDic];
}

- (void)setProgress:(float)progress {
    _progress = progress;
    if (self.progressChange) {
        self.progressChange(progress);
    }
}
@end
