//
//  NSString+SegmentProtocol.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "NSString+SegmentProtocol.h"

@implementation NSString (SegmentProtocol)

- (NSInteger)segID {
    return -1;
}

- (NSString *)segContent {
    return self;
}

@end
