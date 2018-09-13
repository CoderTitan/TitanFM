//
//  TKRemotePlayer.h
//  PlayerManager
//
//  Created by quanjunt on 2018/9/3.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kRemotePlayerURLOrStateChangeNotification @"remotePlayerURLOrStateChangeNotification"


/**
 * 播放器的状态
 * 因为UI界面需要加载状态显示, 所以需要提供加载状态
 - TKRemotePlayerStateUnknown: 未知(比如都没有开始播放音乐)
 - TKRemotePlayerStateLoading: 正在加载()
 - TKRemotePlayerStatePlaying: 正在播放
 - TKRemotePlayerStateStopped: 停止
 - TKRemotePlayerStatePause:   暂停
 - TKRemotePlayerStateFailed:  失败(比如没有网络缓存失败, 地址找不到)
 */
typedef NS_ENUM(NSInteger, TKRemotePlayerState) {
    TKRemotePlayerStateUnknown = 0,
    TKRemotePlayerStateLoading   = 1,
    TKRemotePlayerStatePlaying   = 2,
    TKRemotePlayerStateStopped   = 3,
    TKRemotePlayerStatePause     = 4,
    TKRemotePlayerStateFailed    = 5
};


@interface TKRemotePlayer : NSObject

/** 单例对象 */
+ (instancetype)shareInstance;

/**
 根据一个url地址, 播放相关的远程音频资源
 
 @param url url地址
 @param isCache 是否需要缓存
 */
- (void)playWithURL:(NSURL *)url isCache:(BOOL)isCache;

/**
 暂停当前音频
 */
- (void)pauseCurrent;

/**
 继续播放
 */
- (void)resumeCurrent;

/**
 停止播放
 */
- (void)stopCurrent;

/**
 快速播放到某个时间点
 
 @param time 时间
 */
- (void)seekWithTime: (NSTimeInterval)time;

/**
 根据进度播放
 
 */
- (void)seekWithProgress: (float)progress;


#pragma mark - 数据提供

/** 是否静音, 可以反向设置数据 */
@property (nonatomic, assign) BOOL muted;
/** 音量大小 */
@property (nonatomic, assign) float volume;
/** 当前播放速率 */
@property (nonatomic, assign) float rate;


/** 总时长 */
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
/** 总时长(格式化后的) */
@property (nonatomic, copy, readonly) NSString *totalTimeFormat;
/** 已经播放时长 */
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
/** 已经播放时长(格式化后的) */
@property (nonatomic, copy, readonly) NSString *currentTimeFormat;
/** 播放进度 */
@property (nonatomic, assign, readonly) float progress;
/** 当前播放的url地址 */
@property (nonatomic, strong, readonly) NSURL *url;
/** 加载进度 */
@property (nonatomic, assign, readonly) float loadDataProgress;
/** 播放状态 */
@property (nonatomic, assign, readonly) TKRemotePlayerState state;


@end
