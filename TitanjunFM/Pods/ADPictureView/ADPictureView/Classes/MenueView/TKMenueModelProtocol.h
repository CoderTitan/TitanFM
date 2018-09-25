//
//  TKMenueModelProtocol.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

@protocol TKMenueModelProtocol <NSObject>

@property (nonatomic, copy, readonly) NSString *imageURL;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) void(^clickBlock)(void);

@end
