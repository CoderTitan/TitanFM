//
//  TodayFireCellModel.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TodayFireCellModel.h"
#import "UIButton+WebCache.h"
#import "TKDownLoadManager.h"
#import "TKRemotePlayer.h"
#import "TitanModelSqliteTool.h"


@interface TodayFireCellModel ()
@property (nonatomic, weak) TodayFireVoiceCell *cell;

@end

@implementation TodayFireCellModel
#pragma mark - 系统方法
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChange:) name:kDownLoadURLOrStateChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStateChange:) name:kRemotePlayerURLOrStateChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 对外方法
- (void)bindWithCell:(TodayFireVoiceCell *)cell {
    self.cell = cell;
    
    cell.voiceTitleLabel.text = [self title];
    cell.voiceAuthorLabel.text = [self authorName];
    [cell.playOrPauseBtn sd_setBackgroundImageWithURL:[self voiceURL] forState:UIControlStateNormal];
    cell.sortNumLabel.text = [self sortNumStr];
    
    //动态获取下载/播放状态
    cell.state = [self cellDownloadState];
    cell.playOrPauseBtn.selected = [self isPlaying];
    
    //事件处理
    [cell setPlayBlock:^(BOOL isPlay) {
        if (isPlay) {
            [[TKRemotePlayer shareInstance] playWithURL:[self playOrDownLoadURL] isCache:NO];
        } else {
            [[TKRemotePlayer shareInstance] pauseCurrent];
        }
    }];
    
    __weak typeof(self) weakSelf = self;
    [cell setDownLoadBlock:^{
        __strong typeof(weakSelf.voiceModel) strongVoiceM = weakSelf.voiceModel;
        [[TKDownLoadManager shareInstance] downLoader:[self playOrDownLoadURL] downLoadInfo:^(long long totalSize) {
            strongVoiceM.totalSize = totalSize;
            [TitanModelSqliteTool saveOrUpdateModel:strongVoiceM uid:nil];
        } progress:nil success:^(NSString *filePath) {
            strongVoiceM.isDownLoaded = YES;
            [TitanModelSqliteTool saveOrUpdateModel:strongVoiceM uid:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCache" object:nil];
        } failed:nil];
    }];
}


#pragma mark - 通知监听
- (void)downLoadStateChange: (NSNotification *)notice {
    NSDictionary *dic = notice.userInfo;
    NSString *url = dic[@"downLoadURL"];
    if (![url isEqual: [self playOrDownLoadURL]]) {
        return;
    }
    
    self.cell.state = [self cellDownloadState];
}

- (void)playStateChange: (NSNotification *)notice {
    NSDictionary *noticeDic = notice.userInfo;
    NSURL *url = noticeDic[@"playURL"];
    if (![[self playOrDownLoadURL] isEqual:url]) {
        self.cell.playOrPauseBtn.selected = NO;
        return;
    }
    
    TKRemotePlayerState state = [noticeDic[@"playState"] integerValue];
    if (state == TKRemotePlayerStatePlaying || state == TKRemotePlayerStateLoading) {
        self.cell.playOrPauseBtn.selected = YES;
    } else {
        self.cell.playOrPauseBtn.selected = NO;
    }
}

#pragma mark - 模型数据处理
- (NSString *)title {
    return self.voiceModel.title;
}

- (NSString *)authorName {
    return [NSString stringWithFormat:@"by %@", self.voiceModel.nickname];
}

- (NSURL *)voiceURL {
    return [NSURL URLWithString:self.voiceModel.coverSmall];
}

- (NSString *)sortNumStr {
    return [NSString stringWithFormat:@"%zd", self.sortNum];
}

- (NSURL *)playOrDownLoadURL {
    return [NSURL URLWithString:self.voiceModel.playPathAacv164];
}


#pragma mark - 私有方法
/// 动态计算下载状态
- (TodayFireVoiceCellState)cellDownloadState {
    TKDownLoader *downloader = [[TKDownLoadManager shareInstance] getDownLoaderWithURL: [self playOrDownLoadURL]];
    NSUInteger cachepathLength = [TKDownLoader downLoadedFileWithURL:[self playOrDownLoadURL]].length;
    if (downloader.state == TKDownLoaderStateDowning) {
        return TodayFireVoiceCellStateDownLoading;
    } else if (downloader.state == TKDownLoaderStateSuccess || cachepathLength > 0) {
        return TodayFireVoiceCellStateDownLoaded;
    }
    return TodayFireVoiceCellStateWaitDownLoad;
}

- (BOOL)isPlaying {
    if ([[self playOrDownLoadURL] isEqual:[TKRemotePlayer shareInstance].url]) {
        TKRemotePlayerState state = [TKRemotePlayer shareInstance].state;
        if (state == TKRemotePlayerStatePlaying || state == TKRemotePlayerStateLoading) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}
@end
