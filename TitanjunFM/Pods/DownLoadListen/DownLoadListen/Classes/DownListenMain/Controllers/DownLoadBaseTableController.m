//
//  DownLoadBaseTableController.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownLoadBaseTableController.h"
#import "TodayFireMainController.h"
#import "NoDataLoadView.h"

@interface DownLoadBaseTableController ()

@property (nonatomic, strong) NSArray *dataSources;
@property (nonatomic, weak) NoDataLoadView *noDataLoadView;
@property (nonatomic, copy) GetCellBlock cellBlock;
@property (nonatomic, copy) GetHeightBlock heightBlock;
@property (nonatomic, copy) BindBlock bindBlock;

@end

@implementation DownLoadBaseTableController
#pragma mark - 懒加载
- (NoDataLoadView *)noDataLoadView {
    if (!_noDataLoadView) {
        NoDataLoadView *noLoadView = [NoDataLoadView noDownLoadView];
        [self.view addSubview:noLoadView];
        _noDataLoadView = noLoadView;
    }
    return _noDataLoadView;
}


#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.noDataLoadView.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.4);
    
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString *currentBundleName = currentBundle.infoDictionary[@"CFBundleName"];
    
    if ([self isKindOfClass:NSClassFromString(@"DownLoadingVoiceController")]) {
        NSString *noLoadingImgPath = [currentBundle pathForResource:@"noData_downloading@2x.png" ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle", currentBundleName]];
        self.noDataLoadView.noDataImg = [UIImage imageWithContentsOfFile:noLoadingImgPath];
    } else {
        NSString *noLoadedImgPath = [currentBundle pathForResource:@"noData_download.png" ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle", currentBundleName]];
        self.noDataLoadView.noDataImg = [UIImage imageWithContentsOfFile:noLoadedImgPath];
    }
    
    [self.noDataLoadView setClickBlock:^{
        TodayFireMainController *fireVC = [[TodayFireMainController alloc]init];
        [self.navigationController pushViewController:fireVC animated:YES];
    }];
    
    // 监听重新加载数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCache) name:@"reloadCache" object:nil];
}

- (void)reloadCache {
    NSLog(@"等待被重写");
}


#pragma mark - 对外接口
- (void)setDataSouce:(NSArray *)dataSource getCell:(GetCellBlock)cellBlock cellHeight:(GetHeightBlock)cellHeightBlock bind:(BindBlock)bindBlock {
    self.dataSources = dataSource;
    self.cellBlock = cellBlock;
    self.heightBlock = cellHeightBlock;
    self.bindBlock = bindBlock;
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.noDataLoadView.hidden = self.dataSources.count != 0;
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = self.cellBlock(tableView, indexPath);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSources[indexPath.row];
    self.bindBlock(cell, model);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSources[indexPath.row];
    if (self.heightBlock) {
        return  self.heightBlock(model);
    }
    return 44;
}

@end
