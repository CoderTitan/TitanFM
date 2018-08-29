//
//  Sington.h
//  喜马拉雅FM
//
//  Created by 王顺子 on 16/8/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//


#define singtonInterface  + (instancetype)shareInstance;



#define singtonImplement(class) \
\
static class *_shareInstance; \
\
+ (instancetype)shareInstance { \
\
    if(_shareInstance == nil) {\
        _shareInstance = [[class alloc] init]; \
    } \
    return _shareInstance; \
} \
\
+(instancetype)allocWithZone:(struct _NSZone *)zone { \
\
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _shareInstance = [super allocWithZone:zone]; \
    }); \
\
    return _shareInstance; \
\
}
