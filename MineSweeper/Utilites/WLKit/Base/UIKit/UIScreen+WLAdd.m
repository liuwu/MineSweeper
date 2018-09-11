//
//  UIScreen+WLAdd.m
//  Welian
//
//  Created by weLian on 16/5/19.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UIScreen+WLAdd.h"
#import "UIDevice+WLAddForInfo.h"
#import "WLCGUtilities.h"

WLSYNTH_DUMMY_CLASS(UIScreen_WLAdd)

@implementation UIScreen (WLAdd)

/**
 *  交换高度与宽度
 */
static inline CGSize SizeSWAP(CGSize size) {
    return CGSizeMake(size.height, size.width);
}

///UIScreen的大小
+ (CGSize)wl_size {
    return [[UIScreen mainScreen] bounds].size;
}

///UIScreen的宽度
+ (CGFloat)wl_width {
    return [[UIScreen mainScreen] bounds].size.width;
}

///UIScreen的高度
+ (CGFloat)wl_height {
    return [[UIScreen mainScreen] bounds].size.height;
}

///UIScreen的纵向的大小
+ (CGSize)wl_orientationSize {
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion]
                             doubleValue];
    BOOL isLand =   UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    return (systemVersion>8.0 && isLand) ? SizeSWAP([UIScreen wl_size]) : [UIScreen wl_size];
}

///UIScreen的纵向的宽度
+ (CGFloat)wl_orientationWidth {
    return [UIScreen wl_orientationSize].width;
}

///UIScreen的纵向的高度
+ (CGFloat)wl_orientationHeight {
    return [UIScreen wl_orientationSize].height;
}

///UIScreen的分辨率下的大小
+ (CGSize)wl_DPISize {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    return CGSizeMake(size.width * scale, size.height * scale);
}

/**
 MainScreen的scale
 */
+ (CGFloat)wl_screenScale {
    return [self screenScale];
}

/**
 当前设置方向的屏幕边界
 @查看    boundsForOrientation:
 */
- (CGRect)wl_currentBounds {
    return [self currentBounds];
}

/**
 给定的设备方向的屏幕的边界。UIScreen的bounds方法总是返回纵向方向的画面边界。
 @查看  currentBounds
 */
- (CGRect)wl_boundsForOrientation:(UIInterfaceOrientation)orientation {
    return [self boundsForOrientation:orientation];
}

/**
 屏幕的实际大小（宽度总是小于高度）。
 这个值在位置的设备或模拟器中可能不是很准确。
 例： (768,1024)
 */
- (CGSize)wl_sizeInPixel {
    CGSize size = CGSizeZero;
    
    if ([[UIScreen mainScreen] isEqual:self]) {
        NSString *model = [UIDevice currentDevice].wl_machineModel;
        if ([model hasPrefix:@"iPhone"]) {
            if ([model hasPrefix:@"iPhone1"]) size = CGSizeMake(320, 480);
            else if ([model hasPrefix:@"iPhone2"]) size = CGSizeMake(320, 480);
            else if ([model hasPrefix:@"iPhone3"]) size = CGSizeMake(640, 960);
            else if ([model hasPrefix:@"iPhone4"]) size = CGSizeMake(640, 960);
            else if ([model hasPrefix:@"iPhone5"]) size = CGSizeMake(640, 1136);
            else if ([model hasPrefix:@"iPhone6"]) size = CGSizeMake(640, 1136);
            else if ([model hasPrefix:@"iPhone7,1"]) size = CGSizeMake(1080, 1920);
            else if ([model hasPrefix:@"iPhone7,2"]) size = CGSizeMake(750, 1334);
            else if ([model hasPrefix:@"iPhone8,1"]) size = CGSizeMake(1080, 1920);
            else if ([model hasPrefix:@"iPhone8,2"]) size = CGSizeMake(750, 1334);
            else if ([model hasPrefix:@"iPhone8,4"]) size = CGSizeMake(640, 1136);
        } else if ([model hasPrefix:@"iPod"]) {
            if ([model hasPrefix:@"iPod1"]) size = CGSizeMake(320, 480);
            else if ([model hasPrefix:@"iPod2"]) size = CGSizeMake(320, 480);
            else if ([model hasPrefix:@"iPod3"]) size = CGSizeMake(320, 480);
            else if ([model hasPrefix:@"iPod4"]) size = CGSizeMake(640, 960);
            else if ([model hasPrefix:@"iPod5"]) size = CGSizeMake(640, 1136);
            else if ([model hasPrefix:@"iPod7"]) size = CGSizeMake(640, 1136);
        } else if ([model hasPrefix:@"iPad"]) {
            if ([model hasPrefix:@"iPad1"]) size = CGSizeMake(768, 1024);
            else if ([model hasPrefix:@"iPad2"]) size = CGSizeMake(768, 1024);
            else if ([model hasPrefix:@"iPad3"]) size = CGSizeMake(1536, 2048);
            else if ([model hasPrefix:@"iPad4"]) size = CGSizeMake(1536, 2048);
            else if ([model hasPrefix:@"iPad5"]) size = CGSizeMake(1536, 2048);
            else if ([model hasPrefix:@"iPad6,3"]) size = CGSizeMake(1536, 2048);
            else if ([model hasPrefix:@"iPad6,4"]) size = CGSizeMake(1536, 2048);
            else if ([model hasPrefix:@"iPad6,7"]) size = CGSizeMake(2048, 2732);
            else if ([model hasPrefix:@"iPad6,8"]) size = CGSizeMake(2048, 2732);
        }
    }
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        if ([self respondsToSelector:@selector(nativeBounds)]) {
            size = self.nativeBounds.size;
        } else {
            size = self.bounds.size;
            size.width *= self.scale;
            size.height *= self.scale;
        }
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    }
    return size;
}

/**
 屏幕的PPI.
 这个值在位置的设备或模拟器中可能不是很准确。
 默认值是 96.
 */
- (CGFloat)wl_pixelsPerInch {
    return [self pixelsPerInch];
}

@end
