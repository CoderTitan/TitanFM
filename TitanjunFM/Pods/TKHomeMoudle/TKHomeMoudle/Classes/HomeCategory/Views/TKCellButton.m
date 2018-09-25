//
//  TKCellButton.m
//  All
//
//  Created by 田全军 on 2018/9/17.
//  Copyright © 2018年 田全军. All rights reserved.
//

#import "TKCellButton.h"
#import "UIView+Layout.h"

@implementation TKCellButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake(self.width * 0.2, self.centerY / 2, 25, 25);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(self.width * 0.4, 0, self.width, self.height);
}

@end
