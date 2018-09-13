//
//  AlbumModel.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject

/**
 专辑ID
 */
@property (nonatomic, assign) NSInteger albumId;

/**
 专辑名称
 */
@property (nonatomic, copy) NSString *albumTitle;

/**
 评论个数
 */
@property (nonatomic, assign) NSInteger commentsCounts;
/**
 专辑图片
 */
@property (nonatomic, copy) NSString *albumCoverMiddle;

/** 声音个数 */
@property (nonatomic, assign) NSInteger voiceCount;

/** 作者 */
@property (nonatomic, copy) NSString *authorName;

/** 总大小 */
@property (nonatomic, assign) long long allVoiceSize;



@end
