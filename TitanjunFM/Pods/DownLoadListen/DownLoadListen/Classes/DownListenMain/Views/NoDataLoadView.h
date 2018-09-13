//
//  NoDataLoadView.h
//  DownLoadListen
//
//  Created by quanjunt on 2018/9/5.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataLoadView : UIView

+ (instancetype)noDownLoadView;

@property (nonatomic, strong) UIImage *noDataImg;
@property (nonatomic, copy) void(^clickBlock)(void);


@end
