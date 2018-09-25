//
//  TKRankingViewController.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRankingViewController.h"
#import "TitanADPicView.h"
#import "TKRankViewModel.h"
#import "TKRankingListCell.h"
#import "TKRankingListModel.h"
#import "NSArray+Partition.h"
#import "UIImageView+Extension.h"
#import "UIButton+WebCache.h"
#import "BaseConstant.h"
#import "UIView+Layout.h"



@interface TKRankingViewController ()
@property (nonatomic, strong) TitanADPicView *adPicView;

@property (nonatomic, strong) NSArray<TKRankingListModel *> *modelArrs;

@end

@implementation TKRankingViewController

- (TitanADPicView *)adPicView {
    if (_adPicView == nil) {
        TitanADPicView *adPicView = [TitanADPicView picViewWithLoadImageBlock:^(UIImageView *imageView, NSURL *url) {
            [imageView setURLImageWithURL:url progress:nil complete:nil];
        }];
        _adPicView = adPicView;
    }
    return _adPicView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self loadDatas];
}

/// 初始化页面
- (void)initViews {
    self.view.backgroundColor = backColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去除cell底部的横线
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kCommonMargin, 0);
    
    NSBundle *bundle = [NSBundle bundleForClass:[TKRankingListCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:@"TKRankingListCell" bundle:bundle] forCellReuseIdentifier:@"cell"];
    
    // 设置图片轮播器
    // 封装图片轮播器
    [self.tableView.tableHeaderView addSubview:self.adPicView];
    self.adPicView.frame = CGRectMake(0, 0, kScreenWidth, 150);
}

/// 数据处理
- (void)loadDatas {
    // 加载 广告
    kWeakSelf
    [[TKRankViewModel shareInstance] getAdList:^(NSArray<TKAdPicModel *> *adModels, NSError *error) {
        weakSelf.adPicView.picModels = adModels;
    }];
    
    // 加载 选项列表
    [[TKRankViewModel shareInstance] getClassItemList:^(NSArray<TKRankingListModel *> * _Nonnull classItemMs, NSError * _Nonnull error) {
        self.modelArrs = classItemMs;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArrs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TKRankingListModel *listModel = self.modelArrs[section];
    return listModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKRankingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TKRankingListModel *listModel = self.modelArrs[indexPath.section];
    cell.infoModel = listModel.list[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    TKRankingListModel *listModel = self.modelArrs[section];
    UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (headerView.height - 30) / 2, headerView.width / 2, 30)];
    titLabel.text = listModel.title;
    titLabel.font = [UIFont systemFontOfSize:14];
    titLabel.textColor = [UIColor orangeColor];
    [headerView addSubview:titLabel];
    
    UILabel *rightL = [[UILabel alloc]initWithFrame:CGRectMake(headerView.width - 15 - 30, (headerView.height - 30) / 2, 30, 30)];
    rightL.text = @">";
    rightL.font = [UIFont systemFontOfSize:20];
    rightL.textColor = [UIColor lightGrayColor];
    rightL.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:rightL];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.height - 1, headerView.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineView];
    
    return headerView;
}

@end
