//
//  TKDownLoadManager.m
//  FileDownLoad
//
//  Created by quanjunt on 2018/9/3.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKDownLoadManager.h"
#import "NSString+MD5.h"


@interface TKDownLoadManager()<NSCopying, NSMutableCopying>

@property (nonatomic, strong) NSMutableDictionary *downloadDic;
@end


@implementation TKDownLoadManager

#pragma mark - 单例
static TKDownLoadManager *_shareInstance;
+ (instancetype)shareInstance {
    if (_shareInstance == nil) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}

#pragma mark - 懒加载
// key: md5(url)  value: XMGDownLoader
- (NSMutableDictionary *)downloadDic {
    if (!_downloadDic) {
        _downloadDic = [NSMutableDictionary dictionary];
    }
    return _downloadDic;
}

#pragma mark - 对外接口
/** 根据URL下载资源 */
- (TKDownLoader *)downLoadWithURL: (NSURL *)url {
    NSString *urlMd5 = [url.absoluteString md5];
    TKDownLoader *download = self.downloadDic[urlMd5];
    if (download) {
        [download resumeCurrentTask];
        return download;
    }
    
    download = [[TKDownLoader alloc]init];
    [self.downloadDic setValue:download forKey:urlMd5];
    
    __weak typeof(self) weakSelf = self;
    [download downLoader:url downLoadInfo:nil progress:nil success:^(NSString *filePath) {
        [weakSelf.downloadDic removeObjectForKey:urlMd5];
    } failed:^{
        [weakSelf.downloadDic removeObjectForKey:urlMd5];
    }];
    
    return download;
}

/** 获取url对应的downLoader */
- (TKDownLoader *)getDownLoaderWithURL: (NSURL *)url {
    NSString *urlMd5 = [url.absoluteString md5];
    TKDownLoader *download = self.downloadDic[urlMd5];
    return download;
}

- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlockType)progressBlock success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock {
    // 1.url
    NSString *urlMd5 = [url.absoluteString md5];
    
    //2. 根据url查找对应的下载器
    TKDownLoader *downloader = self.downloadDic[urlMd5];
    if (downloader == nil) {
        downloader = [[TKDownLoader alloc]init];
        self.downloadDic[urlMd5] = downloader;
    }
    
    //3. 下载
    __weak typeof(self) weakSelf = self;
    [downloader downLoader:url downLoadInfo:downLoadInfo progress:progressBlock success:^(NSString *filePath) {
        //下载完成, 删除对应的下载器
        [weakSelf.downloadDic removeObjectForKey:urlMd5];
        if (successBlock) {
            successBlock(filePath);
        }
    } failed:^{
        [weakSelf.downloadDic removeObjectForKey:urlMd5];
        if (failedBlock) {
            failedBlock();
        }
    }];
}

- (void)pauseWithURL:(NSURL *)url {
    TKDownLoader *download = [self getDownLoaderWithURL:url];
    [download pauseCurrentTask];
}

-(void)resumeWithURL:(NSURL *)url {
    TKDownLoader *download = [self getDownLoaderWithURL:url];
    [download resumeCurrentTask];
}

-(void)cancelWithURL:(NSURL *)url {
    TKDownLoader *download = [self getDownLoaderWithURL:url];
    [download cancelCurrentTask];
}

-(void)pauseAll {
    [self.downloadDic.allValues performSelector:@selector(pauseCurrentTask) withObject:nil];
}

-(void)resumeAll {
    [self.downloadDic.allValues performSelector:@selector(resumeCurrentTask) withObject:nil];
}
@end
