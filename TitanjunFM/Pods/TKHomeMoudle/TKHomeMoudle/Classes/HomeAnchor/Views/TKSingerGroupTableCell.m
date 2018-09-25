//
//  TKSingerGroupTableCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKSingerGroupTableCell.h"
#import "TKSingerTableCell.h"

static NSString *const cellID = @"singerGroup";
@interface TKSingerGroupTableCell()<UITableViewDataSource, UITableViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation TKSingerGroupTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    TKSingerGroupTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSBundle *currbundle = [NSBundle bundleForClass:[self class]];
        cell = [currbundle loadNibNamed:@"TKSingerGroupTableCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

- (void)setAnchorGroupM:(TKAnchorGroupModel *)anchorGroupM {
    _anchorGroupM = anchorGroupM;
    self.titleLabel.text = anchorGroupM.title;
    [self.tableView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    NSBundle *currBundle = [NSBundle bundleForClass:[TKSingerTableCell class]];
    UINib *nib = [UINib nibWithNibName:@"TKSingerTableCell" bundle:currBundle];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"singerCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10;
    [super setFrame:frame];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.anchorGroupM.anchorMs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKSingerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singerCell"];
    
    TKAnchorModel *anchorM = self.anchorGroupM.anchorMs[indexPath.row];
    cell.anchorM = anchorM;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
@end
