//
//  TKMenueView.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKMenueView.h"
#import "TKDownButton.h"

#define kMenueWidth 60
#define kMenueMargin 20


@implementation TKMenueView

- (void)setMenueModels:(NSArray<id<TKMenueModelProtocol>> *)menueModels {
    _menueModels = menueModels;
    
    // 1. 移除所有之前的按钮
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger count = menueModels.count;
    for(int i = 0; i < count; i++) {
        id<TKMenueModelProtocol> model = menueModels[i];
        TKDownButton *button = [[TKDownButton alloc]init];
        if (self.loadBlock) {
            self.loadBlock(button, [NSURL URLWithString:model.imageURL]);
        }
        button.tag = self.subviews.count;
        [button setTitle:model.title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    [self setNeedsLayout];
}

- (void)btnClick: (TKDownButton *)upDownBtn {
    NSInteger tag = upDownBtn.tag;
    id<TKMenueModelProtocol> model = self.menueModels[tag];
    if (model.clickBlock != nil) {
        model.clickBlock();
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = self.menueModels.count;
    CGFloat h = self.frame.size.height;
    for(int i = 0; i < count; i++) {
        UIView *subView = self.subviews[i];
        subView.frame = CGRectMake(i * (kMenueWidth + kMenueMargin) + kMenueMargin, 0, kMenueWidth, h);
    }
    
    self.contentSize = CGSizeMake((kMenueWidth + kMenueMargin) * count + kMenueMargin, 0);
}

@end
