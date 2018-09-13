//
//  TKAudioDownLoader.h
//  PlayerManager
//
//  Created by quanjunt on 2018/9/4.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TKAudioDownLoaderDelegate <NSObject>

- (void)downLoading;

@end

@interface TKAudioDownLoader : NSObject

@property (nonatomic, weak) id<TKAudioDownLoaderDelegate> delegate;
/** 文件总大小 */
@property (nonatomic, assign) long long totalSize;
/** 文件已加载大小 */
@property (nonatomic, assign) long long loadedSize;
/** 当前加载大小 */
@property (nonatomic, assign) long long offset;
/**  */
@property (nonatomic, strong) NSString *mimeType;


- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset;


@end
