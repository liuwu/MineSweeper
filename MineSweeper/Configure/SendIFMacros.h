//
//  SendIFMacros.h
//  TravelHeNan
//
//  Created by Apple on 13-12-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SendIFMacros_h
#define SendIFMacros_h

typedef void (^RequestFinish)(id resultInfo);
typedef void (^RequestFailedBlocks)(NSError *error);

typedef void (^SuccessBlock)(id resultInfo);
typedef void (^FailedBlock)(NSError *error);
typedef void (^FinalBlock)(void);

typedef void (^WLUploadProgressBlock)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);

typedef void(^WLVoidBlock)(void);
typedef void(^WLClickBlock)(UIButton *sender);


#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#define SAFE_BLOCK_CALL_NO_P(b) (b == nil ?: b())
#define SAFE_BLOCK_CALL(b, p) (b == nil ? : b(p) )

// .h
#define single_interface(class)  + (class *)shared##class;

// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}

//输出详细log,显示方法及所在的行数
// 2.日志输出宏定义
#ifdef DEBUG
// 调试状态
#define DLog(format, ...) do {                                              \
fprintf(stderr, ">------------------------------\n<%s : %d> %s\n",          \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-----------------------------------\n");                   \
} while (0)
#else
// 发布状态
#define DLog(...)
#endif


#define UMENG_EventId(...)       [MobClick event:@"" #__VA_ARGS__]


#define SuperSize [UIScreen mainScreen].bounds.size

/**
 *  系统字体
 *
 *  @param X 字号
 *
 *  @return 返回字体对象
 */
#define WLFONT(X)                 [UIFont systemFontOfSize:X]

/**
 *  系统加粗字体
 *
 *  @param X 字号
 *
 *  @return 返回字体对象
 */
#define WLFONTBLOD(X)             [UIFont boldSystemFontOfSize:X]

/*
 4.字体大小
 */
//常用的19号粗体
#define kNormalBlod19Font [UIFont boldSystemFontOfSize:19.f]
//常用的18号粗体
#define kNormalBlod18Font [UIFont boldSystemFontOfSize:18.f]
//常用的17号字体
#define kNormal17Font [UIFont systemFontOfSize:17.f]

//常用的16号粗体
#define kNormalBlod16Font [UIFont boldSystemFontOfSize:16.f]
//常用的16号字体
#define kNormal16Font [UIFont systemFontOfSize:16.f]

//常用的15号粗体
#define kNormalBlod15Font [UIFont boldSystemFontOfSize:15.f]
//常用的15号字体
#define kNormal15Font [UIFont systemFontOfSize:15.f]

//常用的14号粗体
#define kNormalBlod14Font [UIFont boldSystemFontOfSize:14.f]
//常用的14号字体
#define kNormal14Font [UIFont systemFontOfSize:14.f]

//常用的13号粗体
#define kNormalBlod13Font [UIFont boldSystemFontOfSize:13.f]
//常用的13号字体
#define kNormal13Font [UIFont systemFontOfSize:13.f]

//常用的12号粗体
#define kNormalBlod12Font [UIFont boldSystemFontOfSize:12.f]
//常用的12号字体
#define kNormal12Font [UIFont systemFontOfSize:12.f]

#define kNormal11Font [UIFont systemFontOfSize:11.f]


/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Redefine

#define MainScreen                          [UIScreen mainScreen]
#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)

#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)

#define StatusBarHeight                     (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

#define ViewCtrlTopBarHeight                (kIOS7Later ? kWL_NormalNavBarHeight + StatusBarHeight : kWL_NormalNavBarHeight)
#define IsUseIOS7SystemSwipeGoBack          (kIOS7Later ? YES : NO)
//加载行高度
#define LoadingCellHeight                   (ScreenHeight - ViewCtrlTopBarHeight - kWL_NromalTabbarHeight - kWL_NormalNavBarHeight)
#define LoadingCellAllScreeHeight           ScreenHeight - ViewCtrlTopBarHeight


// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

// image STRETCH
#define WL_STRETCH_IMAGE(image, edgeInsets) (kSystemVersion < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])

#endif
