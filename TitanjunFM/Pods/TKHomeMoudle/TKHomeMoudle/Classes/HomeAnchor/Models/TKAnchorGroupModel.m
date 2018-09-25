//
//  TKAnchorGroupModel.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKAnchorGroupModel.h"

@implementation TKAnchorGroupModel

- (CGFloat)cellHeight {
    if (self.displayStyle == 1) {
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 20 * 4) / 3;
        return  2 * width * 1.4 + 35 + 20 + 20;
    }
    
    if (self.displayStyle == 0) {
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 20 * 4) / 3;
        return  1 * width * 1.4 + 35 + 20;
    }
    
    if (self.displayStyle == 2) {
        return  6 * 70 + 35 + 20;
    }
    
    return 0.0;
}
@end
