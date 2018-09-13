//
//  DownLoadBaseTableController.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UITableViewCell *(^GetCellBlock)(UITableView *tableView, NSIndexPath *indexPath);
typedef CGFloat (^GetHeightBlock)(id model);
typedef void (^BindBlock)(UITableViewCell *cell, id model);

@interface DownLoadBaseTableController : UITableViewController

- (void)setDataSouce: (NSArray *)dataSource getCell: (GetCellBlock)cellBlock cellHeight: (GetHeightBlock)cellHeightBlock bind: (BindBlock)bindBlock;
@end
