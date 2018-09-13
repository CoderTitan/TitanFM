//
//  TodayFireVoiceTableController.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TodayFireVoiceTableController.h"
#import "TodayFireVoiceCell.h"
#import "TodayFireViewModel.h"
#import "TodayFireCellModel.h"


#define kBaseUrl @"http://mobile.ximalaya.com/"

@interface TodayFireVoiceTableController ()

@property (nonatomic, strong) NSArray<TodayFireCellModel *> *voiceModels;


@end

@implementation TodayFireVoiceTableController

#pragma mark - 重写set/get方法
- (void)setVoiceModels:(NSArray<TodayFireCellModel *> *)voiceModels {
    _voiceModels = voiceModels;
    [self.tableView reloadData];
}


#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 80;
    __weak typeof(self) weakSelf = self;
    
    
    [[TodayFireViewModel shareInstance] getTodayFireVoiceMsWithKey:self.loadKey result:^(NSArray<DownloadVoiceModel *> *voiceArr) {
        NSMutableArray *cellModels = [NSMutableArray array];
        for (DownloadVoiceModel *model in voiceArr) {
            TodayFireCellModel *voiceM = [[TodayFireCellModel alloc]init];
            voiceM.voiceModel = model;
            [cellModels addObject:voiceM];
        }
        weakSelf.voiceModels = cellModels;
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.voiceModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodayFireVoiceCell *cell = [TodayFireVoiceCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TodayFireCellModel *cellModel = self.voiceModels[indexPath.row];
    cellModel.sortNum = indexPath.row + 1;
    [cellModel bindWithCell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TodayFireCellModel *model = self.voiceModels[indexPath.row];
    
    NSLog(@"%@", model.voiceModel.title);
}

@end
