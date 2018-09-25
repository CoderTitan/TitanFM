//
//  TKAnchorGroupCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKAnchorGroupCell.h"
#import "TKAnchorCell.h"


static NSString *const cellID = @"anchorGroup";

@interface TKAnchorGroupCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@implementation TKAnchorGroupCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    TKAnchorGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSBundle *currBundle = [NSBundle bundleForClass:[self class]];
        cell = [currBundle loadNibNamed:@"TKAnchorGroupCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

- (void)setAnchorGroupM:(TKAnchorGroupModel *)anchorGroupM {
    _anchorGroupM = anchorGroupM;
    self.titleLabel.text = anchorGroupM.title;
    [self.collectionView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSBundle *currBundle = [NSBundle bundleForClass:[TKAnchorCell class]];
    UINib *nib = [UINib nibWithNibName:@"TKAnchorCell" bundle:currBundle];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"anchorCell"];
    
    CGFloat margin = 20;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - margin * 4) / 3;
    self.flowLayout.itemSize = CGSizeMake(width, width * 1.4);
    self.flowLayout.minimumLineSpacing = margin;
    self.flowLayout.minimumInteritemSpacing = margin;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, margin, 0, margin);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10;
    [super setFrame:frame];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.anchorGroupM.anchorMs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKAnchorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"anchorCell" forIndexPath:indexPath];
    
    TKAnchorModel *anchorM = self.anchorGroupM.anchorMs[indexPath.row];
    
    cell.anchorM = anchorM;
    
    return cell;
}
@end
