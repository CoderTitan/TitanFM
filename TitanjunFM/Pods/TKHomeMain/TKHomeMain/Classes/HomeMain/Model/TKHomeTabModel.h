//
//  TKHomeTabModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKSegmentModelProtocol;
@interface TKHomeTabModel : NSObject <TKSegmentModelProtocol>

/** 选项卡的ID, 如果不设置, 默认是索引值(从0开始) */
@property (nonatomic, assign) NSInteger segID;

/**
 内容类型
 */
@property (nonatomic, copy) NSString *contentType;

/**
 标题
 */
@property (nonatomic, copy, getter=segContent) NSString *title;


@end
