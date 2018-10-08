//
//  TKMineTableController.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/21.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKMineTableController.h"
#import "TKMineHeaderView.h"
#import "UIView+Layout.h"
#import "BaseConstant.h"

@interface TKMineTableController ()
@property (nonatomic, strong)NSArray <NSArray *> *titleArr;
@end

@implementation TKMineTableController

- (NSArray <NSArray *> *)titleArr {
    if (_titleArr == nil) {
        _titleArr = @[@[@"我的消息", @"我的订阅", @"赞过的"], @[@"已购声音", @"喜点余额"], @[@"喜马拉雅商城", @"我的商城订单", @"我的优惠券", @"游戏中心", @"智能硬件设备"]];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backColor;
    TKMineHeaderView *headerView = [TKMineHeaderView mineHeaderView];
    headerView.width = kScreenWidth;
    headerView.height = 300;
    self.tableView.tableHeaderView = headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    secView.backgroundColor = [UIColor clearColor];
    return secView;
}

@end
