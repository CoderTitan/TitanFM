//
//  TKNominateEditorModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/19.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 小编推荐--更多
@interface TKNominateEditorModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *albumCoverUrl290;
@property (nonatomic, copy) NSString *coverSmall;
@property (nonatomic, copy) NSString *coverMiddle;
@property (nonatomic, copy) NSString *coverLarge;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, assign) NSInteger tracks;
@property (nonatomic, assign) NSInteger playsCounts;
@property (nonatomic, assign) NSInteger isFinished;
@property (nonatomic, assign) NSInteger serialState;
@property (nonatomic, assign) NSInteger trackId;
@property (nonatomic, copy) NSString *trackTitle;
@property (nonatomic, assign)  BOOL isPaid;
@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, assign) NSInteger priceTypeId;


@end

NS_ASSUME_NONNULL_END
