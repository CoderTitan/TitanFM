//
//  TKAnchorViewModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKAnchorGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKAnchorViewModel : NSObject

+ (instancetype)shareInstance;

- (void)getAnchorMs:(void(^)(NSArray <TKAnchorGroupModel *> *anchorModels))resultBlock;

@end

NS_ASSUME_NONNULL_END
