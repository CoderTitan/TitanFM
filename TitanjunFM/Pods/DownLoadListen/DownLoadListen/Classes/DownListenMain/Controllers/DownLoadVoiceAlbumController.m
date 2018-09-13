//
//  DownLoadVoiceAlbumController.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownLoadVoiceAlbumController.h"
#import "DownloadListenTool.h"
#import "DownloadVoicecellModel.h"
#import "DownloadVoiceCell.h"


@interface DownLoadVoiceAlbumController ()

@end

@implementation DownLoadVoiceAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadCache];
}

- (void)reloadCache {
    NSArray <DownloadVoiceModel *> *downLoadingModels = [DownloadListenTool getDownLoadedVoiceModelsInAlbumID:self.albumID];
    NSMutableArray <DownloadVoicecellModel *> *loadingCellModels = [NSMutableArray arrayWithCapacity:downLoadingModels.count];
    for (DownloadVoiceModel *model in downLoadingModels) {
        DownloadVoicecellModel *cellModel = [[DownloadVoicecellModel alloc]init];
        cellModel.voiceM = model;
        [loadingCellModels addObject:cellModel];
    }
    
    [self setDataSouce:loadingCellModels getCell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        return [DownloadVoiceCell cellWithTableView:tableView];
    } cellHeight:^CGFloat(id model) {
        return 80;
    } bind:^(UITableViewCell *cell, id model) {
        DownloadVoicecellModel *cellModel = (DownloadVoicecellModel *)model;
        DownloadVoiceCell *voiceCell = (DownloadVoiceCell *)cell;
        [cellModel bindWithCell:voiceCell];
    }];
}
@end
