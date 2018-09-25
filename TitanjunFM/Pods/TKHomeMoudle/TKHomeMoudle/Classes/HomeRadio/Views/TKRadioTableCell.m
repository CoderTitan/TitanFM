//
//  TKRadioTableCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRadioTableCell.h"
#import "TKRadioInfoCell.h"

#define kCellMargin 10
@interface TKRadioTableCell () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation TKRadioTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.scrollEnabled =NO;
}

-(void)setFrame:(CGRect)frame
{
    frame.size.height -= kCellMargin;
    [super setFrame:frame];
}

// 更多按钮点击
- (IBAction)more:(UIButton *)sender {
    self.moreBlock(self);
}

- (void)setListModels:(TKRadioArrModel *)listModels {
    _listModels = listModels;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.titleLabel.text = listModels.location;
    [self.tableView reloadData];
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModels.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKRedioModel *model = self.listModels.modelArr[indexPath.row];
    
    TKRadioInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    
    if (!cell) {
        cell = [[NSBundle bundleForClass:[TKRadioInfoCell class]] loadNibNamed:@"TKRadioInfoCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}
@end
