//
//  TKSpecialColumnModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKSpecialColumnModel : NSObject

@property (nonatomic, assign)  NSInteger columnType;
@property (nonatomic, assign)  NSInteger specialId;
@property (nonatomic, copy)  NSString *title;
@property (nonatomic, copy)  NSString *subtitle;
@property (nonatomic, copy)  NSString *footnote;
@property (nonatomic, copy)  NSString *coverPath;
@property (nonatomic, copy)  NSString *contentType;


@end

NS_ASSUME_NONNULL_END
