//
//  UIImageView+Extension.m
//  MainModule
//
//  Created by quanjunt on 2018/8/28.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Image.h"

@implementation UIImageView (Extension)

    
- (void)setURLImageWithURL:(NSURL *)url progress:(void (^)(CGFloat))progress complete:(void (^)(void))complete {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progress != nil) {
            progress(1.0 * receivedSize / expectedSize);
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.image = image;
        if (complete != nil) {
            complete();
        }
    }];
}
    
- (void)setURLImageWithURL:(NSURL *)url placeHoldImage:(UIImage *)placeHoldImage isCircle:(BOOL)isCircle {
    if (isCircle) {
        [self sd_setImageWithURL:url placeholderImage:placeHoldImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            //绘制圆形图片
            UIImage *resImage = [image circleImage];
            
            //处理图片
            if (resImage == nil) return ;
            self.image = resImage;
        }];
    } else {
        [self sd_setImageWithURL:url placeholderImage:placeHoldImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            //处理图片
            if (image == nil) return ;
            self.image = image;
        }];
    }
}
@end
