//
//  TKCacheTool.h
//  MainModule
//
//  Created by quanjunt on 2018/8/28.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKCacheTool : NSObject

+ (NSString *)getSizeWithPath: (NSString *)path;

+ (void)clearCacheWithPath: (NSString *)path;


@end
