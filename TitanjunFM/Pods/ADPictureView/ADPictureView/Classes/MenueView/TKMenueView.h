//
//  TKMenueView.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMenueModelProtocol.h"


typedef void(^TKMenueViewLoadImageBlock)(UIButton *imageBtn, NSURL *url);

@interface TKMenueView : UIScrollView

@property (nonatomic, copy) TKMenueViewLoadImageBlock loadBlock;


@property (nonatomic, strong) NSArray <id<TKMenueModelProtocol>> *menueModels;


@end
