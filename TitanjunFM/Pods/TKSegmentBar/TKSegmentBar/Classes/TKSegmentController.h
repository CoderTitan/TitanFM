//
//  TKSegmentController.h
//  TKSegmentBar_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKSegmentBar.h"

@interface TKSegmentController : UIViewController

@property (nonatomic, weak) TKSegmentBar *segmentBar;


- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs;

@end
