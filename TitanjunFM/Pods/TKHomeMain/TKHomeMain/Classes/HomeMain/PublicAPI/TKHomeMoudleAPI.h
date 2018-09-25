//
//  TKHomeMoudleAPI.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKHomeMoudleAPI : NSObject


+ (instancetype)shareInstance;


/**
 获取首页控制器
 */
@property (nonatomic, weak, readonly) UIViewController *homeVC;

/**
 跳转到专辑详情的block
 */
@property (nonatomic, copy) void(^jumpAlbumDetailBlock)(NSInteger albumID, UINavigationController *currentNav);


/**
 弹出播放器界面的block
 */
@property (nonatomic, copy) void(^presentPlayerBlock)(NSInteger trackID);


@end
