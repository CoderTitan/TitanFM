//
//  DownloadAlbumCell.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadAlbumCell : UITableViewCell
/** 专辑图片 */
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
/** 专辑标题 */
@property (weak, nonatomic) IBOutlet UILabel *albumTitleLabel;
/** 专辑作者 */
@property (weak, nonatomic) IBOutlet UILabel *albumAuthorLabel;
/** 专辑集数 */
@property (weak, nonatomic) IBOutlet UIButton *albumPartsBtn;
/** 专辑大小 */
@property (weak, nonatomic) IBOutlet UIButton *albumPartsSizeBtn;


/** 删除按钮点击执行代码块 */
@property (nonatomic, strong) void(^deleteBlock)(void);

/** 选中执行代码块 */
@property (nonatomic, strong) void(^selectBlock)(void);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
