//
//  TKRadioCategoryView.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKRadioCategoryView.h"
#import "TKRedioCategoryCell.h"
#import "TKRadioBroadcaseController.h"
#import "TKRadioCategoryController.h"
#import "UIView+Layout.h"
#import "UIView+TKNib.h"


@interface TKRadioCategoryView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
@implementation TKRadioCategoryView
-(void)setFrame:(CGRect)frame {
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setCategorieModels:(NSMutableArray<TKRedioCategoryModel *> *)categorieModels {
    _categorieModels = categorieModels;
    [self.collectionView reloadData];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TKRedioCategoryCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:@"CategoriesCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 事件监听
// 本地台
- (IBAction)localRadio:(UIButton *)sender {
    [self radioWithType:LoadDataRadioLocalMore WithButton:sender];
}

//国家台
- (IBAction)nationalAction:(UIButton *)sender {
    [self radioWithType:LoadDataRadioNational WithButton:sender];
}

//省市台
- (IBAction)prianceAction:(UIButton *)sender {
    [self radioWithType:LoadDataRadioProvince WithButton:sender];
}

// 网络台
- (IBAction)networkAction:(UIButton *)sender {
    [self radioWithType:LoadDataRadioNetwork WithButton:sender];
}

- (void)radioWithType:(LoadDataType)type WithButton:(UIButton *)sender {
    TKRadioBroadcaseController *VC = (TKRadioBroadcaseController *)[sender currentViewController];
    TKRadioCategoryController *radioCategoryVC = [TKRadioCategoryController new];
    radioCategoryVC.navTitle = sender.currentTitle;
    radioCategoryVC.type = type;
    
    [VC.navigationController pushViewController:radioCategoryVC animated:YES];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categorieModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKRedioCategoryModel *model = self.categorieModels[indexPath.row];
    TKRedioCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoriesCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:0.5];
    
    if (self.categorieModels.count <= 8) {
        [cell down];
    }else{
        [cell up];
    }
    
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){self.collectionView.width / 4 - 1 ,30};
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TKRedioCategoryCell *cell = (TKRedioCategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    self.selectorItemBlock(cell, indexPath);
}

@end
