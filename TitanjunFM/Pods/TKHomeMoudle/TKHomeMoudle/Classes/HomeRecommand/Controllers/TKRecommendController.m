//
//  TKRecommendController.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRecommendController.h"
#import "TitanAdPicView.h"
#import "TKAdPicModel.h"
#import "TKMenueView.h"
#import "UIImageView+Extension.h"
#import "UIButton+WebCache.h"
#import "BaseConstant.h"
#import "UIView+Layout.h"
#import "TKAdPicTableCell.h"
#import "TKSpecialColumnCell.h"
#import "TKRecommandViewModel.h"
#import "TKHomeRecommandDefine.h"
#import "TKRecommendCell.h"
#import <SafariServices/SafariServices.h>



@interface TKRecommendController ()

@property (nonatomic, strong) TitanADPicView *adPicView;

@property (nonatomic, strong) TKMenueView *menueView;

@property (nonatomic, strong) NSMutableArray *listModels;

@end

@implementation TKRecommendController
#pragma mark - 懒加载
@synthesize listModels = _listModels;
- (NSMutableArray *)listModels {
    if (_listModels == nil) {
        _listModels = [NSMutableArray array];
    }
    
    // 根据模型的sortID进行排序
    [_listModels sortUsingComparator:^NSComparisonResult(TKGroupModel *obj1, TKGroupModel *obj2) {
        
        if (obj1.sortID < obj2.sortID) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    return _listModels;
}

- (void)setListModels:(NSMutableArray *)listModels {
    _listModels = listModels;
    [self.tableView reloadData];
}

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


#pragma mark - 页面处理
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self loadDatas];
}

/// 初始化页面
- (void)initViews {
    self.view.backgroundColor = backColor;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kCommonMargin, 0);
    
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
    // 加载广告
    kWeakSelf;
    [[TKRecommandViewModel shareInstance] getAdList:^(NSArray<TKAdPicModel *> *adMs, NSError * _Nonnull error) {
        for (int i = 0; i < adMs.count; i ++) {
            TKAdPicModel *adModel = adMs[i];
            __weak TKAdPicModel *weakAdModel = adModel;
            weakAdModel.clickBlock = ^{
                NSInteger type = weakAdModel.focusImageM.type;
                NSInteger albumID = weakAdModel.focusImageM.albumId;
                UINavigationController *nav = self.navigationController;
                
                if (type == 9) {
                    NSLog(@"听单处理");
                } else if (type == 3) {
                    NSLog(@"播放器界面");
                    NSString *albumID = [NSString stringWithFormat:@"%zd", weakAdModel.focusImageM.trackId];
                    kPresentToPlayer(albumID)
                } else if (type == 2) {
                    NSLog(@"跳转到专辑详情");
                    // 跳转到专辑详情
                    UINavigationController *nav = self.navigationController;
                    NSString *albumIDStr = [NSString stringWithFormat:@"%zd", albumID];
                    kJumpToAlbumDetail(albumIDStr, nav)
                } else if (type == 4) {
                    // 打开网页
                    SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:weakAdModel.focusImageM.url]];
                    sfvc.title = @"商城";
                    [nav pushViewController:sfvc animated:YES];
                }
            };
        }
        weakSelf.adPicView.picModels = adMs;
    }];
    
    // 加载 图文菜单列表
    [[TKRecommandViewModel shareInstance]getPicMenueList:^(NSArray<TKMenueModel *> * _Nonnull menuePicMs, NSError * _Nonnull error) {
        weakSelf.menueView.menueModels = menuePicMs;
    }];
    
    // 加载 小编推荐
    [[TKRecommandViewModel shareInstance] getEditorRecommendAlbums:^(TKGroupModel * _Nonnull groupM, NSError * _Nonnull error) {
        groupM.sortID = 1;
        [weakSelf.listModels addObject:groupM];
        [weakSelf.tableView reloadData];
    }];
    
    // 加载 现场直播
    [[TKRecommandViewModel shareInstance] getLiveMs:^(TKGroupModel * _Nonnull groupM, NSError * _Nonnull error) {
        groupM.sortID = 2;
        [weakSelf.listModels addObject:groupM];
        [weakSelf.tableView reloadData];
    }];
    
    // 加载 精品听单
    [[TKRecommandViewModel shareInstance] getSpecialColumnMs:^(TKGroupModel * _Nonnull groupM, NSError * _Nonnull error) {
        groupM.sortID = 4;
        [weakSelf.listModels addObject:groupM];
        [weakSelf.tableView reloadData];
    }];
    
    // 加载 推广
    [[TKRecommandViewModel shareInstance] getTuiGuangMs:^(TKGroupModel * _Nonnull groupM, NSError * _Nonnull error) {
        groupM.sortID = 5;
        [weakSelf.listModels addObject:groupM];
        [weakSelf.tableView reloadData];
    }];
    
    // 加载  听"广州"
    [[TKRecommandViewModel shareInstance] getCityAlbums:^(TKGroupModel * _Nonnull groupM, NSError * _Nonnull error) {
        groupM.sortID = 3;
        [weakSelf.listModels addObject:groupM];
        [weakSelf.tableView reloadData];
    }];
    
    // 加载 "热门推荐"
    [[TKRecommandViewModel shareInstance] getHotRecommendsAlbums:^(NSArray<TKGroupModel *> * _Nonnull groupMs, NSError * _Nonnull error) {
        [weakSelf.listModels addObjectsFromArray:groupMs];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKGroupModel *groupM = self.listModels[indexPath.row];
    
    UITableViewCell *cell;
    
    if (groupM.cellType == CellTypeList3) {
        cell = [TKRecommendCell cellWithTableView:tableView];
        [(TKRecommendCell *)cell setGroupM:groupM];
    } else if(groupM.cellType == CellTypeList1) {
        cell = [TKAdPicTableCell cellWithTableView:tableView];
        [(TKAdPicTableCell *)cell setGroupM:groupM];
    } else if(groupM.cellType == CellTypeList2) {
        cell = [TKSpecialColumnCell cellWithTableView:tableView];
        [(TKSpecialColumnCell *)cell setGroupM:groupM];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKGroupModel *groupM = self.listModels[indexPath.row];
    
    if (groupM.cellType == CellTypeList1) {
        return 210;
    }
    
    if (groupM.cellType == CellTypeList3) {
        return 240;
    }
    
    if (groupM.cellType == CellTypeList2) {
        if (groupM.sortID == 4) {
            return 120;
        }
        return 210;
    }
    
    return 0;
}

@end
