//
//  NSObject+TKBundle.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "NSObject+TKBundle.h"

@implementation NSObject (TKBundle)

+ (NSBundle *)currentBundle {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    return bundle;
}

@end
