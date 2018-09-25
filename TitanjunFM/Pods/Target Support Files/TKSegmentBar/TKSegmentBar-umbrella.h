#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSString+SegmentProtocol.h"
#import "TKSegmentBar.h"
#import "TKSegmentButton.h"
#import "TKSegmentConfig.h"
#import "TKSegmentController.h"
#import "TKSegmentMenueCell.h"
#import "TKSegmentModelProtocol.h"
#import "UIView+SegLayout.h"

FOUNDATION_EXPORT double TKSegmentBarVersionNumber;
FOUNDATION_EXPORT const unsigned char TKSegmentBarVersionString[];

