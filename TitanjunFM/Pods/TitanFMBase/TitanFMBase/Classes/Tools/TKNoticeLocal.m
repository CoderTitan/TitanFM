//
//  TKNoticeLocal.m
//  MainModule
//
//  Created by quanjunt on 2018/8/28.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKNoticeLocal.h"

@implementation TKNoticeLocal

+ (UILocalNotification *)registerLocalNotificationWithFireDate:(NSDate *)firedate repeatType:(NSCalendarUnit)repeatInterval keepSleep:(BOOL)isKeepSleep {
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.repeatInterval = repeatInterval;
    localNoti.timeZone = [NSTimeZone systemTimeZone];
    localNoti.fireDate = firedate;
    localNoti.alertAction = @"查看";
    localNoti.alertBody = @"该起床啦";
    localNoti.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary *dict = nil;
    
    if (isKeepSleep) {
        [self cancelKeepSleepNotice];
        dict =   @{@"noticekeepSleepID" : @"noticekeepSleep"};
    }else {
        [self cancleAlarmNotifications];
        dict =   @{@"noticeAlarmID" : @"noticeAlarm"};
        
    }
    localNoti.userInfo = dict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    NSLog(@"\n=============Normal注册通知============\n%@\n",localNoti);
    return localNoti;
}

+(void)cancelAllLocalNotifications{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+(void)cancelKeepSleepNotice{
    
    int i = 0;
    
    for (UILocalNotification *ln in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        NSLog(@"cancelKeepSleepNotice = ln.userInfo = %@",ln.userInfo);
        if ([[ln.userInfo objectForKey:@"noticekeepSleepID"] isEqualToString:@"noticekeepSleep"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:ln];
            NSLog(@"\n=============删除通知============\n%@\n",ln);
            i++;
        }
    }
    
}

+(void)cancleAlarmNotifications{
    int i = 0;
    
    for (UILocalNotification *ln in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        NSLog(@"cancleAlarmNotifications = ln.userInfo = %@",ln.userInfo);
        if ([[ln.userInfo objectForKey:@"noticeAlarmID"] isEqualToString:@"noticeAlarm"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:ln];
            NSLog(@"\n=============删除通知============\n%@\n",ln);
            i++;
        }
    }
}

@end
