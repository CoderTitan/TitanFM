//
//  DownloadVoiceCell.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/6.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownloadVoiceCell.h"

@implementation DownloadVoiceCell
static NSString *const cellID = @"downLoadVoice";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    DownloadVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:self] loadNibNamed:@"DownloadVoiceCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.playOrPauseBtn.layer.cornerRadius = 20;
    self.playOrPauseBtn.layer.masksToBounds = YES;
    self.playOrPauseBtn.layer.borderWidth = 3;
    self.playOrPauseBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        if (self.selectBlock) {
            self.selectBlock();
        }
    }
}

- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.playBlock) {
        self.playBlock(sender.selected);
    }
    
}

- (IBAction)downLoadOrPause:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (self.downLoadBlock) {
        self.downLoadBlock(sender.selected);
    }
    
}
- (IBAction)deleteFile {
    
    if (self.deleteBlock) {
        self.deleteBlock();
    }
    
}

@end
