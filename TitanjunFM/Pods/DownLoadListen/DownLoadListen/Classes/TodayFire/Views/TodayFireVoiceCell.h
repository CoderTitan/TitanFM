//
//  TodayFireVoiceCell.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadVoiceModel.h"


typedef NS_ENUM(NSUInteger, TodayFireVoiceCellState) {
    TodayFireVoiceCellStateWaitDownLoad,
    TodayFireVoiceCellStateDownLoading,
    TodayFireVoiceCellStateDownLoaded,
};

@interface TodayFireVoiceCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet UILabel *voiceTitleLabel;
/** 声音作者 */
@property (weak, nonatomic) IBOutlet UILabel *voiceAuthorLabel;
/** 声音播放暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
/** 声音排名标签 */
@property (weak, nonatomic) IBOutlet UILabel *sortNumLabel;
/** 声音下载按钮 */
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

@property (nonatomic, assign) TodayFireVoiceCellState state;


@property (nonatomic, copy) void(^playBlock)(BOOL isPlay);
@property (nonatomic, copy) void(^downLoadBlock)(void);

@end
