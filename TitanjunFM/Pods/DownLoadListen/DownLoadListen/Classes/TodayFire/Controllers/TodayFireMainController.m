//
//  TodayFireMainController.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TodayFireMainController.h"
#import "TKSegmentController.h"
#import "TodayFireVoiceTableController.h"
#import "TodayFireViewModel.h"



#define kBaseUrl @"http://mobile.ximalaya.com/"

@interface TodayFireMainController ()
@property (nonatomic, weak) TKSegmentController *segContentVC;

@property (nonatomic, strong) NSArray<CategoryModel *> *categoryMs;


@end

@implementation TodayFireMainController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    
    [self loadData];
}


#pragma mark - 私有方法
- (void)setUpUI {
    self.title = @"今日最火";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.segContentVC.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:self.segContentVC.view];
    
}

- (void)loadData {
    // 发送网络请求
    __weak typeof(self) weakSelf = self;
    [[TodayFireViewModel shareInstance] getTodayFireCategoryModels:^(NSArray<CategoryModel *> *categoryArr) {
        weakSelf.categoryMs = categoryArr;
    }];
}


#pragma mark - 懒加载,联动方法
- (TKSegmentController *)segContentVC {
    if (!_segContentVC) {
        TKSegmentController *contentVC = [[TKSegmentController alloc] init];
        [contentVC.segmentBar updateWithConfig:^(TKSegmentConfig *config) {
            config.segmentBarBackColor = [UIColor brownColor];
        }];
        [self addChildViewController:contentVC];
        _segContentVC = contentVC;
    }
    return _segContentVC;
}

- (void)setCategoryMs:(NSArray<CategoryModel *> *)categoryMs {
    _categoryMs = categoryMs;
    
    NSInteger vcCount = _categoryMs.count;
    NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:vcCount];
    
    for (CategoryModel *model in _categoryMs) {
        TodayFireVoiceTableController *vc = [[TodayFireVoiceTableController alloc] init];
        vc.loadKey = model.key;
        [vcs addObject:vc];
    }
    
    [self.segContentVC setUpWithItems:[categoryMs valueForKeyPath:@"name"] childVCs:vcs];
}

@end
