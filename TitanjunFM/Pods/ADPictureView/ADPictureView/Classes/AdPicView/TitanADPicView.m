//
//  TitanADPicView.m
//  ADPictureView_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import "TitanADPicView.h"

static NSInteger const radio = 10;

@interface TitanADPicView ()<UIScrollViewDelegate>
{
    NSInteger _currentPage;
}

/**
 *  记录着根据模型数组, 添加的imageView控件
 */
@property (nonatomic, strong) NSMutableArray <UIImageView *>*adPics;
/**
 *  存放图片的内容视图
 */
@property (nonatomic, strong) UIScrollView *contentView;
/**
 *  页码指示
 */
@property (nonatomic, strong) UIPageControl *pageControl;
/**
 *  自动滚动的timer
 */
@property (nonatomic, strong) NSTimer *scrollTimer;

@end

@implementation TitanADPicView
#pragma 懒加载
- (NSMutableArray<UIImageView *> *)adPics {
    if (_adPics == nil) {
        _adPics = [NSMutableArray array];
    }
    return _adPics;
}

- (UIScrollView *)contentView {
    if (_contentView == nil) {
        UIScrollView *contentView = [[UIScrollView alloc]init];
        contentView.pagingEnabled = YES;
        contentView.showsHorizontalScrollIndicator = NO;
        _contentView = contentView;
        _contentView.delegate = self;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        UIPageControl *pageCon = [[UIPageControl alloc]init];
        pageCon.pageIndicatorTintColor = [UIColor grayColor];
        pageCon.currentPageIndicatorTintColor = [UIColor orangeColor];
        pageCon.hidesForSinglePage = YES;
        [self addSubview:pageCon];
        _pageControl = pageCon;
    }
    return _pageControl;
}

- (NSTimer *)scrollTimer {
    if (_scrollTimer == nil) {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScrollNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    }
    return _scrollTimer;
}

- (void)autoScrollNextPage {
    NSInteger page = _currentPage + 1;
    [self.contentView setContentOffset:CGPointMake(self.contentView.frame.size.width * page, 0) animated:YES];
}

+ (instancetype)picViewWithLoadImageBlock:(loadImageBlock)loadBlock {
    TitanADPicView *adView = [[TitanADPicView alloc]init];
    adView.loadBlock = loadBlock;
    return adView;
}

- (void)setPicModels:(NSArray<id<TitanAdPicProtocol>> *)picModels {
    _picModels = picModels;
    
    //移除之前的控件
    [self.adPics makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.adPics removeAllObjects];
    
    //根据模型添加新控件
    NSInteger baseCount = picModels.count;
    NSInteger count = baseCount;
    if (baseCount > 1) {
        count = baseCount * radio;
    }
    for (int i = 0; i< count; i++) {
        id<TitanAdPicProtocol> picM = picModels[i % baseCount];
        //创建控件
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.tag = self.adPics.count;
        
        //设置图片
        if (self.loadBlock) {
            self.loadBlock(imageV, picM.adImgURL);
        }
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToLink:)];
        imageV.userInteractionEnabled = YES;
        [imageV addGestureRecognizer:tap];
        
        // 添加到父控件, 以及使用数组保存
        [self.contentView addSubview:imageV];
        [self.adPics addObject:imageV];
    }
    
    self.pageControl.numberOfPages = picModels.count;
    
    [self setNeedsLayout];
    
    if (picModels.count > 1) {
        [self.scrollTimer fire];
    }else {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

- (void)jumpToLink:(UITapGestureRecognizer *)gester {
    UIView *imageView = gester.view;
    NSInteger tag = imageView.tag % self.picModels.count;
    id<TitanAdPicProtocol> adM = self.picModels[tag];
    
    if (adM.clickBlock != nil) {
        adM.clickBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
    
    NSInteger count = self.adPics.count;
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    for(int i = 0;i < count;i++) {
        UIImageView *imageView = self.adPics[i];
        imageView.frame = CGRectMake(i * width, 0, width, height);
        
    }
    
    self.contentView.contentSize = CGSizeMake(width * count, 0);
    [self scrollViewDidEndDecelerating:self.contentView];
}

#pragma UISCrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.adPics.count > 1) {
        [self scrollTimer];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self caculateCurrentPage:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self caculateCurrentPage:scrollView];
}

- (void)caculateCurrentPage: (UIScrollView *)scrollView {
    if (self.picModels.count == 0) {
        return;
    }
    if (self.picModels.count == 1) {
        _currentPage = 1;
        if ([self.delegate respondsToSelector:@selector(adPicViewDidSelectorPicModel:)]) {
            [self.delegate adPicViewDidSelectorPicModel:self.picModels[self.pageControl.currentPage]];
        }
        return;
    }
    // 确认中间区域
    NSInteger min = self.picModels.count * (radio / 2);
    NSInteger max = self.picModels.count * (radio / 2 + 1);
    
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page % self.picModels.count;
    
    if (page < min || page > max) {
        page = min + page % self.picModels.count;
        [scrollView setContentOffset:CGPointMake(page * scrollView.frame.size.width, 0)];
    }
    
    _currentPage = page;
    
    if ([self.delegate respondsToSelector:@selector(adPicViewDidSelectorPicModel:)]) {
        [self.delegate adPicViewDidSelectorPicModel:self.picModels[self.pageControl.currentPage]];
    }
}
@end
