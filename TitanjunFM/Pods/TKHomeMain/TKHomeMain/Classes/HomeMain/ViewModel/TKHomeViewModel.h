//
//  TKHomeViewModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKHomeTabModel.h"

@interface TKHomeViewModel : NSObject

+ (instancetype)shareInstance;

- (void)getHomeTabs: (void(^)(NSArray <TKHomeTabModel *> *tabModels))resultBlock;

@end
