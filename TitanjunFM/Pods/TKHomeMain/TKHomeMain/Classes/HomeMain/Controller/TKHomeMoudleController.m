//
//  TKHomeMoudleController.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKHomeMoudleController.h"
#import "BaseConstant.h"
#import "TKSegmentBar.h"
#import "TKHomeViewModel.h"
#import "TKCategoryController.h"
#import "TKAnchorTableController.h"
#import "TKRadioBroadcaseController.h"
#import "TKRankingViewController.h"
#import "TKRecommendController.h"


@interface TKHomeMoudleController ()<TKSegmentBarDelegate, UIScrollViewDelegate>
/**
 可以通过这个属性配置相关参数, 比如位置, 是否显示更多, 默认索引等
 */
@property (nonatomic, strong) TKSegmentBar *segmentBar;

@property (nonatomic, weak) UIScrollView *contentScrollView;

@end

@implementation TKHomeMoudleController
@synthesize segmentBar = _segmentBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发现";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = backColor;
    
    self.segBarFrame = CGRectMake(0, kNavigationBarMaxY, kScreenWidth, kMenueBarHeight);
    self.contentScrollViewFrame = CGRectMake(0, kNavigationBarMaxY + kMenueBarHeight, kScreenWidth, kScreenHeight - kNavigationBarMaxY - kTabbarHeight - kMenueBarHeight);
    
    [[TKHomeViewModel shareInstance] getHomeTabs:^(NSArray<TKHomeTabModel *> *tabModels) {
        [self setUpWithSegModels:tabModels andChildVCs:@[[TKRecommendController new], [TKCategoryController new], [TKRadioBroadcaseController new], [TKRankingViewController new], [TKAnchorTableController new]]];
        self.segSelectIndex = 0;
    }];
}

- (void)setUpWithSegModels:(NSArray *)segArr andChildVCs:(NSArray *)subVCs {
    // 0. 添加子控制器
    for (UIViewController *vc in subVCs) {
        [self addChildViewController:vc];
    }
    
    self.segmentBar.segmentModels = segArr;
    // 1. 设置菜单栏
    [self.view addSubview:self.segmentBar];
    
    // 2. 设置代理
    self.segmentBar.delegate = self;
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * self.childViewControllers.count, 0);
}

#pragma mark - 重写和懒加载
- (TKSegmentBar *)segmentBar {
    if (!_segmentBar) {
        TKSegmentBar *segmentBar = [TKSegmentBar segmentBarWithConfig:[TKSegmentConfig defaultConfig]];
        _segmentBar = segmentBar;
        _segmentBar.backgroundColor = [UIColor whiteColor];
        _segmentBar.frame = self.segBarFrame;
        [self.view addSubview:_segmentBar];
    }
    return _segmentBar;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        // 2. 添加内容视图
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.contentScrollViewFrame];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        _contentScrollView = scrollView;
        [self.view addSubview:scrollView];
    }
    return _contentScrollView;
}

- (void)setSegSelectIndex:(NSInteger)segSelectIndex {
    self.segmentBar.selectIndex = segSelectIndex;
}

- (void)setSegBarFrame:(CGRect)segBarFrame {
    _segBarFrame = segBarFrame;
    self.segmentBar.frame = segBarFrame;
}

- (void)setIsShowMore:(BOOL)isShowMore {
    _isShowMore = isShowMore;
    [self.segmentBar updateWithConfig:^(TKSegmentConfig *config) {
        config.isShowMore = isShowMore;
    }];
}

- (void)setContentScrollViewFrame:(CGRect)contentScrollViewFrame {
    _contentScrollViewFrame = contentScrollViewFrame;
    self.contentScrollView.frame = _contentScrollViewFrame;
}


#pragma mark - 代理
- (void)segmentBarDidSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex {
    UIView *view = self.childViewControllers[toIndex].view;
    CGFloat contentViewW = self.contentScrollView.frame.size.width;
    view.frame = CGRectMake(contentViewW * toIndex, 0, contentViewW, self.contentScrollView.frame.size.height);
    [self.contentScrollView addSubview:view];
    [self.contentScrollView setContentOffset:CGPointMake(contentViewW * toIndex, 0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.segmentBar.selectIndex = page;
}


@end
