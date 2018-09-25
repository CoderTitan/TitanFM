//
//  TKRadioBroadcaseController.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRadioBroadcaseController.h"
#import "TKRadioTableCell.h"
#import "TKRadioBroadcaseViewModel.h"
#import "BaseConstant.h"
#import "UIView+Layout.h"
#import "TKRadioCategoryView.h"
#import "TKRedioCategoryCell.h"
#import "TKRadioCategoryController.h"



@interface TKRadioBroadcaseController ()
@property (nonatomic, strong) NSMutableArray *listModels;
@property (nonatomic, strong)TKRadioCategoryView *headerView;

@property (nonatomic, strong)NSMutableArray<TKRedioCategoryModel *> *categorieModels;

@end

@implementation TKRadioBroadcaseController

#pragma mark - 懒加载
- (NSMutableArray *)listModels {
    if (_listModels == nil) {
        _listModels = [NSMutableArray array];
    }
    
    [_listModels sortUsingComparator:^NSComparisonResult(TKRadioArrModel *obj1, TKRadioArrModel *obj2) {
        if (obj1.sortID < obj2.sortID) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    return _listModels;
}

#pragma mark - 页面和数据
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self loadData];
}

- (void)initViews {
    self.view.backgroundColor = backColor;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 310;
    self.headerView = [[NSBundle bundleForClass:[TKRadioCategoryView class]] loadNibNamed:@"TKRadioCategoryView" owner:nil options:nil].firstObject;
    
    // 头部collectionViewCell点击回调的block
    kWeakSelf
    self.headerView.selectorItemBlock = ^(TKRedioCategoryCell* cell, NSIndexPath *indexPath){
        [weakSelf collectionViewSeletorItemAtCell:cell indexPath:indexPath];
    };
    
    self.headerView.height = 300;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)loadData {
    //头部电台列表
    [[TKRadioBroadcaseViewModel shareInstance] getCategoriesList:^(NSMutableArray<TKRedioCategoryModel *> * _Nonnull categorieModels, NSError * _Nonnull error) {
        self.headerView.categorieModels = categorieModels;
        self.headerView.height = 100 + 130;
        self.tableView.tableHeaderView = self.headerView;
        self.categorieModels = categorieModels;
    }];
    
    // 本地电台列表
    [[TKRadioBroadcaseViewModel shareInstance] getLocalRadioList:^(TKRadioArrModel * _Nonnull radioModels, NSError * _Nonnull error) {
        [self.listModels addObject:radioModels];
        [self.tableView reloadData];
    }];
    
    
    // 排行榜列表
    [[TKRadioBroadcaseViewModel shareInstance] getTopRadioList:^(TKRadioArrModel * _Nonnull radioModels, NSError * _Nonnull error) {
        [self.listModels addObject:radioModels];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKRadioTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    TKRadioArrModel *radioModels = self.listModels[indexPath.row];
    
    if (!cell) {
        cell = [[NSBundle bundleForClass:[TKRadioTableCell class]] loadNibNamed:@"TKRadioTableCell" owner:nil  options:nil].firstObject;
    }
    
    cell.listModels = radioModels;
    
    // cell 更多按钮点击处理
    kWeakSelf
    cell.moreBlock = ^(TKRadioTableCell *cell){
        [weakSelf moreBtnClick:cell];
    };
    
    return cell;
}

- (void)collectionViewSeletorItemAtCell:(UICollectionViewCell *)cell indexPath: (NSIndexPath *)indexPath {
    NSRange range= NSMakeRange(0,7);
    
    NSMutableArray *smallCategorieMs = [NSMutableArray arrayWithArray:[self.headerView.categorieModels subarrayWithRange:range]];
    
    TKRedioCategoryModel *lastModel = [[TKRedioCategoryModel alloc] init];
    lastModel.isLast = YES;
    
    [smallCategorieMs addObject:lastModel];
    
    // 判断是否点击最后一个
    if (indexPath.row == self.headerView.categorieModels.count - 1) {
        
        self.headerView.categorieModels = self.headerView.categorieModels.count <= 8 ? self.categorieModels : smallCategorieMs;
        
        [UIView animateWithDuration:.1 animations:^{
            self.headerView.height = self.headerView.categorieModels.count <= 8 ? (100 + 10 + 30 * 2) : (100 + 130);
            self.tableView.tableHeaderView = self.headerView;
        }];
        
        return;
    }
    
    TKRedioCategoryModel *model = self.headerView.categorieModels[indexPath.row];
    
    // 加载各个电台的详细数据
    TKRadioCategoryController *VC = [TKRadioCategoryController new];
    VC.type = LoadDataRadioCategories;
    VC.radioModel = model;
    [self.navigationController pushViewController:VC animated:YES];
}



- (void)moreBtnClick: (TKRadioTableCell *)cell {
    TKRadioCategoryController *vc = [[TKRadioCategoryController alloc]init];
    
    switch (cell.listModels.sortID) {
        case 1:
            vc.type = LoadDataRadioLocalMore;
            break;
        case 2:
            vc.type = LoadDataRadioHotMore;
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
