//
//  NSString+MD5.m
//  FileDownLoad
//
//  Created by quanjunt on 2018/9/3.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)md5 {
    //传承C语言字符串
    const char *data = self.UTF8String;
    
    //用于存储结果的C语言字符串
    unsigned char md[CC_MD2_DIGEST_LENGTH];
    
    //把C语言字符串转成MD5的C字符串
    //参数一: C语言字符串, 参数二: C语言字符串长度, 参数三: 结果
    CC_MD5(data, (CC_LONG)strlen(data), md);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD2_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD2_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", md[i]];
    }
    
    return result;
}
@end
