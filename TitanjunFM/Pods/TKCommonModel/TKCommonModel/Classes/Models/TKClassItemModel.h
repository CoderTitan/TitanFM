//
//  TKClassItemModel.h
//  MoreModel
//
//  Created by quanjunt on 2018/9/17.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKClassItemModel : NSObject

@property (nonatomic, copy)  NSString *id;
@property (nonatomic, copy)  NSString *name;
@property (nonatomic, copy)  NSString *title;
@property (nonatomic, assign)  BOOL isChecked;
@property (nonatomic, assign)  NSInteger orderNum;
@property (nonatomic, copy)  NSString *coverPath;
@property (nonatomic, assign)  BOOL selectedSwitch;
@property (nonatomic, assign)  BOOL isFinished;
@property (nonatomic, copy)  NSString *contentType;
@property (nonatomic, assign)  NSInteger categoryType;
@property (nonatomic, assign)  BOOL filterSupported;
@property (nonatomic, assign)  BOOL isPaid;



@end
