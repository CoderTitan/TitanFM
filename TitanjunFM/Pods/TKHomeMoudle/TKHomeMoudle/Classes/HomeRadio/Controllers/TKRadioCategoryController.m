//
//  TKRadioCategoryController.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRadioCategoryController.h"
#import "TKRadioBroadcaseViewModel.h"
#import "TKRedioModel.h"
#import "TKRadioInfoCell.h"


@interface TKRadioCategoryController ()

@property (nonatomic, strong)NSMutableArray<TKRedioModel *> *categorieMs;

@end

@implementation TKRadioCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self loadData];
}

- (void)initViews {
    self.navigationItem.title = self.radioModel ? self.radioModel.name : self.navTitle;
    self.tableView.rowHeight = 88.0;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TKRadioInfoCell" bundle:[NSBundle bundleForClass:[TKRadioInfoCell class]]] forCellReuseIdentifier:@"InfoCell"];
}

- (void)loadData {
    switch (self.type) {
        case LoadDataRadioCategories:{
            //各个电台的详细数据
            [[TKRadioBroadcaseViewModel shareInstance] getRadioCategoriesListWithId:self.radioModel.id resultBlock:^(NSMutableArray<TKRedioModel *> * _Nonnull radioMs, NSError * _Nonnull error) {
                self.categorieMs = radioMs;
                [self.tableView reloadData];
            }];
        }
            break;
        case LoadDataRadioLocalMore:{
            // 当地更多列表
            [[TKRadioBroadcaseViewModel shareInstance] getRadioLocalMore:^(NSMutableArray<TKRedioModel *> *radioMs, NSError * _Nonnull error) {
                self.categorieMs = radioMs;
                [self.tableView reloadData];
            }];
        }
            break;
            
        case LoadDataRadioHotMore:{
            // 排行榜更多列表
            [[TKRadioBroadcaseViewModel shareInstance] getRadioHotMore:^(NSMutableArray<TKRedioModel *> * _Nonnull radioMs, NSError * _Nonnull error) {
                self.categorieMs = radioMs;
                [self.tableView reloadData];
            }];
        }
            break;
            
        case LoadDataRadioProvince:{
            // 本地台列表
            [[TKRadioBroadcaseViewModel shareInstance] getRadioProvince:^(NSMutableArray<TKRedioModel *> * _Nonnull radioMs, NSError * _Nonnull error) {
                self.categorieMs = radioMs;
                [self.tableView reloadData];
            }];
        }
            break;
            
        case LoadDataRadioNational:{
            //国家台列表
            [[TKRadioBroadcaseViewModel shareInstance] getRadioNational:^(NSMutableArray<TKRedioModel *> * _Nonnull radioMs, NSError * _Nonnull error) {
                self.categorieMs = radioMs;
                [self.tableView reloadData];
            }];
        }
            break;
            
        case LoadDataProvince:
            //省市台
            
            break;
            
        case LoadDataRadioNetwork:{
            //网络台
            [[TKRadioBroadcaseViewModel shareInstance] getRadioNetwork:^(NSMutableArray<TKRedioModel *> * _Nonnull radioMs, NSError * _Nonnull error) {
                self.categorieMs = radioMs;
                [self.tableView reloadData];
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categorieMs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKRedioModel *model = self.categorieMs[indexPath.row];
    TKRadioInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
