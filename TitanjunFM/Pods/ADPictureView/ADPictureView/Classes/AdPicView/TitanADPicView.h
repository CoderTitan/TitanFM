//
//  TitanADPicView.h
//  ADPictureView_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitanAdPicProtocol.h"

typedef void(^loadImageBlock)(UIImageView *imageView, NSURL *url);

@protocol TitanAdPicViewDelegate <NSObject>
- (void)adPicViewDidSelectorPicModel:(id <TitanAdPicProtocol>)picModel;
@end

@interface TitanADPicView : UIView

+ (instancetype)picViewWithLoadImageBlock: (loadImageBlock)loadBlock;

/**
 *  用于加载图片的代码块, 必须赋值
 */
@property (nonatomic, copy) loadImageBlock loadBlock;

/**
 *  用于告知外界, 当前滚动到的是哪个广告数据模型
 */
@property (nonatomic, strong) id<TitanAdPicViewDelegate> delegate;

/**
 *  用来展示图片的数据源
 */
@property (nonatomic, strong) NSArray <id <TitanAdPicProtocol>>*picModels;


@end
