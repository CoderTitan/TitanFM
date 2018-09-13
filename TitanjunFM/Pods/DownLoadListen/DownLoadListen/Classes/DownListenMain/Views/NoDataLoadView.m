//
//  NoDataLoadView.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "NoDataLoadView.h"


@interface NoDataLoadView()

@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;

@property (weak, nonatomic) IBOutlet UIButton *lookBtn;


@end

@implementation NoDataLoadView

+ (instancetype)noDownLoadView {
    
    NSBundle *currentBundle = [NSBundle bundleForClass:self];
    NoDataLoadView *noDataView = [[currentBundle loadNibNamed:@"NoDataLoadView" owner:nil options:nil] firstObject];
    return noDataView;
}

- (void)setNoDataImg:(UIImage *)noDataImg {
    _noDataImg = noDataImg;
    self.noDataImageView.image = noDataImg;
}


-(void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}




- (IBAction)gotoViewAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
