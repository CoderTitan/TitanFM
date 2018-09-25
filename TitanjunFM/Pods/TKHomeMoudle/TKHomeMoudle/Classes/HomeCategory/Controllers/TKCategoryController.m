//
//  TKCategoryController.m
//  All
//
//  Created by 田全军 on 2018/9/17.
//  Copyright © 2018年 田全军. All rights reserved.
//

#import "TKCategoryController.h"
#import "TitanADPicView.h"
#import "TKMenueView.h"
#import "TKClassItemModel.h"
#import "TKCategoryViewModel.h"
#import "TKCategoryCell.h"
#import "NSArray+Partition.h"
#import "UIImageView+Extension.h"
#import "UIButton+WebCache.h"
#import "BaseConstant.h"
#import "UIView+Layout.h"

@interface TKCategoryController ()
@property (nonatomic, strong) TitanADPicView *adPicView;

@property (nonatomic, strong) TKMenueView *menueView;

@property (nonatomic, strong) NSArray *classItemArrs;

@end

@implementation TKCategoryController
#pragma mark - 懒加载
- (TitanADPicView *)adPicView {
    if (_adPicView == nil) {
        TitanADPicView *adPicView = [TitanADPicView picViewWithLoadImageBlock:^(UIImageView *imageView, NSURL *url) {
            [imageView setURLImageWithURL:url progress:nil complete:nil];
        }];
        _adPicView = adPicView;
    }
    return _adPicView;
}

- (TKMenueView *)menueView {
    if (!_menueView) {
        TKMenueView *menuView = [[TKMenueView alloc]initWithFrame:CGRectZero];
        menuView.loadBlock = ^(UIButton *imageBtn, NSURL *url) {
            [imageBtn sd_setImageWithURL:url forState:UIControlStateNormal];
        };
        _menueView = menuView;
    }
    return _menueView;
}


#pragma mark - 初始化界面
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self loadDatas];
}

/// 初始化页面
- (void)initViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去除cell底部的横线
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kCommonMargin, 0);
    
    NSBundle *bundle = [NSBundle bundleForClass:[TKCategoryCell class]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TKCategoryCell" bundle:bundle] forCellReuseIdentifier:@"cell"];
    
    // 设置图片轮播器
    // 封装图片轮播器
    [self.tableView.tableHeaderView addSubview:self.adPicView];
    self.adPicView.frame = CGRectMake(0, 0, kScreenWidth, 150);
    
    // 设置菜单栏
    [self.tableView.tableHeaderView addSubview:self.menueView];
    self.menueView.frame = CGRectMake(0, self.adPicView.height, kScreenWidth, 100);
}

/// 数据处理
- (void)loadDatas {
    // 加载 广告
    kWeakSelf
    [[TKCategoryViewModel shareInstance] getAdList:^(NSArray<TKAdPicModel *> *adModels, NSError *error) {
        weakSelf.adPicView.picModels = adModels;
    }];
    
    // 加载 图文菜单
    [[TKCategoryViewModel shareInstance] getPicMenueList:^(NSArray<TKMenueModel *> *menuePicMs, NSError *error) {
        weakSelf.menueView.menueModels = menuePicMs;
    }];
    
    // 加载 选项列表
    [[TKCategoryViewModel shareInstance] getClassItemList:^(NSArray *classItemMs, NSError *error) {
        self.classItemArrs = classItemMs;
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.classItemArrs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *classItems = self.classItemArrs[section];
    return classItems.count / 2; // 每行cell显示2个,所以要除2
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TKCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *classItems = [self.classItemArrs[indexPath.section] partitionArrayWithStart:0 Count:2];;
    cell.modelArr = classItems[indexPath.row];
    
    return cell;
}

// cell每组Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

@end
