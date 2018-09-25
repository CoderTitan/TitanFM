//
//  TKAnchorTableController.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKAnchorTableController.h"
#import "TKSingerGroupTableCell.h"
#import "TKAnchorViewModel.h"
#import "TKAnchorGroupCell.h"



@interface TKAnchorTableController ()
@property (nonatomic, strong) NSArray <TKAnchorGroupModel *> *anchorGroupArr;

@end

@implementation TKAnchorTableController

- (void)setAnchorGroupArr:(NSArray<TKAnchorGroupModel *> *)anchorGroupArr {
    _anchorGroupArr = anchorGroupArr;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
    
    [[TKAnchorViewModel shareInstance] getAnchorMs:^(NSArray<TKAnchorGroupModel *> * _Nonnull anchorModels) {
        self.anchorGroupArr = anchorModels;
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.anchorGroupArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKAnchorGroupModel *groupModel = self.anchorGroupArr[indexPath.row];
    
    // 6个, 上下列表样式
    if (groupModel.displayStyle == 2) {
        // 九宫格样式, 4个, 或者 6个
        TKSingerGroupTableCell *cell = [TKSingerGroupTableCell cellWithTableView:tableView];
        cell.anchorGroupM = groupModel;
        return cell;
    } else {
        TKAnchorGroupCell *cell = [TKAnchorGroupCell cellWithTableView:tableView];
        cell.anchorGroupM = groupModel;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKAnchorGroupModel *model = self.anchorGroupArr[indexPath.row];
    return model.cellHeight;
}

@end
