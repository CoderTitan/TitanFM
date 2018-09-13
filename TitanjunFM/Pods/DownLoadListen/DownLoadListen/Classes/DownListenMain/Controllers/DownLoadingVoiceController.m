//
//  DownLoadingVoiceController.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownLoadingVoiceController.h"
#import "DownloadListenTool.h"
#import "DownloadVoiceCell.h"
#import "DownloadVoicecellModel.h"



@interface DownLoadingVoiceController ()

@end

@implementation DownLoadingVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadCache];
}

- (void)reloadCache {
    
    NSArray <DownloadVoiceModel *> *albumArr = [DownloadListenTool getDownLoadingVoiceModels];
    NSMutableArray <DownloadVoicecellModel *> *cellModelArr = [NSMutableArray arrayWithCapacity:albumArr.count];
    for (DownloadVoiceModel *model in albumArr) {
        DownloadVoicecellModel *cellModel = [[DownloadVoicecellModel alloc]init];
        cellModel.voiceM = model;
        [cellModelArr addObject:cellModel];
    }
    
    [self setDataSouce:cellModelArr getCell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        return [DownloadVoiceCell cellWithTableView:tableView];
    } cellHeight:^CGFloat(id model) {
        return 110;
    } bind:^(UITableViewCell *cell, id model) {
        DownloadVoiceCell *albumCell = (DownloadVoiceCell *)cell;
        DownloadVoicecellModel *cellModel = (DownloadVoicecellModel *)model;
        [cellModel bindWithCell:albumCell];
    }];
    
}

@end
