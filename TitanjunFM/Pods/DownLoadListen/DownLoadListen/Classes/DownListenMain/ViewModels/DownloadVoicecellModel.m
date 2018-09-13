//
//  DownloadVoicecellModel.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownloadVoicecellModel.h"
#import "TKRemotePlayer.h"
#import "TKDownLoadManager.h"
#import "TitanModelSqliteTool.h"
#import "UIButton+WebCache.h"
#import "DownloadVoiceModel.h"
#import "DownloadVoiceCell.h"


@interface DownloadVoicecellModel ()
@property (nonatomic, weak) NSTimer *updateTimer;

@property (nonatomic, weak) DownloadVoiceCell *cell;

@end

@implementation DownloadVoicecellModel
#pragma mark - 懒加载/初始化
- (NSTimer *)updateTimer {
    if (!_updateTimer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _updateTimer = timer;
    }
    return _updateTimer;
}

- (instancetype)init {
    if (self = [super init]) {
        [self updateTimer];
    }
    return self;
}

- (void)dealloc {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}


#pragma mark - 监听
- (void)bindWithCell:(DownloadVoiceCell *)cell {
    self.cell = cell;
    
    /** 声音标题 */
    cell.voiceTitleLabel.text = self.title;
    /** 声音作者 */
    cell.voiceAuthorLabel.text = self.author;
    /** 声音播放次数 */
    [cell.voicePlayCountBtn setTitle:self.playCount forState:UIControlStateNormal];
    /** 声音评论次数 */
    [cell.voiceCommentBtn setTitle:self.commentCount forState:UIControlStateNormal];
    /** 声音时长 */
    [cell.voiceDurationBtn setTitle:self.duration forState:UIControlStateNormal];
    [self.cell.playOrPauseBtn sd_setBackgroundImageWithURL:self.imageURL forState:UIControlStateNormal];
    
    /** 声音下载进度背景(需要控制隐藏显示) */
    cell.progressBackView.hidden = self.isDownLoaded;
    
    [self update];
    
    /** 选中执行代码块 */
    [cell setSelectBlock:^{
        NSLog(@"选中了这个cell");
    }];
    
    /** 播放执行代码块 */
    [cell setPlayBlock:^(BOOL isPlay) {
        if (isPlay) {
            [[TKRemotePlayer shareInstance] playWithURL:[self playAndDownLoadURL] isCache:NO];
        } else {
            [[TKRemotePlayer shareInstance] pauseCurrent];
        }
    }];
    
    /** 删除执行代码块 */
    [cell setDeleteBlock:^{
        //停止播放
        if ([self isPlaying]) {
            [[TKRemotePlayer shareInstance]pauseCurrent];
        }
        
        //清理记录
        [TitanModelSqliteTool deleteModel:self.voiceM uid:nil];
        
        //取消下载
        [[TKDownLoadManager shareInstance] cancelWithURL:[self playAndDownLoadURL]];
        
        //删除下载文件
        [TKDownLoader clearCacheWithURL:[self playAndDownLoadURL]];
        
        //通知, 刷新数据和页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCache" object:nil];
    }];
    
    /** 下载代码块 */
    __weak typeof(self) weakSelf = self;
    [cell setDownLoadBlock:^(BOOL isDownLoad) {
        __strong typeof(weakSelf.voiceM) strongVoiceM = weakSelf.voiceM;
        if (isDownLoad) {
            [[TKDownLoadManager shareInstance] downLoader:[self playAndDownLoadURL] downLoadInfo:nil progress:nil success:^(NSString *filePath) {
                strongVoiceM.isDownLoaded = YES;
                [TitanModelSqliteTool saveOrUpdateModel:strongVoiceM uid:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCache" object:nil];
            } failed:nil];
        } else {
            [[TKDownLoadManager shareInstance] pauseWithURL:[self playAndDownLoadURL]];
        }
    }];
}

- (void)update {
    /** 声音播放进度 */
    self.cell.voicePlayProgressLabel.text = self.playProgress;
    
    /** 声音播放暂停按钮 */
    self.cell.playOrPauseBtn.selected = self.isPlaying;
    
    /** 声音下载或者暂停按钮 */
    self.cell.downLoadOrPauseBtn.selected = self.isDownLoading;
    
    /** 声音下载进度条 */
    self.cell.downLoadProgressV.progress = self.downLoadProgress;
    
    /** 声音下载进度label */
    self.cell.progressLabel.text = self.progressStr;
}


#pragma mark - 私有方法
- (NSString *)title {
    return self.voiceM.title;
}

- (NSString *)author {
    return self.voiceM.nickname;
}

- (NSString *)playCount {
    return [NSString stringWithFormat:@"%zd", self.voiceM.favoritesCounts];
}

- (NSString *)commentCount {
    return [NSString stringWithFormat:@"%zd", self.voiceM.commentsCounts];
}

- (NSString *)duration {
    return [NSString stringWithFormat:@"%02zd:%02zd", self.voiceM.duration / 60, self.voiceM.duration % 60];
}

- (BOOL)isDownLoaded {
    return self.voiceM.isDownLoaded;
}

- (NSString *)playProgress {
    return @"66%";
}

- (NSURL *)playAndDownLoadURL {
    return [NSURL URLWithString:self.voiceM.playPathAacv164];
}

- (NSURL *)imageURL {
    return [NSURL URLWithString:self.voiceM.coverSmall];
}

- (BOOL)isPlaying {
    if ([[self playAndDownLoadURL] isEqual:[TKRemotePlayer shareInstance].url]) {
        TKRemotePlayerState state = [TKRemotePlayer shareInstance].state;
        return state == TKRemotePlayerStatePlaying;
    }
    return NO;
}

- (BOOL)isDownLoading {
    TKDownLoader *downLoader = [[TKDownLoadManager shareInstance] getDownLoaderWithURL:self.playAndDownLoadURL];
    if (downLoader) {
        
        TKDownLoaderState state = downLoader.state;
        return state == TKDownLoaderStateDowning;
    }
    return NO;
}

- (NSString *)progressStr {
    NSString *totalSize = [self getFormatSizeWithSize:self.voiceM.totalSize];
    NSString *currentSize = [self getFormatSizeWithSize:self.voiceM.totalSize * self.downLoadProgress];
    
    return  [NSString stringWithFormat:@"%@/%@", currentSize, totalSize];
}

- (float)downLoadProgress {
    // 如果当前有下载器在下载, 则直接获取
    // 如果没有, 则需要获取文件总大小, 以及本地的当前缓存大小
    return 1.0 * [TKDownLoader tmpCacheSizeWithURL:self.playAndDownLoadURL] / self.voiceM.totalSize;
}

- (NSString *)getFormatSizeWithSize: (long long)fileSize {
    NSArray *unit = @[@"B", @"kb", @"M", @"G"];
    
    double tmpSize = fileSize;
    int index = 0;
    while (tmpSize > 1024) {
        tmpSize /= 1024;
        index ++;
    }
    return [NSString stringWithFormat:@"%.1f%@",tmpSize, unit[index]];
}

@end
