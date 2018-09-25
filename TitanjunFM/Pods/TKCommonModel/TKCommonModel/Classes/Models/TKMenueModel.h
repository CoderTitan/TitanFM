//
//  TKMenueModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKMenueModel : NSObject

@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy, getter=imageURL) NSString *coverPath;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^clickBlock)(void);


@end
