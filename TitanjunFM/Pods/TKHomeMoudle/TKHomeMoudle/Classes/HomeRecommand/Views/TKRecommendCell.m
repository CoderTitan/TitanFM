//
//  TKRecommendCell.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRecommendCell.h"
#import "TKItemCollectionCell.h"
#import "TKRecommendController.h"
#import "TKRecommendMoreController.h"
#import "BaseConstant.h"
#import "TKHomeRecommandDefine.h"
#import "UIView+TKNib.h"


#define kCellCountInRow 3
#define kCellMargin 10

@interface TKRecommendCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation TKRecommendCell
static NSString *const itemID = @"itemID";
static NSString *const cellID = @"CellTypeList3";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat width = (kScreenWidth - (kCellCountInRow + 1) * kCellMargin) / kCellCountInRow;
    CGFloat height = width * 1.6;
    self.flowLayout.itemSize = CGSizeMake(width, height);
    self.flowLayout.minimumInteritemSpacing = kCellMargin - 0.1;
    self.flowLayout.minimumLineSpacing = kCellMargin;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, kCellMargin, 0, kCellMargin);
    
    UINib *nib = [UINib nibWithNibName:@"TKItemCollectionCell" bundle:[NSBundle bundleForClass:[self class]]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:itemID];
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - set/对外方法
-(void)setFrame:(CGRect)frame {
    frame.size.height -= kCellMargin;
    [super setFrame:frame];
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated { }

- (void)setGroupM:(TKGroupModel *)groupM {
    _groupM = groupM;
    self.titleLabel.text = groupM.title;
    
    [self.collectionView reloadData];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    TKRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:self] loadNibNamed:@"TKRecommendCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

#pragma mark - 事件监听
- (IBAction)moreAction:(UIButton *)sender {
    TKRecommendController *vc = (TKRecommendController *)[sender currentViewController];
    
    // 此处暂时写死,因为接口暂无数据判断
    if ([self.groupM.title isEqualToString:@"小编推荐"]) {
        TKRecommendMoreController *moreVC = [TKRecommendMoreController new];
        moreVC.navTitle = self.groupM.title;
        [vc.navigationController pushViewController:moreVC animated:YES];
    }
}

#pragma collectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groupM.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
    
    TKItemCellModel *model = self.groupM.list[indexPath.row];
    cell.itemCellModel = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TKItemCollectionCell *cell = (TKItemCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSString *priceTypeId = cell.itemCellModel.priceTypeId;
    
    // 跳转专辑详情页
    if ([priceTypeId isEqualToString:@"0"] || [priceTypeId isEqualToString:@"1"]) {
        TKRecommendController *vc = (TKRecommendController *)[cell currentViewController];
        UIViewController *nav = vc.navigationController;
        NSString *albumID = cell.itemCellModel.albumId;
        kJumpToAlbumDetail(albumID, nav)
    }
}
@end
