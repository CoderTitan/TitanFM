
//
//  TKSegmentButton.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKSegmentButton.h"


#define radio 0.7
@implementation TKSegmentButton

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 0, contentRect.size.width * radio, contentRect.size.height);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(contentRect.size.width * radio, 0, contentRect.size.width * ( 1 - radio - 0.2), contentRect.size.height);
}

@end
