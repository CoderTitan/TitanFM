//
//  TKHomeRecommandAPI.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKHomeRecommandAPI : NSObject

+ (instancetype)shareInstance;



/**
 获取当前的推荐控制器
 */
@property (nonatomic, weak, readonly) UIViewController *recommendVC;


/**
 跳转到专辑详情的block
 */
@property (nonatomic, copy) void(^jumpAlbumDetailBlock)(NSInteger albumID, UINavigationController *currentNav);


/**
 弹出播放器界面的block
 */
@property (nonatomic, copy) void(^presentPlayerBlock)(NSInteger trackID);



@end

NS_ASSUME_NONNULL_END
