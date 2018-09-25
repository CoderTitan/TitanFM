//
//  TKHomeMoudleController.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKHomeMoudleController : UIViewController

/// 选项卡选中的索引
@property (nonatomic, assign) NSInteger segSelectIndex;
/// segBar的位置
@property (nonatomic, assign) CGRect segBarFrame;

/// 是否让setBar显示更多
@property (nonatomic, assign) BOOL isShowMore;

/// 内容视图的位置大小
@property (nonatomic, assign) CGRect contentScrollViewFrame;

/* 设置选项卡模型和子控制器 */
- (void)setUpWithSegModels:(NSArray *)segArr andChildVCs:(NSArray *)subVCs;


@end
