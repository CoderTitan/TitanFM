//
//  AdPicProtocol.h
//  ADPictureView
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

@protocol TitanAdPicProtocol <NSObject>

/**
 *  广告图片URL
 */
@property (nonatomic, copy, readonly) NSURL *adImgURL;


/**
 *  点击执行的代码块(优先级高于adLinkURL)
 */
@property (nonatomic, copy) void(^clickBlock)(void);


@end
