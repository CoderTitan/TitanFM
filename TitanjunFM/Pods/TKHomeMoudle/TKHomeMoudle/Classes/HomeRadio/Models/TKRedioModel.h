//
//  TKRedioModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKRadioPlayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKRedioModel : NSObject

@property (nonatomic, copy)NSString *coverLarge;
@property (nonatomic, copy)NSString *coverSmall;
@property (nonatomic, assign) int fmUid;
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int playCount;
@property (nonatomic, assign) int programId;
@property (nonatomic, copy)NSString *programName;
@property (nonatomic, assign) int programScheduleId;

@property (nonatomic, strong) TKRadioPlayModel *playUrl;

@end

NS_ASSUME_NONNULL_END
