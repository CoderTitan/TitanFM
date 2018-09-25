//
//  TodayFireMainController.m
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TodayFireMainController.h"
#import "TKSegmentBar.h"
#import "BaseConstant.h"
#import "UIView+Layout.h"
#import "TodayFireVoiceTableController.h"
#import "TodayFireViewModel.h"



#define kBaseUrl @"http://mobile.ximalaya.com/"

@interface TodayFireMainController ()<UIScrollViewDelegate, TKSegmentBarDelegate>
@property (nonatomic, strong) TKSegmentBar *segmentBar;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray<CategoryModel *> *categoryMs;


@end

@implementation TodayFireMainController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self setUpUI];
}


#pragma mark - 私有方法
- (void)setUpUI {
    self.title = @"今日最火";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 2. 添加内容视图
    [self.view addSubview:self.contentScrollView];
    
    // 1. 设置菜单栏
    [self.view addSubview:self.segmentBar];
    
}

- (void)loadData {
    // 发送网络请求
    __weak typeof(self) weakSelf = self;
    [[TodayFireViewModel shareInstance] getTodayFireCategoryModels:^(NSArray<CategoryModel *> *categoryArr) {
        weakSelf.categoryMs = categoryArr;
    }];
}


#pragma mark - 懒加载,联动方法
-(TKSegmentBar *)segmentBar {
    if (!_segmentBar) {
        TKSegmentConfig *config = [TKSegmentConfig defaultConfig];
        config.isShowMore = YES;
        _segmentBar = [TKSegmentBar segmentBarWithConfig:config];
        _segmentBar.y = kNavigationBarMaxY;
        _segmentBar.backgroundColor = [UIColor whiteColor];
        _segmentBar.delegate = self;
    }
    return _segmentBar;
}

-(UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarMaxY + self.segmentBar.height, kScreenWidth, kScreenHeight - (kNavigationBarMaxY + self.segmentBar.height))];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(scrollView.width * self.childViewControllers.count, 0);
        _contentScrollView = scrollView;
    }
    return _contentScrollView;
}


- (void)setCategoryMs:(NSArray<CategoryModel *> *)categoryMs {
    _categoryMs = categoryMs;
    
    [self setUpWithItems:[categoryMs valueForKeyPath:@"name"]];
}

- (void)setUpWithItems: (NSArray <NSString *>*)items {
    // 0.添加子控制器
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    for (int i = 0; i < items.count; i++) {
        TodayFireVoiceTableController *vc = [[TodayFireVoiceTableController alloc] init];
        [self addChildViewController:vc];
    }
    
    // 1. 设置菜单项展示
    self.segmentBar.segmentModels = items;
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width * items.count, 0);
    
    self.segmentBar.selectIndex = 0;
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
    TodayFireVoiceTableController *cvc = self.childViewControllers[index];
    cvc.loadKey = self.categoryMs[index].key;
    UIView *view = cvc.view;
    CGFloat contentViewW = self.contentScrollView.width;
    view.frame = CGRectMake(contentViewW * index, 0, contentViewW, self.contentScrollView.height);
    [self.contentScrollView addSubview:view];
    [self.contentScrollView setContentOffset:CGPointMake(contentViewW * index, 0) animated:YES];
}

@end
