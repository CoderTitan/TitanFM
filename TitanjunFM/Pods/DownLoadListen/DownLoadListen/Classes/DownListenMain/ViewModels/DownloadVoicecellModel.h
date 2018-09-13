//
//  DownloadVoicecellModel.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadVoiceModel;
@class DownloadVoiceCell;
@interface DownloadVoicecellModel : NSObject

// 原始数据
@property (nonatomic, strong) DownloadVoiceModel *voiceM;

- (void)bindWithCell: (DownloadVoiceCell *)cell;

@end
