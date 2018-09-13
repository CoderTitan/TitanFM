//
//  DownloadAlbumCellModel.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownloadAlbumCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Layout.h"
#import "TitanModelSqliteTool.h"
#import "DownLoadVoiceAlbumController.h"
#import "DownloadVoiceModel.h"
#import "TKDownLoader.h"
#import "DownloadListenTool.h"
#import "DownloadAlbumCell.h"
#import "AlbumModel.h"



@implementation DownloadAlbumCellModel

- (void)bindWithCell:(DownloadAlbumCell *)cell {
    /** 专辑图片 */
    [cell.albumImageView sd_setImageWithURL:[self imageURL]];
    /** 专辑标题 */
    cell.albumTitleLabel.text = [self title];
    /** 专辑作者 */
    cell.albumAuthorLabel.text = [self author];
    /** 专辑集数 */
    [cell.albumPartsBtn setTitle:[self voiceCount] forState:UIControlStateNormal];
    /** 专辑大小 */
    [cell.albumPartsSizeBtn setTitle:[self totalSize] forState:UIControlStateNormal];
    
    /** 删除按钮点击执行代码块 */
    [cell setDeleteBlock:^{
        // 删除资源
        NSArray *voiceModels = [DownloadListenTool getDownLoadedVoiceModelsInAlbumID:self.albumModel.albumId];
        for (DownloadVoiceModel *model in voiceModels) {
            //从下载器中删除
            [TKDownLoader clearCacheWithURL: [NSURL URLWithString:model.playPathAacv164]];
        }
        //从数据库中删除
        [TitanModelSqliteTool deleteModel:[DownloadVoiceModel class] key:@"albumId" relation:ColumnNameToValueRelationTypeEqual value:@(self.albumModel.albumId) uid:nil];
        
        // 发送通知, 刷新表格
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCache" object:nil];
    }];
    
    /** 选中执行代码块 */
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell setSelectBlock:^{
        DownLoadVoiceAlbumController *vc = [[DownLoadVoiceAlbumController alloc]init];
        vc.albumID = weakSelf.albumModel.albumId;
        vc.navigationItem.title = weakSelf.albumModel.albumTitle;
        [weakCell.currentViewController.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - 私有方法
- (NSURL *)imageURL {
    return [NSURL URLWithString:self.albumModel.albumCoverMiddle];
}

- (NSString *)title {
    return self.albumModel.albumTitle;
}

- (NSString *)author {
    return self.albumModel.authorName;
}

- (NSString *)voiceCount {
    return [NSString stringWithFormat:@"%zd", self.albumModel.voiceCount];
}

- (NSString *)totalSize {
    return [self getFormatSizeWithSize:self.albumModel.allVoiceSize];
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
