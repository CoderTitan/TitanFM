//
//  TKNoticeLocal.h
//  MainModule
//
//  Created by quanjunt on 2018/8/28.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TKNoticeLocal : NSObject

+(UILocalNotification *)registerLocalNotificationWithFireDate:(NSDate *)firedate repeatType:(NSCalendarUnit)repeatInterval keepSleep:(BOOL)isKeepSleep;

+(void)cancelAllLocalNotifications;
+(void)cancelKeepSleepNotice;
+(void)cancleAlarmNotifications;

@end
