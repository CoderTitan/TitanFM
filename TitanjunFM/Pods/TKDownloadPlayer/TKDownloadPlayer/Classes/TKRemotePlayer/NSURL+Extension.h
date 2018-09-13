//
//  NSURL+Extension.h
//  PlayerManager
//
//  Created by quanjunt on 2018/9/3.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Extension)

/**
 获取streaming协议的url地址
 */
- (NSURL *)streamingURL;


- (NSURL *)httpURL;

@end
