//
//  UIImage+WLAdd.m
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import "UIImage+WLAdd.h"

#import <ImageIO/ImageIO.h>
#import <CoreText/CoreText.h>
#import <Accelerate/Accelerate.h>
#import "WLCGUtilities.h"
#import <ZBarSDK/ZBarReaderController.h>

WLSYNTH_DUMMY_CLASS(UIImage_WLAdd)

@implementation UIImage (WLAdd)

/**
 *  @author dong, 16-03-30 12:03:15
 *
 *  @brief 生成二维码图片
 *
 *  @param qrString QR sring
 *  @param squareWidth  正方形边长
 *
 *  @return 返回QR image
 */
+ (UIImage *)wl_createQRImageFormString:(NSString *)qrString sizeSquareWidth:(CGFloat)squareWidth;
{
    return [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:qrString] sizeSquareWidth:squareWidth];
}

#pragma mark - InterpolatedUIImage
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image sizeSquareWidth:(CGFloat)squareWidth {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(squareWidth/CGRectGetWidth(extent), squareWidth/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
/**
 *  @author dong, 16-03-30 14:03:24
 *
 *  @brief 字符串转为CIImage
 *
 *  @param qrString
 *
 *  @return 返回CIImage
 */
+ (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - 图片拉伸
// 返回能够自由拉伸不变形的图片
+ (UIImage *)wl_resizedImage:(NSString *)name {
    return [self wl_resizedImage:name leftScale:0.5 topScale:0.5];
}

+ (UIImage *)wl_resizedImage:(NSString *)name
                   leftScale:(CGFloat)leftScale
                    topScale:(CGFloat)topScale {
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width*leftScale topCapHeight:image.size.height*topScale];
}

#pragma mark - Snapshot
// 生成一个磨砂透明图片
+ (UIImage *)wl_blurredSnapshot:(UIView*)view {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)), NO, 1.0f);
    [view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Now apply the blur effect using Apple's UIImageEffect category
    //    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    UIImage *blurredSnapshotImage = [snapshotImage wl_applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    return blurredSnapshotImage;
}

- (UIImage *)wl_applyLightEffect {
    UIColor *tintColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    return [self wl_applyBlurWithRadius:15.0f tintColor:tintColor saturationDeltaFactor:1.8f maskImage:nil];
}

- (UIImage *)wl_applyExtraLightEffect {
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self wl_applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)wl_applyDarkEffect {
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self wl_applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)wl_applyTintEffectWithColor:(UIColor *)tintColor {
    const CGFloat EffectColorAlpha = 0.1;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self wl_applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}


- (UIImage *)wl_applyBlurWithRadius:(CGFloat)blurRadius
                          tintColor:(UIColor *)tintColor
              saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                          maskImage:(nullable UIImage *)maskImage {
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}


- (UIImage*)wl_scaleFromImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= newSize.width && height <= newSize.height){
        return image;
    }
    
    if (width == 0 || height == 0){
        return image;
    }
    
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - Create image
///=============================================================================
/// @name 创建图片
///=============================================================================


/**
 *  @author dong, 16-09-14 10:09:42
 *
 *  @brief 以图片名加载图片 并以图片原色为准不会根据系统色改变
 *
 *  @param name 图片名
 */
+ (nullable UIImage *)wl_imageNameAlwaysOriginal:(NSString *)name {
    if (!name.length) return nil;
    return [[UIImage imageNamed:name] wl_alwaysOriginal];
}

- (nullable UIImage*)wl_alwaysOriginal {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
 通过GIF数据创建一个动画的图片。创建后，你可以访问图像通过属性".images"。
 如果数据不是GIF动画，这个方法和[UIImage imageWithData:data scale:scale]是一样的;
 
 @讨论   它有一个更好的显示性能，但花费更多的内存(宽度*高度*帧字节)。
 它只适合于显示小的GIF动画表情等。如果你想显示大图片，查看"WLImage"。
 
 @param data     GIF 数据.
 @param scale    The scale factor
 @return 从GIF中创建一个新的图片, or nil when an error occurs.
 */
+ (nullable UIImage *)wl_imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale {
    return [self imageWithSmallGIFData:data scale:scale];
}

/**
 数据是否是GIF动画
 */
+ (BOOL)wl_isAnimatedGIFData:(NSData *)data {
    return [self isAnimatedGIFData:data];
}

/**
 指定路径的文件是否是GIF.
 */
+ (BOOL)wl_isAnimatedGIFFile:(NSString *)path {
    return [self isAnimatedGIFFile:path];
}

/**
 从PDF文件数据或路径创建一个图片
 @讨论 如果PDF多页，只是返回第一页的内容。图像的比列等于当前屏幕的比例，大小和PDF的源尺寸大小相同.
 @param dataOrPath PDF数据`NSData`, 或PDF文件路径`NSString`.
 */
+ (nullable UIImage *)wl_imageWithPDF:(id)dataOrPath {
    return [self imageWithPDF:dataOrPath];
}

/**
 从PDF文件数据或路径创建一个图片
 @讨论 如果PDF多页，只是返回第一页的内容。图像的比列等于当前屏幕的比例，大小和PDF的源尺寸大小相同.
 */
+ (nullable UIImage *)wl_imageWithPDF:(id)dataOrPath size:(CGSize)size {
    return [self imageWithPDF:dataOrPath size:size];
}

/**
 从苹果的emoji表情创建一个方的图片
 
 @讨论 它从苹果的emoji表情创建一个方形的图片，图像的比例和当前屏幕的比例相同。
 原来的表情图像在`AppleColorEmoji`字体是在160*160像素大小.
 
 @param emoji 单个表情符号, 如 @"😄".
 @param size  图片的大小.
 @return 表情图片, or nil when an error occurs.
 */
+ (nullable UIImage *)wl_imageWithEmoji:(NSString *)emoji size:(CGFloat)size {
    return [self imageWithEmoji:emoji size:size];
}

/**
 用给定的颜色创建并返回一个1*1大小的图像
 @param color  颜色.
 */
+ (nullable UIImage *)wl_imageWithColor:(UIColor *)color {
    return [self imageWithColor:color];
}

/**
 用指定的颜色和大小创建一个纯彩色图像。
 
 @param color  颜色.
 @param size   新图片的大小.
 */
+ (nullable UIImage *)wl_imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self imageWithColor:color size:size];
}

/**
 用自定义绘制代码创建并返回一个图像。
 
 @param size      图像大小.
 @param drawBlock 绘制块.
 @return 新的图像.
 */
+ (nullable UIImage *)wl_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock {
    return [self imageWithSize:size drawBlock:drawBlock];
}

#pragma mark - Image Info
///=============================================================================
/// @name 图片信息
///=============================================================================

/**
 返回该图片是否有透明度通道
 */
- (BOOL)wl_hasAlphaChannel {
    return [self hasAlphaChannel];
}


#pragma mark - Modify Image
///=============================================================================
/// @name 修改图片
///=============================================================================
/**
 在指定的矩形区域内绘制图像，用contentMode改变内容。
 
 @讨论 该方法在当前的图像上下文中绘制图像，遵守图像的方向设置。
 在默认坐标系中,图像在指定的矩形区域的位置。该方法适用于当前图形的任何变换。
 
 @param rect        绘制图像的区域.
 @param contentMode 绘制模式
 @param clips       一个BOOL值用来确定内容局限在矩形区域。
 */
- (void)wl_drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clips {
    [self drawInRect:rect withContentMode:contentMode clipsToBounds:clips];
}

/**
 从这个图像的缩放返回一个新的图像。图像根据需要将被拉伸。
 @param size  要缩放的新的尺寸，值必须为正值.
 @return      给定大小的新图像.
 */
- (nullable UIImage *)wl_imageByResizeToSize:(CGSize)size {
    return [self imageByResizeToSize:size];
}

/**
 返回一个从这个图像缩放的新的图像。图像内容将通过contentMode改变。
 
 @param size        要缩放的新尺寸，应为正.
 @param contentMode 图像内容模式.
 @return 给定大小的新图像.
 */
- (nullable UIImage *)wl_imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    return [self imageByResizeToSize:size contentMode:contentMode];
}

/**
 返回一个从这个图像截取的新的图像
 
 @param rect  图像内部区域.
 @return      新的图像, or nil if an error occurs.
 */
- (nullable UIImage *)wl_imageByCropToRect:(CGRect)rect {
    return [self imageByCropToRect:rect];
}

/**
 返回一个从图像边缘插图的新图像
 
 @param insets  每一个边缘的插图(正), 值可以是“负”开始.
 @param color   边的填充颜色, nil means clear color.
 @return        新的图像, or nil if an error occurs.
 */
- (nullable UIImage *)wl_imageByInsetEdge:(UIEdgeInsets)insets withColor:(nullable UIColor *)color {
    return [self imageByInsetEdge:insets withColor:color];
}

/**
 用给定的圆角大小圈一个新的图片
 @param radius 每个角点的半径.
 */
- (nullable UIImage *)wl_imageByRoundCornerRadius:(CGFloat)radius {
    return [self imageByRoundCornerRadius:radius];
}

/**
 用给定的圆角大小圈一个新的图片
 
 @param radius       每个角点的半径.
 @param borderWidth  边框线宽度.
 @param borderColor  边框的笔画颜色. nil指clear color.
 */
- (nullable UIImage *)wl_imageByRoundCornerRadius:(CGFloat)radius
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor {
    return [self imageByRoundCornerRadius:radius borderWidth:borderWidth borderColor:borderColor];
}

/**
 用给定的圆角大小圈一个新的图片
 
 @param radius       每个角点的半径.
 @param corners      你想圆角的值的标识。你可以用这个参数来设置圆角的子集。
 @param borderWidth  边框线宽度.
 @param borderColor  边框的笔画颜色. nil指clear color.
 @param borderLineJoin 边界线.
 */
- (nullable UIImage *)wl_imageByRoundCornerRadius:(CGFloat)radius
                                          corners:(UIRectCorner)corners
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor
                                   borderLineJoin:(CGLineJoin)borderLineJoin {
    return [self imageByRoundCornerRadius:radius corners:corners borderWidth:borderWidth borderColor:borderColor borderLineJoin:borderLineJoin];
}

/**
 返回一个旋转后的新图像（相对于中心）
 
 @param radians   逆时针旋转的弧度.⟲
 @param fitSize   YES: 新的图像的大小,用来适应所有内容. NO:图像的大小不改变，内容可能被裁剪。
 */
- (nullable UIImage *)wl_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize {
    return [self imageByRotate:radians fitSize:fitSize];
}

/**
 返回一个逆时针旋转（90°）的新图像. ⤺
 宽度和高度将被交换。
 */
- (nullable UIImage *)wl_imageByRotateLeft90 {
    return [self imageByRotateLeft90];
}

/**
 返回一个顺时针旋转1/4转(90°)的新图像. ⤼
 宽度和高度将被交换。
 */
- (nullable UIImage *)wl_imageByRotateRight90 {
    return [self imageByRotateRight90];
}

/**
 返回一个旋转180°的新图像. ↻
 */
- (nullable UIImage *)wl_imageByRotate180 {
    return [self imageByRotate180];
}

/**
 返回一个垂直翻转的图像. ⥯
 */
- (nullable UIImage *)wl_imageByFlipVertical {
    return [self imageByFlipVertical];
}

/**
 返回一个水平翻转的图像. ⇋
 */
- (nullable UIImage *)wl_imageByFlipHorizontal {
    return [self imageByFlipHorizontal];
}


#pragma mark - Image Effect
///=============================================================================
/// @name 图像效果
///=============================================================================
/**
 给定颜色渲染图片的alpha通道
 */
- (nullable UIImage *)wl_imageByTintColor:(UIColor *)color {
    return [self imageByTintColor:color];
}

/**
 返回一个灰色缩放的图像
 */
- (nullable UIImage *)wl_imageByGrayscale {
    return [self imageByGrayscale];
}

/**
 给该图像应用模糊效果。适用于模糊任何内容。
 */
- (nullable UIImage *)wl_imageByBlurSoft {
    return [self imageByBlurSoft];
}

/**
 对这个图像进行模糊效果。适用于模糊任何内容，除了纯白色。（同IOS控制面板）
 */
- (nullable UIImage *)wl_imageByBlurLight {
    return [self imageByBlurLight];
}

/**
 对这个图像应用模糊效果。适用于显示黑色文本。（同IOS导航条白色）
 */
- (nullable UIImage *)wl_imageByBlurExtraLight {
    return [self imageByBlurExtraLight];
}

/**
 对这个图像应用模糊效果。适用于显示白色文本。（同ios的通知中心）
 */
- (nullable UIImage *)wl_imageByBlurDark {
    return [self imageByBlurDark];
}

/**
 对这个图像应用模糊和颜色效果。
 */
- (nullable UIImage *)wl_imageByBlurWithTint:(UIColor *)tintColor {
    return [self imageByBlurWithTint:tintColor];
}

/**
 对这个图像应用模糊，色彩和饱和度调整颜色，可选的指定区域内通过maskImage.
 
 @param blurRadius     模糊点的半径，0意味着没有模糊效果.
 @param tintColor      一个可选的UIColor对象是混合模糊和饱和操作的结构。
 这个颜色的aplha通道决定了该颜色的强色彩。nil指没有色彩。
 @param tintBlendMode  一个tintColo混合模式。默认是kCGBlendModeNormal (0).
 @param saturation     一个1的值在产生的图像中没有变化。值小于1会减得到的图像而大于1的值会产生相反的效果。0指灰色规模。
 @param maskImage      如果指定，inputImage是一个定义的可以修改的区域。这必须是一个图像遮盖或必须满足CGContextClipToMask的遮盖
 @return               图像效果, or nil if an error occurs (如. 没有足够的内存).
 */
- (nullable UIImage *)wl_imageByBlurRadius:(CGFloat)blurRadius
                                 tintColor:(nullable UIColor *)tintColor
                                  tintMode:(CGBlendMode)tintBlendMode
                                saturation:(CGFloat)saturation
                                 maskImage:(nullable UIImage *)maskImage {
    return [self imageByBlurRadius:blurRadius tintColor:tintColor tintMode:tintBlendMode saturation:saturation maskImage:maskImage];
}

+ (UIImage *)imageNamedForAdaptation:(NSString *)imageName {
    NSString *realImageName = [NSString stringWithFormat:@"%@_iPhone5", imageName];
    if (iPhone6And6s) {
        // 当前设备是iPhone6
        realImageName = [NSString stringWithFormat:@"%@_iPhone6", imageName];
    }else if (iPhone6plusAnd6splus) {
        // 当前设备是iPhone6P
        realImageName = [NSString stringWithFormat:@"%@_iPhone6P", imageName];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:realImageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)imageWithText:(NSString *)text{
    /**
     这里之所以外面再放一个UIView，是因为直接用label画图的话，旋转就不起作用了
     */
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, ScreenWidth/2)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = WLRGBA(153, 153, 153, 0.3);
    label.numberOfLines = 0;
    label.text = text;
    label.transform = CGAffineTransformMakeRotation(-M_PI/6.0);
    label.font = WLFONT(14);
    [view addSubview:label];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSString *)decodeQRImage {
    NSString *qrResult = nil;
    UIImage *qrImage = self;
    if (self.size.width < 640) {
        //!!!! 拉伸的处理原因
        qrImage = [self imageByResizeToSize:CGSizeMake(640, 640)];
    }
    ZBarReaderController *read = [ZBarReaderController new];
    CGImageRef cgImageRef = qrImage.CGImage;
    ZBarSymbol* symbol = nil;
    for(symbol in [read scanImage:cgImageRef]) break;
    qrResult = symbol.data ;
    return qrResult;
}

+ (UIImage *)wl_horiCombineImages: (NSArray<UIImage *> *)images distance: (CGFloat)distance {
    if (images.count == 0) {
        return nil;
    }
    CGFloat w = 0.0;
    CGFloat h = 0.0;
    for (UIImage *image in images) {
        w += image.size.width + distance;
        h = MAX(h, image.size.height);
    }
    w -= distance;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, [UIScreen mainScreen].scale);
    CGFloat x = 0;
    for (UIImage *image in images) {
        CGFloat y = (h - image.size.height) * 0.5;
        [image drawInRect:CGRectMake(x, y, image.size.width, image.size.height)];
        x += image.size.width + distance;
    }
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)wl_drawRectWithRoundedCorner: (CGFloat)radius {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIBezierPath * besizePath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(context, besizePath.CGPath);
    CGContextClip(context);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    UIGraphicsEndImageContext();
    return image;
}

@end
