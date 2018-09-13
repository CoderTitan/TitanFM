//
//  DownloadListenTool.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownloadListenTool.h"
#import "TitanModelSqliteTool.h"
#import "DownloadVoiceModel.h"
#import "AlbumModel.h"

@implementation DownloadListenTool

/** 获取正在下载的数据集合 */
+ (NSArray <DownloadVoiceModel *> *)getDownLoadingVoiceModels {
    return [TitanModelSqliteTool queryModels:[DownloadVoiceModel class] key:@"isDownLoaded" relation:ColumnNameToValueRelationTypeEqual value:@(NO) uid:nil];
}

/** 获取已下载的数据集合 */
+ (NSArray <DownloadVoiceModel *> *)getDownLoadedVoiceModels {
    return [TitanModelSqliteTool queryModels:[DownloadVoiceModel class] key:@"isDownLoaded" relation:ColumnNameToValueRelationTypeEqual value:@(YES) uid:nil];
}

/** 获取专辑集合中已下载的数据 */
+ (NSArray <DownloadVoiceModel *> *)getDownLoadedVoiceModelsInAlbumID: (NSInteger)albumID {
    return [TitanModelSqliteTool queryModels:[DownloadVoiceModel class] keys:@[@"isDownLoaded", @"albumID"] relations:@[@(ColumnNameToValueRelationTypeEqual), @(ColumnNameToValueRelationTypeEqual)] values:@[@"1", @(albumID)] nao:@[@(SqliteModelToolNAOAnd)] uid:nil];
}

/** 获取已下载的专辑数据集合 */
+ (NSArray <AlbumModel *> *)getDownLoadedAlbums {
    return [TitanModelSqliteTool queryModels:[AlbumModel class] withSql:@"select albumId, albumTitle, commentsCounts, coverSmall as albumCoverMiddle,nickName as authorName, count(*) as voiceCount, sum(totalSize) as allVoiceSize from DownloadVoiceModel where isDownLoaded = '1' group by albumId" uid:nil];
}

@end
