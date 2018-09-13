//
//  DownLoadAlbumController.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownLoadAlbumController.h"
#import "DownloadListenTool.h"
#import "DownloadAlbumCell.h"
#import "DownloadAlbumCellModel.h"

@interface DownLoadAlbumController ()

@end

@implementation DownLoadAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadCache];
}

- (void)reloadCache {

    NSArray <AlbumModel *> *albumArr = [DownloadListenTool getDownLoadedAlbums];
    NSMutableArray <DownloadAlbumCellModel *> *cellModelArr = [NSMutableArray arrayWithCapacity:albumArr.count];
    for (AlbumModel *model in albumArr) {
        DownloadAlbumCellModel *cellModel = [[DownloadAlbumCellModel alloc]init];
        cellModel.albumModel = model;
        [cellModelArr addObject:cellModel];
    }
    
    [self setDataSouce:cellModelArr getCell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        return [DownloadAlbumCell cellWithTableView:tableView];
    } cellHeight:^CGFloat(id model) {
        return 80;
    } bind:^(UITableViewCell *cell, id model) {
        DownloadAlbumCell *albumCell = (DownloadAlbumCell *)cell;
        DownloadAlbumCellModel *cellModel = (DownloadAlbumCellModel *)model;
        [cellModel bindWithCell:albumCell];
    }];
    
}
@end
