//
//  TKCategoryCell.m
//  All
//
//  Created by 田全军 on 2018/9/17.
//  Copyright © 2018年 田全军. All rights reserved.
//

#import "TKCategoryCell.h"
#import "TKCellButton.h"
#import "TKClassItemModel.h"
#import "UIButton+WebCache.h"
#import "UIImage+Image.h"


@interface TKCategoryCell()
@property (weak, nonatomic) IBOutlet TKCellButton *leftButton;
@property (weak, nonatomic) IBOutlet TKCellButton *rightButton;

@end
@implementation TKCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModelArr:(NSArray *)modelArr {
    _modelArr = modelArr;
    TKClassItemModel *leftModel = self.modelArr[0];
    TKClassItemModel *rightModel = self.modelArr[1];
    
    [self.leftButton setTitle:leftModel.title forState:UIControlStateNormal];
    [self.leftButton sd_setImageWithURL:[NSURL URLWithString:leftModel.coverPath] forState:UIControlStateNormal placeholderImage:[UIImage bundleImageWithClass:[self class] Name:@"findCategory_default@3x.png"]];

    [self.rightButton setTitle:rightModel.title forState:UIControlStateNormal];
    [self.rightButton sd_setImageWithURL:[NSURL URLWithString:rightModel.coverPath] forState:UIControlStateNormal placeholderImage:[UIImage bundleImageWithClass:[self class] Name:@"findCategory_default@3x.png"]];
}

@end
