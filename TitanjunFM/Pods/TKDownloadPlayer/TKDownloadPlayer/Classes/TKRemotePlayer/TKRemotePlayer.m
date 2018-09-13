//
//  TKRemotePlayer.m
//  PlayerManager
//
//  Created by quanjunt on 2018/9/3.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRemotePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "TKRemoteLoaderDelegate.h"
#import "NSURL+Extension.h"


@interface TKRemotePlayer ()<NSCopying, NSMutableCopying>
{
    /// 标识用户是否进行了手动暂停
    BOOL _isUserPause;
}

/** 音频播放器 */
@property (nonatomic, strong) AVPlayer *player;
/** 资源加载代理 */
@property (nonatomic, strong) TKRemoteLoaderDelegate *resourceDelegate;
@end



@implementation TKRemotePlayer
#pragma mark - 单例
static TKRemotePlayer *_shareInstance;
+ (instancetype)shareInstance {
    if (!_shareInstance) {
        _shareInstance = [[TKRemotePlayer alloc] init];
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


#pragma mark - 对外接口
/**
 根据一个url地址, 播放相关的远程音频资源
 
 @param url url地址
 @param isCache 是否需要缓存
 */
- (void)playWithURL:(NSURL *)url isCache:(BOOL)isCache {
    NSURL *currentURl = [(AVURLAsset *)self.player.currentItem.asset URL];
    if ([url isEqual:currentURl] || [[url streamingURL] isEqual:currentURl]) {
        NSLog(@"当前播放任务已经存在");
        [self resumeCurrent];
        return;
    }
    
    //创建一个播放器对象
    //playerWithURL: 如果使用该方法播放远程视频如果资源加载比较慢可能会出现调用了play方法, 但是并没有播放视频的情况
    //这个方法, 默认帮我们封装了三部: 资源的请求-资源的组织-资源的播放
    
    // 0. 清除监听
    if (self.player.currentItem) {
        [self removeObserver];
    }
    
    self.url = url;
    if (isCache) {
        url = [url streamingURL];
    }
    
    // 1.资源的请求
    AVURLAsset *assset = [AVURLAsset assetWithURL:url];
    self.resourceDelegate = [[TKRemoteLoaderDelegate alloc]init];
    [assset.resourceLoader setDelegate:self.resourceDelegate queue:dispatch_get_main_queue()];
    
    // 2. 资源的组织
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:assset];
    //当资源的组织者, 告诉我们资源准备好了之后, 我们在播放: status
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playInterupt) name:AVPlayerItemPlaybackStalledNotification object:nil];
    
    // 3.资源的播放
    self.player = [AVPlayer playerWithPlayerItem:item];
}

/**
 暂停当前音频
 */
- (void)pauseCurrent {
    [self.player pause];
    _isUserPause = YES;
    if (self.player) {
        self.state = TKRemotePlayerStatePause;
    }
}

/**
 继续播放
 */
- (void)resumeCurrent {
    [self.player play];
    _isUserPause = NO;
    // 就是代表,当前播放器存在, 并且, 数据组织者里面的数据准备, 已经足够播放了
    if (self.player && self.player.currentItem.playbackLikelyToKeepUp) {
        self.state = TKRemotePlayerStatePlaying;
    }
}

/**
 停止播放
 */
- (void)stopCurrent {
    [self.player pause];
//    [self clearObserver:self.player.currentItem];
    self.player = nil;
    if (self.player) {
        self.state = TKRemotePlayerStateStopped;
    }
}

/**
 快速播放到某个时间点
 
 @param time 时间
 */
- (void)seekWithTime: (NSTimeInterval)time {
    // 1. 获取当前的时间点(秒)
    double currentTime = [self currentTime] + time;
    double totalTime = [self totalTime];
    
    [self seekWithProgress:currentTime / totalTime];
}

/**
 根据进度播放
 
 */
- (void)seekWithProgress: (float)progress {
    if (progress < 0 || progress > 1) {
        return;
    }

    //目标时间点
    double currentTimeSec = [self totalTime] * progress;
    CMTime playTime = CMTimeMakeWithSeconds(currentTimeSec, NSEC_PER_SEC);
    
    //移动到某时间点
    [self.player seekToTime:playTime completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"确认加载这个时间节点的数据");
        } else {
            NSLog(@"取消加载这个时间节点的播放数据");
        }
    }];
}


#pragma mark - 重写set/get方法
- (void)setRate:(float)rate {
    self.player.rate = rate;
}

- (float)rate {
    return self.player.rate;
}

- (void)setVolume:(float)volume {
    if (volume > 0) {
        [self setMute:NO];
    }
    self.player.volume = volume;
}

- (float)volume {
    return self.player.volume;
}

- (void)setMute:(BOOL)mute {
    self.player.muted = mute;
}

- (BOOL)mute {
    return self.player.muted;
}

-(void)setUrl:(NSURL *)url {
    _url = url;
    if (self.url) {
        NSDictionary *infoDic = @{@"playURL": self.url, @"playState": @(self.state)};
        [[NSNotificationCenter defaultCenter] postNotificationName:kRemotePlayerURLOrStateChangeNotification object:nil userInfo:infoDic];
    }
}

- (void)setState:(TKRemotePlayerState)state {
    _state = state;
    if (self.url) {
        NSDictionary *infoDic = @{@"playURL": self.url, @"playState": @(state)};
        [[NSNotificationCenter defaultCenter] postNotificationName:kRemotePlayerURLOrStateChangeNotification object:nil userInfo:infoDic];
    }
}

/** 播放进度 */
- (float)progress {
    if (self.totalTime == 0) {
        return 0;
    }
    return self.currentTime / self.totalTime;
}

/** 资源加载进度 */
- (float)loadDataProgress {
    if (self.totalTime == 0) {
        return 0;
    }
    
    //当前家在进度
    CMTimeRange timeRange = [[self.player.currentItem loadedTimeRanges].lastObject CMTimeRangeValue];
    CMTime loadTime = CMTimeAdd(timeRange.start, timeRange.duration);
    NSTimeInterval loadTimeSpec = CMTimeGetSeconds(loadTime);
    
    return loadTimeSpec / self.totalTime;
}

/** 总时长 */
-(NSTimeInterval)totalTime {
    NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(totalTime)) {
        return 0;
    }
    return totalTime;
}

/** 总时长(格式化后的) */
- (NSString *)totalTimeFormat {
    return [NSString stringWithFormat:@"%02d:%02d", (int)self.totalTime / 60, (int)self.totalTime % 60];
}

/** 已经播放时长 */
- (NSTimeInterval)currentTime {
    NSTimeInterval playTimeSec = CMTimeGetSeconds(self.player.currentItem.currentTime);
    if (isnan(playTimeSec)) {
        return 0;
    }
    return playTimeSec;
}

/**当前音频资源播放时长(格式化后) */
- (NSString *)currentTimeFormat {
    return [NSString stringWithFormat:@"%02d:%02d", (int)self.currentTime / 60, (int)self.currentTime % 60];
}



#pragma mark - KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"资源准备好了, 这时候播放就没有问题");
            [self resumeCurrent];
        } else {
            NSLog(@"状态未知");
            self.state = TKRemotePlayerStateFailed;
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        BOOL ptk = [change[NSKeyValueChangeNewKey] boolValue];
        if (ptk) {
            NSLog(@"当前的资源, 准备的已经足够播放了");
            // 用户的手动暂停的优先级最高
            if (!_isUserPause) {
                [self resumeCurrent];
            } else {
                
            }
        } else {
            NSLog(@"资源还不够, 正在加载过程当中");
            self.state = TKRemotePlayerStateLoading;
        }
    }
}

/**
 播放完成
 */
- (void)playEnd {
    NSLog(@"播放完成");
    self.state = TKRemotePlayerStateStopped;
}

/**
 被打断
 */
- (void)playInterupt {
    // 来电话, 资源加载跟不上
    NSLog(@"播放被打断");
    self.state = TKRemotePlayerStatePause;
}


#pragma mark - 私有方法
- (void)removeObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc {
    [self removeObserver];
}
@end
