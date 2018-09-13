//
//  DownloadVoiceCell.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadVoiceCell : UITableViewCell

/** 声音标题 */
@property (weak, nonatomic) IBOutlet UILabel *voiceTitleLabel;
/** 声音作者 */
@property (weak, nonatomic) IBOutlet UILabel *voiceAuthorLabel;
/** 声音播放次数 */
@property (weak, nonatomic) IBOutlet UIButton *voicePlayCountBtn;
/** 声音评论次数 */
@property (weak, nonatomic) IBOutlet UIButton *voiceCommentBtn;
/** 声音时长 */
@property (weak, nonatomic) IBOutlet UIButton *voiceDurationBtn;
/** 声音播放进度 */
@property (weak, nonatomic) IBOutlet UILabel *voicePlayProgressLabel;
/** 声音播放暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;

/** 声音下载进度背景(需要控制隐藏显示) */
@property (weak, nonatomic) IBOutlet UIView *progressBackView;

/** 声音下载或者暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *downLoadOrPauseBtn;

/** 声音下载进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *downLoadProgressV;

/** 声音下载进度label */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;


/** 选中执行代码块 */
@property (nonatomic, copy) void(^selectBlock)(void);

/** 播放执行代码块 */
@property (nonatomic, copy) void(^playBlock)(BOOL isPlay);

/** 删除执行代码块 */
@property (nonatomic, copy) void(^deleteBlock)(void);

/** 下载代码块 */
@property (nonatomic, copy) void(^downLoadBlock)(BOOL isDownLoad);



+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
