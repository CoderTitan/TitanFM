//
//  DownloadAlbumCell.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownloadAlbumCell.h"

@implementation DownloadAlbumCell
static NSString *const cellID = @"downLoadAlbum";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    DownloadAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:self] loadNibNamed:@"DownloadAlbumCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        if (self.selectBlock) {
            self.selectBlock();
        }
    }
}


- (IBAction)removeModel:(id)sender {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

@end
