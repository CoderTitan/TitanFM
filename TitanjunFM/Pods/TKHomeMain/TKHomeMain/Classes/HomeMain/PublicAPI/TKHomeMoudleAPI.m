//
//  TKHomeMoudleAPI.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKHomeMoudleAPI.h"
#import "TKHomeMoudleController.h"
#import "TKHomeRecommandAPI.h"


@implementation TKHomeMoudleAPI
static TKHomeMoudleAPI *_shareInstance;

+ (instancetype)shareInstance {
    if (_shareInstance == nil) {
        _shareInstance = [[TKHomeMoudleAPI alloc] init];
    }
    return _shareInstance;
}


/**
 获取首页控制器
 */
- (UIViewController *)homeVC {
    return [[TKHomeMoudleController alloc]init];
}

/**
 跳转到专辑详情的block
 */
- (void)setJumpAlbumDetailBlock:(void (^)(NSInteger, UINavigationController *))jumpAlbumDetailBlock {
    [TKHomeRecommandAPI shareInstance].jumpAlbumDetailBlock = jumpAlbumDetailBlock;
}


/**
 弹出播放器界面的block
 */
- (void)setPresentPlayerBlock:(void (^)(NSInteger))presentPlayerBlock {
    [TKHomeRecommandAPI shareInstance].presentPlayerBlock = presentPlayerBlock;
}


@end
