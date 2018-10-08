//
//  TKMineHeaderView.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/21.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKMineHeaderView.h"

@interface TKMineHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation TKMineHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius = 40;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderWidth = 3;
    self.iconImageView.layer.borderColor = [UIColor grayColor].CGColor;
}

+ (instancetype)mineHeaderView {
    return [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"TKMineHeaderView" owner:nil options:nil] firstObject];
}


//节目管理
- (IBAction)programMangeClick:(id)sender {
    if (self.programClickTask) {
        self.programClickTask();
    }
}

- (IBAction)settingClick:(id)sender {
    if (self.settingClickTask) {
        self.settingClickTask();
    }
}

//录音
- (IBAction)recordClick:(id)sender {
    if (self.recordClickTask) {
        self.recordClickTask();
    }
}



@end
