//
//  TKDownButton.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKDownButton.h"

@interface TKDownButton()

@property (nonatomic, assign) CGFloat radio;

@end

@implementation TKDownButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGFloat)radio {
    return 0.7;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, contentRect.size.height * self.radio, contentRect.size.width, contentRect.size.height * (1 - self.radio));
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height * self.radio);
}
@end
