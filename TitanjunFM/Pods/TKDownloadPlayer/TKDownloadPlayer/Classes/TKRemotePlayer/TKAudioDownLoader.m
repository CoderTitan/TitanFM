//
//  TKAudioDownLoader.m
//  PlayerManager
//
//  Created by quanjunt on 2018/9/4.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKAudioDownLoader.h"
#import "TKRemoteCacheFile.h"


@interface TKAudioDownLoader()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, strong) NSURL *url;


@end

@implementation TKAudioDownLoader

#pragma mark - 懒加载
- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}


#pragma mark - 对外接口
- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset {
    [self cancelAndClean];
    
    self.url = url;
    self.offset = offset;
    
    // 请求的是某一个区间的数据 Range
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}


#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 1. 从  Content-Length 取出来
    // 2. 如果 Content-Range 有, 应该从Content-Range里面获取
    NSHTTPURLResponse *result = (NSHTTPURLResponse *)response;
    self.totalSize = [result.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = result.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
        self.totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    //类型
    self.mimeType = result.MIMEType;
    
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:[TKRemoteCacheFile tmpFilePath:self.url] append:YES];
    [self.outputStream open];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    self.loadedSize += data.length;
    [self.outputStream write:data.bytes maxLength:data.length];
    
    if ([self.delegate respondsToSelector:@selector(downLoading)]) {
        [self.delegate downLoading];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) {
        NSURL *url = self.url;
        if ([TKRemoteCacheFile tmpFileSize:url] == self.totalSize) {
            //移动文件, 临时文件夹 -> cache文件
            [TKRemoteCacheFile moveTmpPathToCachePath:url];
        } else {
            NSLog(@"有错误");
        }
    }
}

#pragma mark - 私有接口
- (void)cancelAndClean {
    //取消
    [self.session invalidateAndCancel];
    self.session = nil;
    
    //清空临时缓存
    [TKRemoteCacheFile clearTmpFile:self.url];
    
    //重置数据
    self.loadedSize = 0;
}
@end
