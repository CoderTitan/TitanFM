//
//  TKHomeRecommandDefine.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

// 1. 跳转到专辑详情的通知定义
#define kJumpToAlbumDetail(albumID,currentNav) \
[[NSNotificationCenter defaultCenter]  \
postNotificationName:@"HomeRecommendAPI_jumpToAbumDetail" \
object:@{ \
@"albumID": albumID, \
@"currentNav": currentNav \
}];


// 2. 跳转到播放器的通知定义
#define kPresentToPlayer(trackID) \
[[NSNotificationCenter defaultCenter]  \
postNotificationName:@"HomeRecommendAPI_presentPlayer" \
object:@{ \
@"trackID": trackID, \
}];
