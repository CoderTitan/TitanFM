//
//  TKAdPicModel.m
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import "TKAdPicModel.h"
#import "TitanAdPicProtocol.h"


@interface TKAdPicModel()<TitanAdPicProtocol>

@end

@implementation TKAdPicModel

- (void)setFocusImageM:(TKFocusImageModel *)focusImageM {
    _focusImageM = focusImageM;
    self.adImgURL = [NSURL URLWithString:_focusImageM.pic];
}

- (void)setLiveM:(TKLiveModel *)liveM {
    _liveM = liveM;
    self.adImgURL = [NSURL URLWithString:_liveM.coverPath];
}

- (void)setPromotionM:(TKPromotionModel *)promotionM {
    _promotionM = promotionM;
    self.adImgURL = [NSURL URLWithString:_promotionM.cover];
}

- (void)setClassItemM:(TKClassItemModel *)classItemM {
    _classItemM = classItemM;
    self.adImgURL = [NSURL URLWithString:_classItemM.coverPath];
}
@end
