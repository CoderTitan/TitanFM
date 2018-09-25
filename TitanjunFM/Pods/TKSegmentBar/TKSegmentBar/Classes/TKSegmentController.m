//
//  TKSegmentController.m
//  TKSegmentBar_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import "TKSegmentController.h"
#import "UIView+SegLayout.h"
#import "TKSegmentMenueCell.h"



#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kRowCount 3
#define kMargin 6
#define kCellH 30

@interface TKSegmentController ()


@end

@implementation TKSegmentController
static NSString * const reuseIdentifier = @"menue";

#pragma 懒加载
- (void)setItems:(NSArray<id<TKSegmentModelProtocol>> *)items {
    _items = items;
    
    NSInteger rows = (_items.count + (kRowCount - 1)) / kRowCount;
    CGFloat height = rows * (kCellH + kMargin);
    self.collectionView.height = height;
    self.expectedHeight = height;
    [self.collectionView reloadData];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (kScreenWidth - kMargin * (kRowCount + 1)) / kRowCount;
    CGFloat height = kCellH;
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.minimumLineSpacing = kMargin;
    flowLayout.minimumInteritemSpacing = kMargin;
    
    return [super initWithCollectionViewLayout:flowLayout];
}

- (instancetype)init {
    return [self initWithCollectionViewLayout:[UICollectionViewLayout new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSBundle *currBundle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:@"TKSegmentMenueCell" bundle:currBundle];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKSegmentMenueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.menueLabel.text = (NSString *)self.items[indexPath.row];
    
    return cell;
}
@end
