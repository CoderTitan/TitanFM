//
//  NSString+SegmentProtocol.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKSegmentModelProtocol.h"

@interface NSString (SegmentProtocol) <TKSegmentModelProtocol>

/** 选项卡的ID, 如果不设置, 默认是索引值(从0开始) */
- (NSInteger)segID;

/** 选项卡内容 */
- (NSString *)segContent;


@end
