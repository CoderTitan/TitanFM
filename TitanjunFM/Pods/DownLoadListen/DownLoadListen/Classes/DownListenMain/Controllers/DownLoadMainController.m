//
//  DownLoadMainController.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownLoadMainController.h"
#import "TKSegmentController.h"
#import "DownLoadAlbumController.h"
#import "DownLoadVoiceController.h"
#import "DownLoadingVoiceController.h"

@interface DownLoadMainController ()
@property (nonatomic, weak) TKSegmentController *segmentBarVC;

@end

@implementation DownLoadMainController

- (TKSegmentController *)segmentBarVC {
    if (!_segmentBarVC) {
        TKSegmentController *segmentBarVC = [[TKSegmentController alloc] init];
        _segmentBarVC = segmentBarVC;
        [self addChildViewController:segmentBarVC];
    }
    return _segmentBarVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", NSHomeDirectory());
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.segmentBarVC.segmentBar.frame = CGRectMake(0, 0, 300, 40);
    self.navigationItem.titleView = self.segmentBarVC.segmentBar;
    
    self.segmentBarVC.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60);
    [self.view addSubview:self.segmentBarVC.view];
    
    DownLoadAlbumController *vc1 = [[DownLoadAlbumController alloc] init];
    DownLoadVoiceController *vc2 = [[DownLoadVoiceController alloc] init];
    DownLoadingVoiceController *vc3 = [[DownLoadingVoiceController alloc] init];
    
    [self.segmentBarVC setUpWithItems:@[@"专辑", @"声音", @"下载中"] childVCs:@[vc1, vc2, vc3]];
    
    [self.segmentBarVC.segmentBar updateWithConfig:^(TKSegmentConfig *config) {
        config.segmentBarBackColor = [UIColor clearColor];
    }];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg_64"] forBarMetrics:UIBarMetricsDefault];
}


@end
