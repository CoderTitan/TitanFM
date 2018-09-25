//
//  TKAnchorModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/18.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKAnchorModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *smallLogo;
@property (nonatomic, copy) NSString *middleLogo;
@property (nonatomic, copy) NSString *largeLogo;
@property (nonatomic, assign) BOOL isVerified;
@property (nonatomic, assign) NSInteger tracksCounts;
@property (nonatomic, assign) NSInteger followersCounts;
@property (nonatomic, copy) NSString *verifyTitle;



@end

NS_ASSUME_NONNULL_END
