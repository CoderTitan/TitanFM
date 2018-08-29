//
//  TKCacheTool.m
//  MainModule
//
//  Created by quanjunt on 2018/8/28.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKCacheTool.h"

@implementation TKCacheTool

+ (void)clearCacheWithPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:path error:nil];
}

+ (NSString *)getSizeWithPath: (NSString *)path {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    float totalSize = 0;
    BOOL isDirectory = NO;
    if(![manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        return @"";
    } else if (!isDirectory) {
        totalSize = [manager attributesOfItemAtPath:path error:nil].fileSize;
    } else {
        //    NSArray *paths = [manager contentsOfDirectoryAtPath:path error:nil];
        NSArray *subPaths = [manager subpathsAtPath:path];
        
        for(NSString *subPath in subPaths) {
            
            NSDictionary *dic = [manager attributesOfItemAtPath:[path stringByAppendingPathComponent:subPath] error:nil];
            
            if (dic.fileType == NSFileTypeRegular) {
                totalSize += dic.fileSize;
            }
        }
    }
    
    // 处理单位
    NSArray *units = @[@"B", @"KB", @"MB", @"GB", @"TB"];
    NSInteger count = 1000;
    NSInteger index = 0;
    while (totalSize > count) {
        totalSize = totalSize / count;
        index ++;
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%.1f%@", totalSize, units[index]];
    
    return formatStr;
}
@end
