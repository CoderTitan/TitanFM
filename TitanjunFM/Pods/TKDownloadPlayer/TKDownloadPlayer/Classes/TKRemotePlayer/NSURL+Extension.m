//
//  NSURL+Extension.m
//  PlayerManager
//
//  Created by quanjunt on 2018/9/3.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "NSURL+Extension.h"

@implementation NSURL (Extension)


- (NSURL *)streamingURL {
    // 切片处理, streaming协议切片
    NSURLComponents *compents = [NSURLComponents componentsWithString:self.absoluteString];
    compents.scheme = @"streaming";
    return compents.URL;
}


- (NSURL *)httpURL {
    NSURLComponents *compents = [NSURLComponents componentsWithString:self.absoluteString];
    compents.scheme = @"http";
    return compents.URL;
}

@end
