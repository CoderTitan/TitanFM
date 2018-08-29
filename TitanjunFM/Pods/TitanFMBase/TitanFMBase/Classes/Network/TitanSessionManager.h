//
//  TitanSessionManager.h
//  MainModule
//
//  Created by quanjunt on 2018/8/28.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    RequestTypeGet,
    RequestTypePost
    
}RequestType;


@interface TitanSessionManager : NSObject

    
- (void)setValue:(NSString *)value forHttpField:(NSString *)field;
    
- (void)request:(RequestType)requestType urlStr: (NSString *)urlStr parameter: (NSDictionary *)param resultBlock: (void(^)(id responseObject, NSError *error))resultBlock;

    
@end
