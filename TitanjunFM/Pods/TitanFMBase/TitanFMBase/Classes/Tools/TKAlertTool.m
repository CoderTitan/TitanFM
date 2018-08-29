//
//  TKAlertTool.m
//  MainModule
//
//  Created by quanjunt on 2018/8/28.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKAlertTool.h"

@implementation TKAlertTool

+ (void)alertTitle:(NSString *)titile type:(UIAlertControllerStyle)alertType message:(NSString *)message didTask:(void (^)(void))task {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titile message:message preferredStyle:alertType];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (task) {
            task();
        }
    }];
    
    [alertVC addAction:action];
    [alertVC addAction:action1];
    
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

@end
