//
//  TKSegmentModelProtocol.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//



#pragma mark - 模型必须遵循的协议

@protocol TKSegmentModelProtocol <NSObject>

/** 选项卡的ID, 如果不设置, 默认是索引值(从0开始) */
@property (nonatomic, assign, readonly) NSInteger segID;

/** 选项卡内容 */
@property (nonatomic, copy, readonly) NSString *segContent;

@end
