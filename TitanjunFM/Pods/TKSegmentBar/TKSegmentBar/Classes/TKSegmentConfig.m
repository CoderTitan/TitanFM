//
//  TKSegmentConfig.m
//  TKSegmentBar_Example
//
//  Created by quanjunt on 2018/8/30.
//  Copyright © 2018年 CoderTitan. All rights reserved.
//

#import "TKSegmentConfig.h"


@implementation TKSegmentConfig

+ (instancetype)defaultConfig {
    return [[TKSegmentConfig alloc] init];
}

/** 用于标识选项卡的指示器颜色 */
- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor redColor];
    }
    return _indicatorColor;
}

- (CGFloat)indicatorHeight {
    if (_indicatorHeight <= 0) {
        _indicatorHeight = 2;
    }
    return _indicatorHeight;
}

/** 选项颜色(普通) */
-(UIColor *)segNormalColor {
    if (!_segNormalColor) {
        _segNormalColor = [UIColor grayColor];
    }
    return _segNormalColor;
}

/** 选项颜色(选中) */
-(UIColor *)segSelectedColor {
    if (!_segSelectedColor) {
        _segSelectedColor = [UIColor redColor];
    }
    return _segSelectedColor;
}

/** 选项字体(普通) */
- (UIFont *)segNormalFont {
    if (!_segNormalFont) {
        _segNormalFont = [UIFont systemFontOfSize:12];
    }
    return _segNormalFont;
}

/** 选项字体(选中) */
- (UIFont *)segSelectedFont {
    if (!_segSelectedFont) {
        _segSelectedFont = [UIFont systemFontOfSize:12];
    }
    return _segSelectedFont;
    
}

/** 选项卡之间的最小间距 */
- (CGFloat)limitMargin {
    if (_limitMargin <= 0) {
        _limitMargin = 25;
    }
    
    return _limitMargin;
}

- (TKSegmentConfig *(^)(UIColor *))itemNC {
    return ^(UIColor *color){
        self.segNormalColor = color;
        return self;
    };
}

- (TKSegmentConfig *(^)(UIColor *))itemSC {
    return ^(UIColor *color){
        self.segSelectedColor = color;
        return self;
    };
}
@end
