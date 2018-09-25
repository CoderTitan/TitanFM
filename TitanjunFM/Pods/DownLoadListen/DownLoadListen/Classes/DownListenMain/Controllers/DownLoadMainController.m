//
//  DownLoadMainController.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "DownLoadMainController.h"
#import "TKSegmentBar.h"
#import "TKDeviceMessage.h"
#import "TKCacheTool.h"
#import "BaseConstant.h"
#import "UIView+Layout.h"
#import "DownLoadAlbumController.h"
#import "DownLoadVoiceController.h"
#import "DownLoadingVoiceController.h"

@interface DownLoadMainController ()<UIScrollViewDelegate, TKSegmentBarDelegate>
@property (nonatomic, strong) TKSegmentBar *segmentBar;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UILabel *noticeLabel;
@end

@implementation DownLoadMainController

- (TKSegmentBar *)segmentBar {
    if (!_segmentBar) {
        _segmentBar = [TKSegmentBar segmentBarWithConfig:[TKSegmentConfig defaultConfig]];
        _segmentBar.delegate = self;
    }
    return _segmentBar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpInit];
    

    self.navigationItem.titleView = self.segmentBar;
    self.segmentBar.segmentModels = @[@"专辑", @"声音", @"下载中"];
    self.segmentBar.selectIndex = 0;


    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg_64"] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkMemory];
}

- (void)checkMemory {
    // 剩余空间
    NSString *freeSpace = [TKDeviceMessage freeDiskSpaceInBytes];
    // 已用空间
    // kDownLoadPath
    NSString *useSpace = [TKCacheTool getSizeWithPath:NSHomeDirectory()];
    self.noticeLabel.text = [NSString stringWithFormat:@"已占用空间%@, 可用空间%@", useSpace, freeSpace];
}


- (void)setUpInit {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 0. 添加子控制器
    [self addChildViewControllers];
    
    // 1. 添加占用内存横幅
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavigationBarMaxY, kScreenWidth, 20)];
    self.noticeLabel = noticeLabel;
    noticeLabel.backgroundColor = [UIColor grayColor];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.font = [UIFont systemFontOfSize:12];
    noticeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:noticeLabel];
    
    // 2. 添加内容视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarMaxY + 20, kScreenWidth, kScreenHeight - (kNavigationBarMaxY + 20 + kTabbarHeight))];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    self.contentScrollView = scrollView;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width * self.childViewControllers.count, 0);
    [self.view addSubview:scrollView];
}

- (void)addChildViewControllers {
    // 如果设置view的backgroundColor会提前出发viewDidLoad方法
    DownLoadAlbumController *vc1 = [[DownLoadAlbumController alloc] init];
    [self addChildViewController:vc1];
    DownLoadVoiceController *vc2 = [[DownLoadVoiceController alloc] init];
    [self addChildViewController:vc2];
    DownLoadingVoiceController *vc3 = [[DownLoadingVoiceController alloc] init];
    [self addChildViewController:vc3];
}

-(void)dealloc {
    // 移除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 代理
- (void)segmentBarDidSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex {
    [self showControllerView:toIndex];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.width;
    self.segmentBar.selectIndex = page;
}

- (void)showControllerView:(NSInteger)index {
    UIView *view = self.childViewControllers[index].view;
    CGFloat contentViewW = self.contentScrollView.frame.size.width;
    view.frame = CGRectMake(contentViewW * index, 0, contentViewW, self.contentScrollView.frame.size.height);
    [self.contentScrollView addSubview:view];
    [self.contentScrollView setContentOffset:CGPointMake(contentViewW * index, 0) animated:YES];
}
@end
