//
//  TKMineHeaderView.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/21.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKMineHeaderView : UIView

/**
 *  从xib中创建一个nib视图
 */
+ (instancetype)mineHeaderView;

//节目管理
@property (nonatomic, copy) void(^programClickTask)(void);

//录音
@property (nonatomic, copy) void(^recordClickTask)(void);

//设置点击
@property (nonatomic, copy) void(^settingClickTask)(void);


@end

NS_ASSUME_NONNULL_END
