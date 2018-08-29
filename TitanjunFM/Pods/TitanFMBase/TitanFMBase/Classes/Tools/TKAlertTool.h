//
//  TKAlertTool.h
//  MainModule
//
//  Created by quanjunt on 2018/8/28.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKAlertTool : NSObject

+ (void)alertTitle:(NSString *)titile type:(UIAlertControllerStyle)alertType message:(NSString *)message didTask:(void(^)(void))task;

@end
