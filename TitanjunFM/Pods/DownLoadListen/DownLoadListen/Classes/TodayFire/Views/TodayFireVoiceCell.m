//
//  TodayFireVoiceCell.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TodayFireVoiceCell.h"
#import "UIButton+WebCache.h"

@interface TodayFireVoiceCell ()

@end
@implementation TodayFireVoiceCell
static NSString *const cellID = @"todayFireVoice";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    TodayFireVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:self] loadNibNamed:@"TodayFireVoiceCell" owner:nil options:nil] firstObject];
        [cell addObserver:cell forKeyPath:@"sortNumLabel.text" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return cell;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"sortNumLabel.text"]) {
        NSInteger sort = [change[NSKeyValueChangeNewKey] integerValue];
        if (sort == 1) {
            self.sortNumLabel.textColor = [UIColor redColor];
        }else if (sort == 2) {
            self.sortNumLabel.textColor = [UIColor orangeColor];
        }else if (sort == 3) {
            self.sortNumLabel.textColor = [UIColor greenColor];
        }else {
            self.sortNumLabel.textColor = [UIColor grayColor];
        }
        return;
    }
}


#pragma mark - 重写set方法
- (void)setState:(TodayFireVoiceCellState)state {
    _state = state;
    
    NSBundle *currentnBundle = [NSBundle bundleForClass:[self class]];
    NSDictionary *bundleInfoDic = currentnBundle.infoDictionary;
    NSString *bundleName = bundleInfoDic[@"CFBundleName"];
    
    if (state == TodayFireVoiceCellStateWaitDownLoad) {
        [self removeRotationAnimation];
        NSString *downloadedPath = [currentnBundle pathForResource:@"cell_download.png" ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle", bundleName]];
        [self.downLoadBtn setImage:[UIImage imageWithContentsOfFile:downloadedPath] forState:UIControlStateNormal];
    } else if (state == TodayFireVoiceCellStateDownLoading) {
        NSString *downloadedingPath = [currentnBundle pathForResource:@"cell_download_loading@2x.png" ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle", bundleName]];
        [self.downLoadBtn setImage:[UIImage imageWithContentsOfFile:downloadedingPath] forState:UIControlStateNormal];
        [self addRotationAnimation];
    } else if (state == TodayFireVoiceCellStateDownLoaded) {
        [self removeRotationAnimation];
        NSString *downloadededPath = [currentnBundle pathForResource:@"cell_downloaded@2x.png" ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle", bundleName]];
        [self.downLoadBtn setImage:[UIImage imageWithContentsOfFile:downloadededPath] forState:UIControlStateNormal];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.playOrPauseBtn.layer.masksToBounds = YES;
    self.playOrPauseBtn.layer.borderWidth = 3;
    self.playOrPauseBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.playOrPauseBtn.layer.cornerRadius = 20;
}


#pragma mark - 私有方法
- (void)addRotationAnimation {
    [self removeRotationAnimation];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2.0);
    animation.duration = 10;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    [self.downLoadBtn.imageView.layer addAnimation:animation forKey:@"rotation"];
}

- (void)removeRotationAnimation {
    [self.downLoadBtn.imageView.layer removeAllAnimations];
}


#pragma mark - Button事件监听
- (IBAction)playOrPauseVoiceAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (self.playBlock) {
        self.playBlock(sender.selected);
    }
}
- (IBAction)todayVoiceDownload:(id)sender {
    if (self.state == TodayFireVoiceCellStateWaitDownLoad) {
        if (self.downLoadBlock) {
            self.downLoadBlock();
        }
    }
}

@end
