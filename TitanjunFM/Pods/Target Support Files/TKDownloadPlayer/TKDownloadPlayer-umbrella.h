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

#import "NSString+MD5.h"
#import "TKDownLoader.h"
#import "TKDownLoadManager.h"
#import "TKFileTool.h"
#import "NSURL+Extension.h"
#import "TKAudioDownLoader.h"
#import "TKRemoteCacheFile.h"
#import "TKRemoteLoaderDelegate.h"
#import "TKRemotePlayer.h"

FOUNDATION_EXPORT double TKDownloadPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char TKDownloadPlayerVersionString[];

