//
//  TKSegmentConfig.m
//  TKSegmentBar_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import "TKSegmentConfig.h"


@implementation TKSegmentConfig

+ (instancetype)defaultConfig {
    TKSegmentConfig *config = [[TKSegmentConfig alloc] init];
    config.segmentBarBackColor = [UIColor clearColor];
    config.itemFont = [UIFont systemFontOfSize:15];
    config.itemNormalColor = [UIColor lightGrayColor];
    config.itemSelectColor = [UIColor redColor];
    config.indicatorColor = [UIColor redColor];
    config.indicatorHeight = 2;
    config.indicatorExtraW = 10;
    
    return config;
}

- (TKSegmentConfig *(^)(UIColor *))itemNC {
    return ^(UIColor *color){
        self.itemNormalColor = color;
        return self;
    };
}

- (TKSegmentConfig *(^)(UIColor *))itemSC {
    return ^(UIColor *color){
        self.itemSelectColor = color;
        return self;
    };
}
@end
