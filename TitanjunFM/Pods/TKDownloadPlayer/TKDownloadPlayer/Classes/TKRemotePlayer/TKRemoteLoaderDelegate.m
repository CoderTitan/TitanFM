//
//  TKRemoteLoaderDelegate.m
//  PlayerManager
//
//  Created by quanjunt on 2018/9/4.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRemoteLoaderDelegate.h"
#import "TKRemoteCacheFile.h"
#import "TKAudioDownLoader.h"
#import "NSURL+Extension.h"

@interface TKRemoteLoaderDelegate ()<TKAudioDownLoaderDelegate>

@property (nonatomic, strong) TKAudioDownLoader *downLoader;

@property (nonatomic, strong) NSMutableArray <AVAssetResourceLoadingRequest *> *loadingRequests;

@end

@implementation TKRemoteLoaderDelegate

#pragma mark - 懒加载
- (TKAudioDownLoader *)downLoader {
    if (!_downLoader) {
        _downLoader = [[TKAudioDownLoader alloc] init];
        _downLoader.delegate = self;
    }
    return _downLoader;
}

- (NSMutableArray<AVAssetResourceLoadingRequest *> *)loadingRequests {
    if (!_loadingRequests) {
        _loadingRequests = [NSMutableArray array];
    }
    return _loadingRequests;
}


#pragma mark - AVAssetResourceLoaderDelegate
// 当外界, 需要播放一段音频资源是, 会抛一个请求, 给这个对象
// 这个对象, 到时候, 只需要根据请求信息, 抛数据给外界
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    // 0. 记录所有请求
    [self.loadingRequests addObject:loadingRequest];
    
    // 1. 判断, 本地有没有该音频资源的缓存文件, 如果有 -> 直接根据本地缓存, 向外界响应数据(3个步骤) return
    NSURL *url = [loadingRequest.request.URL httpURL];
    //请求的播放偏移量
    long long requestOffset = self.loadingRequests.firstObject.dataRequest.currentOffset;
    
    // 判断缓存中是否存在文件
    if ([TKRemoteCacheFile cacheFileExists:url]) {
        [self handleLoadingRequest:loadingRequest];
        return YES;
    }
    
    // 2. 判断有没有正在下载
    if (self.downLoader.loadedSize == 0) {
        [self.downLoader downLoadWithURL:url offset:requestOffset];
        //开始下载数据(根据请求的信息, url, requestOffset, requestLength)
        return YES;
    }
    
    // 3. 判断当前是否需要重新下载
    // 3.1 当资源请求, 开始点 < 下载的开始点
    // 3.2 当资源的请求, 开始点 > 下载的开始点 + 下载的长度 + 666, 666: 允许追赶的区间
    if (requestOffset < self.downLoader.offset || requestOffset > self.downLoader.offset + self.downLoader.loadedSize + 666) {
        [self.downLoader downLoadWithURL:url offset:0];
        return YES;
    }
    
    // 4. 开始处理资源请求 (在下载过程当中, 也要不断的判断)
    [self handleAllLoadingRequest];
    
    return YES;
}

// 取消请求
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSLog(@"取消某个请求");
    [self.loadingRequests removeObject:loadingRequest];
}


#pragma mark - TKAudioDownLoaderDelegate
- (void)downLoading {
    [self handleAllLoadingRequest];
}


#pragma mark - 私有方法
/// 在这里不断的处理请求
- (void)handleAllLoadingRequest {
    NSMutableArray *removeRequest = [NSMutableArray array];
    
    AVAssetResourceLoadingRequest *loadingRequest = self.loadingRequests.firstObject;
    // 1. 填充请求头信息
    NSURL *url = loadingRequest.request.URL;
    loadingRequest.contentInformationRequest.contentLength = self.downLoader.totalSize;
    loadingRequest.contentInformationRequest.contentType = self.downLoader.mimeType;
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    
    // 2. 返回数据
    // 2.1 计算请求的数据区间
    long long requestOffSet = loadingRequest.dataRequest.currentOffset;
    long long requestLength = loadingRequest.dataRequest.requestedLength;
    
    // 2.2 根据请求的区间, 看下,本地的临时缓存,能够返回多少
    long long responseOffset = requestOffSet - self.downLoader.offset;
    long long responseLength = MIN(self.downLoader.offset + self.downLoader.loadedSize - requestOffSet, requestLength);
    
    // 3. 填充数据
    NSData *data = [NSData dataWithContentsOfFile:[TKRemoteCacheFile tmpFilePath:url] options:NSDataReadingMappedIfSafe error:nil];
    if (data.length == 0) {
        data = [NSData dataWithContentsOfFile:[TKRemoteCacheFile cacheFilePath:url] options:NSDataReadingMappedIfSafe error:nil];
    }
    
    NSData *subData = [data subdataWithRange:NSMakeRange(responseOffset, responseLength)];
    if (loadingRequest.dataRequest) {
        [loadingRequest.dataRequest respondWithData:subData];
        // 完成请求(必须把所有的关于这个请求的区间数据, 都返回完之后, 才能完成这个请求)
        if (requestLength == responseLength) {
            [loadingRequest finishLoading];
            [self.loadingRequests removeObjectsInArray:removeRequest];
        }
    }
}


- (void)handleLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    // 1. 填写相应的请求头信息
    //获取文件总大小
    NSURL *url = loadingRequest.request.URL;
    long long totalSize = [TKRemoteCacheFile cacheFileSize:url];
    loadingRequest.contentInformationRequest.contentLength = totalSize;
    
    //设置类型
    NSString *contentType = [TKRemoteCacheFile contentType:url];
    loadingRequest.contentInformationRequest.contentType = contentType;
    //支持边缓存边播放
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    
    // 2. 响应数据回传给外界
    //NSDataReadingMappedIfSafe: 实现地址映射, 缓存地址而非文件本身
    NSData *data = [NSData dataWithContentsOfFile:[TKRemoteCacheFile cacheFilePath:url] options:NSDataReadingMappedIfSafe error:nil];
    //请求的播放偏移量
    long long requestOffset = loadingRequest.dataRequest.requestedOffset;
    NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
    
    NSData *subData = [data subdataWithRange:NSMakeRange(requestOffset, requestLength)];
    [loadingRequest.dataRequest respondWithData:subData];
    
    // 3. 完成本次请求(一旦,所有的数据都给完了, 才能调用完成请求方法)
    [loadingRequest finishLoading];
}
@end
