//
//  TKSpecialColumnCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKSpecialColumnCell.h"
#import "TKGoodTableCell.h"

#define kCellMargin 10

@interface TKSpecialColumnCell()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation TKSpecialColumnCell
static NSString *const cellID = @"CellTypeList2";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.rowHeight = 80;
    self.tableView.scrollEnabled = NO;
}

-(void)setFrame:(CGRect)frame {
    frame.size.height -= kCellMargin;
    [super setFrame:frame];
}

- (void)setGroupM:(TKGroupModel *)groupM {
    _groupM = groupM;
    self.titleLabel.text = groupM.title;
    [self.tableView reloadData];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    TKSpecialColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle bundleForClass:self] loadNibNamed:@"TKSpecialColumnCell" owner:nil options:nil].firstObject;
    }
    return cell;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupM.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKGoodTableCell *cell = [TKGoodTableCell cellWithTableView:tableView];
    
    TKSpecialColumnModel *specialM = self.groupM.list[indexPath.row];
    if (![specialM isKindOfClass:[TKSpecialColumnModel class]]) {
        return nil;
    }
    
    cell.specialColumnM = specialM;
    
    return cell;
}
@end
