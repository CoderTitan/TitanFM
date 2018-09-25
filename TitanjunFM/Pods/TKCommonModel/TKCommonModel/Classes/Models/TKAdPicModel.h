//
//  TKAdPicModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKFocusImageModel.h"
#import "TKLiveModel.h"
#import "TKPromotionModel.h"
#import "TKClassItemModel.h"

@interface TKAdPicModel : NSObject

@property (nonatomic, strong) TKFocusImageModel *focusImageM;

@property (nonatomic, strong) TKLiveModel *liveM;

@property (nonatomic, strong) TKPromotionModel *promotionM;

@property (nonatomic, strong) TKClassItemModel *classItemM;



/**
 *  广告图片URL
 */
@property (nonatomic, copy) NSURL *adImgURL;

/**
 *  点击广告, 需要跳转的URL
 */
@property (nonatomic, copy) NSURL *adLinkURL;

/**
 *  点击执行的代码块(优先级高于adLinkURL)
 */
@property (nonatomic, copy) void(^clickBlock)(void);


@end
