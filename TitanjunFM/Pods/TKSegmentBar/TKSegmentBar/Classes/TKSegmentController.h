//
//  TKSegmentController.h
//  TKSegmentBar_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+SegmentProtocol.h"

@interface TKSegmentController : UICollectionViewController

@property (nonatomic, assign) CGFloat expectedHeight;

@property (nonatomic, strong) NSArray <id<TKSegmentModelProtocol>> *items;

@end
