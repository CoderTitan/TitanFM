//
//  TKSegmentBar.m
//  TKSegmentBar_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import "TKSegmentBar.h"
#import "UIView+SegLayout.h"
#import "TKSegmentController.h"
#import "TKSegmentButton.h"

#define kShowMoreBtnW (self.bounds.size.height + 30)

@interface TKSegmentBar ()<UICollectionViewDelegate>
/** 用于显示内容选项卡的视图 */
@property (nonatomic, strong) UIScrollView *contentScrollView;

/** 用于标识选项卡的指示器 */
@property (nonatomic, strong) UIView *indicatorView;

/** 用于存储选项按钮数组 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*segBtns;

/** 用于记录上次选项 */
@property (nonatomic, weak) UIButton *lastBtn;

/** 选项卡显示配置, 修改此模型属性之后, 需要调用updateViewWithConfig 生效 */
@property (nonatomic, strong) TKSegmentConfig *segmentConfig;

@property (nonatomic, strong) TKSegmentButton *showMoreBtn;
@property (nonatomic, nonnull, strong) UIView *coverView;
@property (nonatomic, strong) TKSegmentController *showDetailVC;

@end

@implementation TKSegmentBar
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.segmentConfig = [TKSegmentConfig defaultConfig];
    }
    return self;
}

- (void)setSegmentConfig:(TKSegmentConfig *)segmentConfig {
    _segmentConfig = segmentConfig;
    
    // 指示器颜色
    self.indicatorView.backgroundColor = segmentConfig.indicatorColor;
    self.indicatorView.height = segmentConfig.indicatorHeight;
    
    // 选项颜色/字体
    for (UIButton *btn in self.segBtns) {
        [btn setTitleColor:segmentConfig.segNormalColor forState:UIControlStateNormal];
        if (btn != self.lastBtn) {
            btn.titleLabel.font = segmentConfig.segNormalFont;
        } else {
            btn.titleLabel.font = segmentConfig.segSelectedFont;
        }
        [btn setTitleColor:segmentConfig.segSelectedColor forState:UIControlStateSelected];
    }
    
    // 最小间距
    [self layoutIfNeeded];
    [self layoutSubviews];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    for (UIButton *btn in self.segBtns) {
        if (btn.tag == selectIndex) {
            [self segClick:btn];
            break;
        }
    }
}
- (void)setSegmentModels:(NSArray<id<TKSegmentModelProtocol>> *)segmentModels {
    _segmentModels = segmentModels;
    
    if (self.segmentConfig.isShowMore) {
        self.showDetailVC.items = _segmentModels;
        self.showDetailVC.collectionView.height = 0;
    }
    
    // 移除之前所有的子控件
    [self.segBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.segBtns = nil;
    self.lastBtn = nil;
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
    
    // 添加最新的子控件
    for (NSObject<TKSegmentModelProtocol> *segM in _segmentModels) {
        UIButton *btn = [[UIButton alloc] init];
        if (segM.segID == -1) {
            btn.tag = self.segBtns.count;
            
        }else {
            btn.tag = segM.segID;
        }
        
        [btn addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = self.segmentConfig.segNormalFont;
        [btn setTitleColor:self.segmentConfig.segNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.segmentConfig.segSelectedColor forState:UIControlStateSelected];
        [btn setTitle:segM.segContent forState:UIControlStateNormal];
        [self.contentScrollView addSubview:btn];
        [btn sizeToFit];
        
        // 保存到一个数组中
        [self.segBtns addObject:btn];
        
    }
    // 重新布局
    [self layoutIfNeeded];
    [self layoutSubviews];
    
    
    // 默认选中第一个选项卡
    [self segClick:[self.segBtns firstObject]];
}


#pragma mark - 对外方法
/**
 *  快速根据配置参数, 创建选项卡
 *
 *  @param config 选项卡配置模型
 *
 *  @return 选项卡
 */
+ (instancetype)segmentBarWithConfig: (TKSegmentConfig *)config {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGRect defaultFrame = CGRectMake(0, 0, width, 40);
    TKSegmentBar *segBar = [[TKSegmentBar alloc] initWithFrame:defaultFrame];
    segBar.segmentConfig = config;
    return segBar;
}

- (void)updateWithConfig: (void(^)(TKSegmentConfig *config))configBlock {
    if (configBlock != nil) {
        configBlock(self.segmentConfig);
    }
    self.segmentConfig = self.segmentConfig;
}


#pragma mark - 私有方法
- (void)segClick: (UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(segmentBarDidSelectIndex:fromIndex:)]) {
        _selectIndex = btn.tag;
        [self.delegate segmentBarDidSelectIndex:_selectIndex fromIndex:btn.tag];
    }
    
    // 修改状态
    self.lastBtn.selected = NO;
    self.lastBtn.titleLabel.font = self.segmentConfig.segNormalFont;
    [self.lastBtn sizeToFit];
    self.lastBtn.height = self.contentScrollView.height - self.segmentConfig.indicatorHeight;
    
    btn.selected = YES;
    btn.titleLabel.font = self.segmentConfig.segSelectedFont;
    [btn sizeToFit];
    btn.height = self.contentScrollView.height - self.segmentConfig.indicatorHeight;
    self.lastBtn = btn;
    
    if (self.segmentConfig.isShowMore) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.lastBtn.tag inSection:0];
        [self.showDetailVC.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self hideDetailPane];
    }
    
    //状态指示条
    [UIView animateWithDuration:0.2 animations:^{
        // 控制宽度, 和中心
        NSString *text = btn.titleLabel.text;
        NSDictionary *fontDic = @{
                                  NSFontAttributeName : btn.titleLabel.font
                                  };
        CGSize size = [text sizeWithAttributes:fontDic];
        self.indicatorView.y = self.contentScrollView.height - self.segmentConfig.indicatorHeight;
        self.indicatorView.width = size.width + self.segmentConfig.indicatorExtraWidth;
        self.indicatorView.centerX = btn.centerX;
    }];
    
    // 自动滚动到中间位置
    CGFloat shouldScrollX = btn.centerX - self.contentScrollView.width * 0.5;
    
    if (shouldScrollX < 0) {
        shouldScrollX = 0;
    }
    
    if (shouldScrollX > self.contentScrollView.contentSize.width - self.contentScrollView.width) {
        shouldScrollX = self.contentScrollView.contentSize.width - self.contentScrollView.width;
    }
    
    [self.contentScrollView setContentOffset:CGPointMake(shouldScrollX, 0) animated:YES];
}


#pragma 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentScrollView.frame = self.bounds;
    
    if (!self.segmentConfig.isShowMore) {
        self.contentScrollView.frame = self.bounds;
        self.showMoreBtn.width = -1;
    }else {
        self.contentScrollView.frame = CGRectMake(0, 0, self.width - kShowMoreBtnW, self.height);
        self.showMoreBtn.frame = CGRectMake(self.width - kShowMoreBtnW, 0, kShowMoreBtnW, self.height);
    }
    
    // 1. 计算间距
    CGFloat titleTotalW = 0;
    for (int i = 0; i < self.segBtns.count; i++)  {
        [self.segBtns[i] sizeToFit];
        CGFloat width = self.segBtns[i].width;
        titleTotalW += width;
    }
    
    CGFloat margin = (self.contentScrollView.width - titleTotalW) / (self.segmentModels.count + 1);
    margin = margin < self.segmentConfig.limitMargin ? self.segmentConfig.limitMargin : margin;
    
    // 布局topmMenue 内部控件
    CGFloat btnY = 0;
    
    CGFloat btnHeight = self.contentScrollView.height - self.segmentConfig.indicatorHeight;
    UIButton *lastBtn;
    for (int i = 0; i < self.segBtns.count; i++) {
        
        // 计算每个控件的宽度
        CGFloat btnX = CGRectGetMaxX(lastBtn.frame) + margin;
        self.segBtns[i].x = btnX;
        self.segBtns[i].y = btnY;
        self.segBtns[i].height = btnHeight;
        
        lastBtn = self.segBtns[i];
        
    }
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame) + margin, 0);
    
    // 修正指示器的位置, 控制宽度, 和中心
    if (self.lastBtn) {
        NSString *text = self.lastBtn.titleLabel.text;
        NSDictionary *fontDic = @{
                                  NSFontAttributeName : self.lastBtn.titleLabel.font
                                  };
        CGSize size = [text sizeWithAttributes:fontDic];
        self.indicatorView.y = self.contentScrollView.height - self.segmentConfig.indicatorHeight;
        self.indicatorView.width = size.width + self.segmentConfig.indicatorExtraWidth;
        self.indicatorView.centerX = self.lastBtn.centerX;
    }
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    [self hideDetailPane];
}



#pragma mark - 懒加载
- (TKSegmentController *)showDetailVC {
    if (!_showDetailVC) {
        _showDetailVC = [[TKSegmentController alloc] init];
        _showDetailVC.collectionView.delegate = self;
    }
    
    if (_showDetailVC.collectionView.superview != self.superview) {
        _showDetailVC.collectionView.frame = CGRectMake(0, self.y + self.height, self.width, 0);
        [self.superview addSubview:_showDetailVC.collectionView];
    }
    
    return _showDetailVC;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, self.y + self.height, self.width, 0)];
        _coverView.backgroundColor = [UIColor colorWithRed:55 / 255.0 green:55 / 255.0 blue:55 / 255.0 alpha:0.4];
        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetailPane)];
        [_coverView addGestureRecognizer:gester];
    }
    if (!_coverView.superview) {
        [self.superview insertSubview:_coverView belowSubview:self.showDetailVC.collectionView];
    }
    return _coverView;
}

- (TKSegmentButton *)showMoreBtn {
    if (!_showMoreBtn) {
        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
        NSString *sourcePath = [currentBundle.infoDictionary[@"CFBundleName"] stringByAppendingString:@".bundle"];
        NSString *showImgPath = [currentBundle pathForResource:@"icon_radio_show@2x" ofType:@".png" inDirectory:sourcePath];
        UIImage *showImage = [UIImage imageWithContentsOfFile:showImgPath];
        
        NSString *hideImgPath = [currentBundle pathForResource:@"icon_radio_hide@2x" ofType:@".png" inDirectory:sourcePath];
        UIImage *hideImage = [UIImage imageWithContentsOfFile:hideImgPath];
        
        _showMoreBtn = [[TKSegmentButton alloc] init];
        [_showMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_showMoreBtn setImage:showImage forState:UIControlStateNormal];
        [_showMoreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_showMoreBtn setImage:hideImage forState:UIControlStateSelected];
        _showMoreBtn.imageView.contentMode = UIViewContentModeCenter;
        [_showMoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _showMoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        // 添加分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 1, 20)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_showMoreBtn addSubview:line];
        
        
        [_showMoreBtn addTarget:self action:@selector(showOrHide:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_showMoreBtn];
    }
    return _showMoreBtn;
}

/** 用于显示内容选项卡的视图 */
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentScrollView];
    }
    return _contentScrollView;
}


/** 用于标识选项卡的指示器 */
- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - self.segmentConfig.indicatorHeight, 0, self.segmentConfig.indicatorHeight)];
        _indicatorView.backgroundColor = self.segmentConfig.indicatorColor;
        [self.contentScrollView addSubview:_indicatorView];
    }
    return _indicatorView;
}

/** 用于存储选项卡的数组 */
- (NSMutableArray<UIButton *> *)segBtns {
    if (!_segBtns) {
        _segBtns = [NSMutableArray array];
    }
    return _segBtns;
}

- (void)showOrHide: (UIButton *)btn {
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self showDetailPane];
    }else {
        [self hideDetailPane];
    }
}

- (void)showDetailPane {
    self.showMoreBtn.selected = YES;
    self.showDetailVC.collectionView.hidden = NO;
    self.coverView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.showDetailVC.collectionView.height = self.showDetailVC.expectedHeight;
        self.coverView.height = [UIScreen mainScreen].bounds.size.height;
    }];
    
}

- (void)hideDetailPane {
    self.showMoreBtn.selected = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.showDetailVC.collectionView.height = 0;
        self.coverView.height = 0;
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;
        self.showDetailVC.collectionView.hidden = YES;
    }];
}

@end
