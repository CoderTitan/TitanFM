//
//  TodayFireCellModel.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadVoiceModel.h"
#import "TodayFireVoiceCell.h"


@interface TodayFireCellModel : NSObject

@property (nonatomic, strong) DownloadVoiceModel *voiceModel;

@property (nonatomic, assign) NSInteger sortNum;

- (void)bindWithCell: (TodayFireVoiceCell *)cell;

@end
