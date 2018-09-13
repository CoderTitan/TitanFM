//
//  DownloadListenTool.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AlbumModel;
@class DownloadVoiceModel;
@interface DownloadListenTool : NSObject

/** 获取正在下载的数据集合 */
+ (NSArray <DownloadVoiceModel *> *)getDownLoadingVoiceModels;
/** 获取已下载的数据集合 */
+ (NSArray <DownloadVoiceModel *> *)getDownLoadedVoiceModels;
/** 获取专辑集合中已下载的数据 */
+ (NSArray <DownloadVoiceModel *> *)getDownLoadedVoiceModelsInAlbumID: (NSInteger)albumID;
/** 获取已下载的专辑数据集合 */
+ (NSArray <AlbumModel *> *)getDownLoadedAlbums;

@end
