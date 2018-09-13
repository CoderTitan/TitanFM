//
//  DownloadAlbumCellModel.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AlbumModel;
@class DownloadAlbumCell;


@interface DownloadAlbumCellModel : NSObject

@property (nonatomic, strong) AlbumModel *albumModel;

- (void)bindWithCell: (DownloadAlbumCell *)cell;

@end
